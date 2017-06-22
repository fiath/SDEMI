function plotSTA(fig,unit)
%PLOTSTA Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    data = handles.data(:,:,unit);
    ax = handles.axes1;
    cla(ax);
    min_v = min(data(:));
    max_v = max(data(:));
    rangeX = size(data,2)-1;
    rangeY = max([abs(max_v),abs(min_v)])*2*1.1;
    for i=1:32
        for j=1:4
            offsetX = (j-1)*rangeX;
            offsetY = (32-i)*rangeY;
            plot(ax,offsetX:1:(offsetX+rangeX),data((i-1)*4+j,:) + offsetY + rangeY/2,'Color','black');
            hold(ax,'on');
        end
    end
    set(ax,'XTick',linspace(0,4*rangeX,5));
    set(ax,'YTick',linspace(0,32*rangeY,33));
    set(ax,'XTickLabel',[]);
    set(ax,'YTickLabel',[]);
    grid(ax,'on');
    set(ax,'XLim',[0,4*rangeX]);
    set(ax,'YLim',[0,32*rangeY]);
    handles.unit = unit;
    set(handles.dropDown,'Value',unit);
    guidata(fig,handles);
end

