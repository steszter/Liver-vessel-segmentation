function [improvedMask] = improveLiverMask(liverMask)
    %improve liver mask by hole filling
    disp('Improving mask...')
    SE = strel('disk',20, 0);
    liverMask = logical(liverMask);
    for i=1: size(liverMask,3)
        slice = liverMask(:,:,i);
        if(sum(slice(:)) > 0)
            liverMask(:,:,i) = imclose(liverMask(:,:,i), SE);
            liverMask(:,:,i) = imfill(liverMask(:,:,i),'holes');
        end
    end
    improvedMask = imfill(liverMask,'holes');
    disp('Mask improvement done...')
end

