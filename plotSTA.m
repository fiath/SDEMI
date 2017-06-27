function plotSTA(fig,unit)
%PLOTSTA Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    if unit < 1
        unit = 1;
    elseif unit > size(handles.data,3)
        unit = size(handles.data,3);
    end
    data = handles.data(:,:,unit);
    ax = handles.axes1;
    cla(ax);
    min_v = min(data(:));
    max_v = max(data(:));
    rangeX = size(data,2)-1;
    rangeY = max([abs(max_v),abs(min_v)])*2*1.1;
    c = handles.column;
    r = ceil(size(data,1)/c); % necessary number of rows
    for i=1:r
        for j=1:c
            if (i-1)*c + j <= size(data,1)
                offsetX = (j-1)*rangeX;
                offsetY = (r-i)*rangeY;
                plot(ax,offsetX:1:(offsetX+rangeX),data((i-1)*c+j,:) + offsetY + rangeY/2,'Color','black');
                hold(ax,'on');
            end
        end
    end
    set(ax,'XTick',linspace(0,c*rangeX,c+1));
    set(ax,'YTick',linspace(0,r*rangeY,r+1));
    set(ax,'XTickLabel',[]);
    set(ax,'YTickLabel',[]);
    grid(ax,'on');
    set(ax,'XLim',[0,c*rangeX]);
    set(ax,'YLim',[0,r*rangeY]);
    handles.unit = unit;
    set(handles.dropDown,'Value',unit);
    guidata(fig,handles);
    
    [~,min_pos] = min(min(data));
    plotHeatmap(fig,min_pos);
    
    % plot autocorrelation
    evFilePath = handles.unitNames{handles.unit};
    evFilePath = [handles.dirpath,strtok(evFilePath,'.'),'.ev2'];
    acorr = loadAutoCorr(evFilePath,20,30);
    bar(handles.autocorr,[-30:-1,1:30],acorr,'histc');
    xlim(handles.autocorr,[-30,30]);
    h = findobj(handles.autocorr,'Type','line');
    set(h,'Marker','none'); 
end

