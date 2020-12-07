function [niiFileImg, niiFileImgSeg] = readFile(fileName, fileNameSegmentation)
%read CT images with file format .nii or .nii.gz
    niiFileImg = niftiread(fileName);
    niiFileImgSeg = niftiread(fileNameSegmentation);
end

