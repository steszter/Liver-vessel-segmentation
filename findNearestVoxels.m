function [Model] = findNearestVoxels(skeleton,mask)
    Model = zeros(size(mask));
    [d1,d2,d3] = size(skeleton);
    [dim1,dim2,dim3] = size(mask);
    skelIndices = [];
    maskIndices = [];
    skelLinIndices = find(skeleton);
    maskLinIndices = find(mask);
    [x,y,z] = ind2sub([d1 d2 d3],skelLinIndices);
    [i,j,k] = ind2sub([dim1 dim2 dim3],maskLinIndices);
    for l=1:size(x)
        skelIndices = [skelIndices; [x(l), y(l), z(l)]];
    end
    for l=1:size(i)
        maskIndices = [maskIndices; [i(l), j(l), k(l)]];  
    end
    for maskIndex = 1: size(maskIndices,1)
        distances = sqrt(sum(bsxfun(@minus, maskIndices(maskIndex,:), skelIndices).^2,2));
        minSkelIndex = skelIndices(find(distances==min(distances),1),:);
        minMaskIndex = maskIndices(maskIndex,:);
        Model(minMaskIndex(1), minMaskIndex(2), minMaskIndex(3)) = skeleton(minSkelIndex(1),minSkelIndex(2),minSkelIndex(3));
    end
end

