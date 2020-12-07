function [J1] = regionGrowingAutoThreshold(V,seedX,seedY,seedZ)
    %region growing with automatic threshold selection
    
    thresVal = 1;
    maxThresValue = 20;
    proportion = 0;
    listOfThresValues = [];
    listOfNumOfPixels = [];
    listOfProportions = [];

    while (thresVal <= 60 && proportion <= 0.06)
        [~, J1, proportion] = regionGrowing(V,[seedX seedY seedZ],thresVal,Inf, false, true, true);
        numPixels = length(find(J1));
        if(numPixels >= 50000 && numPixels <= 100000)
            listOfThresValues = [listOfThresValues, thresVal];
            listOfNumOfPixels = [listOfNumOfPixels, numPixels];
            listOfProportions = [listOfProportions, proportion];
        elseif(numPixels < 50000)
            maxThresValue = thresVal;
            maxNumOfPixel = numPixels;
            maxProportion = proportion;
        end
        thresVal = thresVal + 1;
    end

    if(length(listOfNumOfPixels)>= 2)
        jump(1) = 0;
        for i = 2: size(listOfNumOfPixels,2)
            jump(i) = listOfNumOfPixels(i) - listOfNumOfPixels(i-1);
        end
        [~, maxIndices] = maxk(jump,1);
        chosenThresVal = listOfThresValues(maxIndices);
        disp(['Chosen threshold value: ' num2str(chosenThresVal)]);
        [~, J1, proportion1] = regionGrowing(V,[seedX seedY seedZ],chosenThresVal,Inf, false, true, true);
    elseif(~isempty(listOfNumOfPixels))
        chosenThresVal = listOfThresValues(1);
        disp(['Chosen threshold value: ' num2str(chosenThresVal)]);
        [~, J1, proportion1] = regionGrowing(V,[seedX seedY seedZ],chosenThresVal,Inf, false, true, true);
    else
        disp(['Chosen threshold value: ' num2str(maxThresValue)]);
        [~, J1, proportion1] = regionGrowing(V,[seedX seedY seedZ],maxThresValue,Inf, false, true, true);
    end
end

