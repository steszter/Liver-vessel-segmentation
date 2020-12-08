function [skel,skelColored] = Graph2Skel3D(node,link,w,l,h, isColored)
%Modified version

    % create binary image
    skel = false(w,l,h);

    % for all nodes
    for i=1:length(node)
        if(~isempty(node(i).links)) % if node has links
            skel(node(i).idx)=true; % node voxels
            a = [link(node(i).links(node(i).links>0)).point];
            if(~isempty(a))
                skel(a)=1; % edge voxels
            end
        end
    end
    
    skelColored = zeros(w,l,h);
    
    if(isColored)
        % for all nodes
        for i=1:length(node)
            if(~isempty(node(i).links)) % if node has links
                if(node(i).color ~= 0)
                    skelColored(node(i).idx)=node(i).color; % node voxels
                else
                    skelColored(node(i).idx)=0;
                end
                for j= 1:length(node(i).links)
                     a = [link(node(i).links(j)).point];
                    if(~isempty(a))
                        skelColored(a)=link(node(i).links(j)).color; % edge voxels
                    end
                end
            end
        end
    end
end

