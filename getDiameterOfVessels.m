function [diameterVolume, minDiameter, maxDiameter] = getDiameterOfVessels(mask,skeleton)
    distance = 2 * bwdist(~mask);
    diameterVolume = distance .* double(skeleton);
    diameterVolume = double(diameterVolume);
    [~,~,notNullDiameter] = find(diameterVolume);
    minDiameter = min(notNullDiameter(:));
    maxDiameter = max(notNullDiameter(:));
end

