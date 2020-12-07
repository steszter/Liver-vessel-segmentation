function [skel2,node,link, skelColored] = separatePVandHV(skel,node,link)
    allDiameters = [];
    for i=1:length(link)
        allDiameters = [allDiameters, link(i).diameter];
    end

    meanDiameter = round(mean(allDiameters, 'all'));

    coloredLinkIdxs = [];
    for i = 1:length(link)
        if(round(link(i).diameter) > meanDiameter)
            link(i).color = 1;
            node(link(i).n1).color = 1;
            node(link(i).n2).color = 1;
            coloredLinkIdxs = [coloredLinkIdxs, i];
        end
    end
    
    for i=1:length(link)
        if(link(i).color == 0 && length(link(i).point) < 10 ...
                && node(link(i).n1).color ~= 0 && node(link(i).n2).color ~= 0)
            link(i).color = 1;
            node(link(i).n1).color = 1;
            node(link(i).n2).color = 1;
            coloredLinkIdxs = [coloredLinkIdxs, i];
        end
    end
    
    for i = 1:length(link)
        if(link(i).color == 0 && length(link(i).point) < 10)
            if(node(link(i).n1).color ~= 0)
                for j = 1:length(link)
                    if(link(j).color == 0 && i ~= j && length(link(j).point) < 10 && ...
                            ((link(j).n1 == link(i).n2 && node(link(j).n2).color ~= 0) || ...
                            (link(j).n2 == link(i).n2 && node(link(j).n1).color ~= 0)))
                        link(i).color = 1;
                        link(j).color = 1;
                        node(link(i).n1).color = 1;
                        node(link(i).n2).color = 1;
                        node(link(j).n1).color = 1;
                        node(link(j).n2).color = 1;
                        coloredLinkIdxs = [coloredLinkIdxs, i, j];
                        break;
                    end
                end
            elseif(node(link(i).n2).color ~= 0)
                for j = 1:length(link)
                    if(link(j).color == 0 && i ~= j && length(link(j).point) < 10 && ...
                            ((link(j).n1 == link(i).n1 && node(link(j).n2).color ~= 0) || ...
                            (link(j).n2 == link(i).n1 && node(link(j).n1).color ~= 0)))
                        link(i).color = 1;
                        link(j).color = 1;
                        node(link(i).n1).color = 1;
                        node(link(i).n2).color = 1;
                        node(link(j).n1).color = 1;
                        node(link(j).n2).color = 1;
                        coloredLinkIdxs = [coloredLinkIdxs, i, j];
                        break;
                    end
                end
            end
        end
    end
    
    colorIndex = 2;
    isLinkLeft = true;
    isColorMore = true;
    chosenLinks = [];
    while (isLinkLeft)
        chosenLinkIdx = coloredLinkIdxs(1);
        link(chosenLinkIdx).color = colorIndex;
        node(link(chosenLinkIdx).n1).color = colorIndex;
        node(link(chosenLinkIdx).n2).color = colorIndex;
        chosenLinks = [chosenLinks, chosenLinkIdx];
        
        while (isColorMore)
            newChosenLinkIdxs = [];
            for i = 1 : length(chosenLinks)
                chosenLinkIdx = chosenLinks(i);
                for coloredIdx = 1:length(coloredLinkIdxs)
                    if(link(coloredLinkIdxs(coloredIdx)).color ~= colorIndex && ...
                      (link(coloredLinkIdxs(coloredIdx)).n1 == link(chosenLinkIdx).n1 || ...
                      link(coloredLinkIdxs(coloredIdx)).n1 == link(chosenLinkIdx).n2 || ...
                       link(coloredLinkIdxs(coloredIdx)).n2 == link(chosenLinkIdx).n1 || ...
                       link(coloredLinkIdxs(coloredIdx)).n2 == link(chosenLinkIdx).n2))
                        
                        link(coloredLinkIdxs(coloredIdx)).color = colorIndex;
                        node(link(coloredLinkIdxs(coloredIdx)).n1).color = colorIndex;
                        node(link(coloredLinkIdxs(coloredIdx)).n2).color = colorIndex;
                        newChosenLinkIdxs = [newChosenLinkIdxs,coloredLinkIdxs(coloredIdx)];
                    end
                end
            end
            linksLeftIdxs = [];
            for idx = 1:length(coloredLinkIdxs)
                if(link(coloredLinkIdxs(idx)).color ~= colorIndex)
                    linksLeftIdxs = [linksLeftIdxs, coloredLinkIdxs(idx)]; 
                end
            end
            
            if (~isempty(newChosenLinkIdxs) && ~isempty(linksLeftIdxs))
                coloredLinkIdxs = linksLeftIdxs;
                chosenLinks = newChosenLinkIdxs;
            else
                isColorMore = false;
            end  
        end
        if  (~isempty(linksLeftIdxs))
            coloredLinkIdxs = linksLeftIdxs;
            colorIndex = colorIndex + 1;
            isColorMore = true;
        else
            isLinkLeft = false;
        end
    end
    
    isNotAllColored = true;
    while (isNotAllColored)
        for nodeIdx = 1:length(node)
            if(node(nodeIdx).color ~= 0)
                for j = 1:length(node(nodeIdx).links)
                    if(link(node(nodeIdx).links(j)).n1 ~= nodeIdx && ...
                            (node(link(node(nodeIdx).links(j)).n1).color == 0 || ...
                            node(link(node(nodeIdx).links(j)).n1).color == node(nodeIdx).color))
                       link(node(nodeIdx).links(j)).color = node(nodeIdx).color;
                       node(link(node(nodeIdx).links(j)).n1).color = node(nodeIdx).color;
                    elseif (link(node(nodeIdx).links(j)).n2 ~= nodeIdx && ...
                            (node(link(node(nodeIdx).links(j)).n2).color == 0 || ...
                            node(link(node(nodeIdx).links(j)).n2).color == node(nodeIdx).color))
                        link(node(nodeIdx).links(j)).color = node(nodeIdx).color;
                        node(link(node(nodeIdx).links(j)).n2).color = node(nodeIdx).color;
                    end
                end
            end
        end
        
        isNotAllColored = false;
        for i = 1: length(node)
            if (node(i).color == 0)
                isNotAllColored = true;
                break;
            end
        end
    end
    
    colors = [];
    numOfColors = 0;
    for i=1:length(link)
        if (~ismember(link(i).color,colors) && link(i).color ~= 0)
            numOfColors = numOfColors + 1;
            colors = [colors, link(i).color];
        end
    end
    
    maxColor = 0;
    numOfMaxColor = 0;
    voxelNumPerColor = zeros(size(1,numOfColors));
    for i = 1:numOfColors
        numOfColoredVoxels = 0;
        for j= 1: length(link)
            if(link(j).color == colors(i))
                numOfColoredVoxels = numOfColoredVoxels + length(link(j).point);
            end
        end
        voxelNumPerColor(i) = numOfColoredVoxels;
        if(numOfColoredVoxels > numOfMaxColor)
            numOfMaxColor = numOfColoredVoxels;
            maxColor = colors(i);
        end
    end

    allVoxels = sum(voxelNumPerColor, 'all');
    if (numOfMaxColor >= (allVoxels - numOfMaxColor))
        for i = 1:length(node)
            if (node(i).color ~= maxColor)
                node(i).color = maxColor + 1;
            end
        end
        
        for i = 1:length(link)
            if (link(i).color ~= maxColor && ...
                    (link(i).color ~= 0 || (link(i).color == 0 && node(link(i).n1).color == node(link(i).n2).color)))
                link(i).color = maxColor + 1;
            end
        end
    end
    
    w2 = size(skel,1);
    l2 = size(skel,2);
    h2 = size(skel,3);

    [skel2, skelColored] = Graph2Skel3D(node,link,w2,l2,h2, true);
end

