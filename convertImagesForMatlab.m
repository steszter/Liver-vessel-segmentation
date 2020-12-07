function [I, Imasked] = convertImagesForMatlab(niiFileImg, niiFileImgSeg, isNormalize, isFilter)
%converts niiFile CT images for MATLAB use, filter & cuts out segment based on the
%given segmentation
%
%inputs:
%niiFileImg: volume of CT scan images
%niiFileImgSeg: segmentation of niiFileImg volume (binary mask)
%
%outputs:
%I: normalized or filtered CT images
%Imasked: normalized or filtered CT images with only the segmented region based on given mask
%

    if(isNormalize)
        minV=-135;
        maxV=215;
    end
    
    [d1,d2,d3]=size(niiFileImg);

    I = zeros(d2,d1,d3);
    Imasked = zeros(d2,d1,d3);
    for k=1:d3
        slice=niiFileImg(:,:,k);
        imgSlice=rot90((slice),3);
        
        sliceSeg = niiFileImgSeg(:,:,k);
        imgSliceSeg = rot90((sliceSeg),3);

        dImgSlice = (double(imgSlice));
        
        %normalize images based on min and max value
        if(isNormalize)
            normSlice = 255*(dImgSlice-minV)/(maxV-minV);
        end

        %use bitonic filter
        if(isFilter)
            normSlice = uint8(dImgSlice); 
            if(sum(imgSliceSeg(:)) > 0)
                normSlice = bitonic2(normSlice, 3);
            end
        end
      
        saveIt = zeros(size(normSlice));
        if(sum(imgSliceSeg(:)) > 0)
            for i = 1:size(normSlice,1)
                for j = 1:size(normSlice,2)
                    saveIt(i,j) =  normSlice(i,j);                   
                end
            end     
        end
        
        I(:,:,k) = saveIt;
% 
%         figure(1);
%         subplot(1,2,1),imshow(uint8(saveIt(:,:)));
%         subplot(1,2,2),imshow(uint8(imgSlice(:,:)));
        
        saveIt = zeros(size(normSlice));
        for i = 1:size(normSlice,1)
            for j = 1:size(normSlice,2)
                if(imgSliceSeg(i,j) > 0)
                    saveIt(i,j) =  normSlice(i,j);                   
                end
            end
        end
        
        Imasked(:,:,k) = saveIt;

%         figure(1);
%         subplot(1,2,1),imshow(uint8(saveIt(:,:)));
%         subplot(1,2,2),imshow(uint8(imgSlice(:,:)));
    end
    
    I = uint8(I);
    Imasked = uint8(Imasked);
end

