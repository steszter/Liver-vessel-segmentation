function drawGraph(skel,node,link, isDrawName)
    w = size(skel,1);
    l = size(skel,2);
    h = size(skel,3);
    
    colorList = ['r', 'g', 'b', 'c', 'm'];

    % display result
    figure()
    hold on;
    for i=1:length(node)
        x1 = node(i).comx;
        y1 = node(i).comy;
        z1 = node(i).comz;

        if(node(i).ep==1) %node is endpoint
            ncol = 'c';
            msize = 5;
        else %otherwise
            ncol = 'y';
            msize = 5;
        end

        for j=1:length(node(i).links)    % draw all connections of each node

            % draw edges as lines using voxel positions
            for k=1:length(link(node(i).links(j)).point)-1            
                [x3,y3,z3]=ind2sub([w,l,h],link(node(i).links(j)).point(k));
                [x2,y2,z2]=ind2sub([w,l,h],link(node(i).links(j)).point(k+1));
                if (link(node(i).links(j)).color > 0 && link(node(i).links(j)).color ~= 100)
                    if (link(node(i).links(j)).color < 6)
                        linkColor = colorList(link(node(i).links(j)).color);
                    else
                        remainder = rem(link(node(i).links(j)).color,5);
                        if(remainder > 0)
                            linkColor = colorList(remainder);
                        else
                            linkColor = colorList(5);
                        end
                    end
                else
                    linkColor = 'k';
                end
                line([y3 y2],[x3 x2],[z3 z2],'Color',linkColor,'LineWidth',2);
            end           
        end

        % draw all nodes as yellow circles
        plot3(y1,x1,z1,'o','Markersize',msize,...
        'MarkerFaceColor',ncol,...
        'Color','k');
        if(isDrawName)
            text(y1,x1,z1,string(i));  
        end 
    end
    axis image;
    set(gca,'visible','on')
    set(gcf,'Color','white');
    drawnow;
    view(-50,20)
end

