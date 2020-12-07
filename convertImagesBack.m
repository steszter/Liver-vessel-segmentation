function [newImage] = convertImagesBack(volume,isRotated)
%function for niiFiles read by niftiread
%changes back orientation of images
%inputs:
%volume: images (3D) to be rotated
%isRotated: boolean, true if images were rotated for MATLAB use,
%false if there were no modifications after using niftiread
    newImage = volume;
    if(isRotated)
        for i=1:size(volume,3)
            newImage(:,:,i) = volume(:,:,i)';
        end
    else
        for i=1:size(volume,3)
            newImage(:,:,i) = flipud(volume(:,:,i));
        end
    end
end

