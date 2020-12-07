function [] = LiverVesselSegmentation(fileName,segmentationFileName)
    %% Segment liver vessels and separate hepatic and portal vein with
    %% colors
    % Inputs:
    % fileName: name of .nii file with liver CT
    % segmentationFileName: name of .nii file with liver segmentation for
    % the first input
    %
    % Outputs: 
    % vesselSegmentation_liver.nii: file with segmented vessels
    % coloredVesselSegmentation_liver.nii: file with segmented vessels
    % where hepatic vein and portal vein branches are marked with colors
    % 

    %% read file
    [niiFileImg, niiFileImgSeg] = readFile(fileName, segmentationFileName);

    %% improve mask by filling inner holes
    niiFileImgSeg = improveLiverMask(niiFileImgSeg);

    %% convert images
    disp('Filtering images...')
    [~, Vmasked] = convertImagesForMatlab(niiFileImg, niiFileImgSeg,false,true);
    disp('Filtering done')

    %% find seedpoint for region growing
    [~, seedX, seedY, seedZ] = findSeedPoint(Vmasked);

    %% region growing
    [result] = regionGrowingAutoThreshold(Vmasked,seedX,seedY,seedZ);

    finalResult = result;
    while(length(find(finalResult)) < 50000)
        Vnew = Vmasked .* uint8(finalResult);
        VforSeedPoint = Vmasked - Vnew;
        if(length(find(VforSeedPoint)) > length(find(Vnew)))
            [~, X, Y, Z] = findSeedPoint(VforSeedPoint);
            J1 = regionGrowingAutoThreshold(Vmasked, X, Y, Z);
        else
            break;
        end
        finalResult = logical(finalResult) + logical(J1);
    end

    regionGrowingResult = improveRegionGrowingResult(finalResult);

    J1 = convertImagesBack(regionGrowingResult, true);
    niftiwrite(single(J1), 'vesselSegmentation_liver.nii');

    %% get the skeleton
    skel = skeleton3D(logical(regionGrowingResult));

    %% calculate diameter of vessels
    [diameterVolume, ~, ~] = getDiameterOfVessels(uint8(regionGrowingResult), skel);

    %% create graph
    skel = logical(skel);
    [~,node,link] = skel2Graph3DWithDiameter(skel,0,diameterVolume);

    %% color vessel segments
    [skel2,node2,link2, skelColored] = separatePVandHV(skel,node,link);
    
    drawGraph(skel2,node2,link2, false);axis off;

    skelColored = uint8(skelColored);

    coloredVesselModel = findNearestVoxels(skelColored,regionGrowingResult);
    
    J1 = convertImagesBack(coloredVesselModel, true);
    niftiwrite(single(J1), 'coloredVesselSegmentation_liver.nii');
end

