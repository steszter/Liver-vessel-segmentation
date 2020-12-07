function [improvedResult] = improveRegionGrowingResult(result)
    %improve region growing result
    
    disp('Improving segmentation...');
    SE = strel('sphere',2);
    result = imclose(result, SE);
    for i=1: size(result,3)
        slice = result(:,:,i);
        if(sum(slice(:)) > 0)
            SE = strel('disk',1);
            result = imopen(result, SE);
            result(:,:,i) = imfill(slice,'holes');
        end
    end
    
    result = imfill(result,'holes');

    improvedResult = bwareaopen(logical(result), 5000, 26);
    disp('Improvement done...');
end

