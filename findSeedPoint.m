function [SliceForSeed, seedX, seedY, seedZ] = findSeedPoint(Volume)
    Volume = uint8(Volume);
    index = 0;
    numOfLiverPixels = [];
    %count number of liver pixels for every slice
    for i=1:size(Volume,3)
        slice = Volume(:,:,i);
        numOfLiverPixels = [numOfLiverPixels, numel(slice(slice > 0))];
    end
    
    %get 50 slices with the biggest liver region
    [max50Values, max50Index] = maxk(numOfLiverPixels, 50);
    
    %highlight vessels with Jerman and get slice with max intensities based
    %on that
    maxValue = -10;
    for i = 1:length(max50Index)
        output = vesselness2D(Volume(:,:,max50Index(i)), 1:4, [1;1;1], 0.6, true);
        sumIntensities = sum(output(:));
        if(sumIntensities > maxValue)
            maxValue = sumIntensities;
            index = max50Index(i);
            maxNumOfPixels = max50Values(i);
        end
    end
    
    SliceForSeed = Volume(:,:,index);
    %find pixels with intensity in top 2%
    numberOfTop2 = round(maxNumOfPixels * 0.02);
    maxValues = maxk(SliceForSeed(:),numberOfTop2);
    seedXCandidates = [];
    seedYCandidates = [];
    for i=1:length(maxValues)
        [XCandidate, YCandidate] = find(SliceForSeed == maxValues(i),1, 'first');
        seedXCandidates = [seedXCandidates,XCandidate];
        seedYCandidates = [seedYCandidates,YCandidate];
    end
   
    seedX = 0;
    seedY = 0;
    seedZ = index;
    
    %get seed pixel
    for i=1:length(seedXCandidates)
        %pixel with seed pixel candidates around it
        if (ismember(seedXCandidates(i)-1, seedXCandidates) && ...
            ismember(seedXCandidates(i)+1, seedXCandidates) && ...
            ismember(seedYCandidates(i)-1, seedYCandidates) && ...
            ismember(seedYCandidates(i)+1, seedYCandidates) )
        
            seedX = seedXCandidates(i);
            seedY = seedYCandidates(i);
            break;
        end
    end
    
    if(seedX == 0 && seedY == 0)
        for i=1:length(seedXCandidates)
            %pixel with not null pixels around it
            if(seedXCandidates(i) > 1 && seedYCandidates(i) > 1)
                if (Volume((seedXCandidates(i)-1),seedYCandidates(i),seedZ) ~= 0 && ...
                    Volume((seedXCandidates(i)+1),seedYCandidates(i),seedZ) ~= 0 && ...
                    Volume(seedXCandidates(i),(seedYCandidates(i)-1),seedZ) ~= 0 && ...
                    Volume(seedXCandidates(i),(seedYCandidates(i)+1),seedZ) ~= 0 )

                    seedX = seedXCandidates(i);
                    seedY = seedYCandidates(i);
                    break;
                else
                    seedX = seedXCandidates(i);
                    seedY = seedYCandidates(i);
                end
            end
        end
    end
end

