function plotClusterView(clfig,unit,spikeId,pos)
%PLOTCUSTERVIEW Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(clfig);
    rawHandles = guidata(handles.rawfig);
    if unit < 1 || unit > length(handles.unitNames)
        throw('Invalid unit');
    end
    spikes = handles.eventFiles(handles.unitNames{unit}).spikes;
    spike = spikes(spikeId); % position of the spike in datapoints
    window = handles.range+spike;
    windowSize = handles.range(2)-handles.range(1);
    if window(1) < 1
        window(1) = 1;
        window(2) = windowSize;
    end
    if window(2) > rawHandles.datafile.length
        window(2) = rawHandles.datafile.length;
        window(1) = window(2) - windowSize + 1;
    end
    data = 0.195*double(rawHandles.datafile.file.Data.x(:,window(1):window(2)));
    data = detrend(data','linear')';
    groups = handles.groups;
    for i=1:length(groups)
        plotGroup(handles.(groups{i}),i,data,pos);
    end

    guidata(clfig,handles);
end

function plotGroup(group,groupId,data,pos)
    ax = group.axes;
    % currently use global scale (same scale in all groups)
    [min_v,min_index] = min(data(:));
    [max_v,max_index] = max(data(:));
    rangeX = size(data,2)-1; % window size
    rangeY = max_v-min_v;%max([abs(max_v),abs(min_v)])*2*1.1;
    plotZero = abs(min_v); % rangeY/2
    c = group.conf(1);
    r = group.conf(2);
    hm_data = zeros(r,c);
    for i=1:r
        for j=1:c
            channel = (i-1)*c+j+group.offset;
            if channel <= size(data,1)
                offsetX = (j-1)*rangeX;
                offsetY = (r-i)*rangeY;
                set(group.lines(j,i),'Visible','on');
                set(group.lines(j,i),'XData',offsetX:1:(offsetX+rangeX));
                set(group.lines(j,i),'YData',data(channel,:) + offsetY + plotZero);
                hold(ax,'on');
            else
                set(group.lines(j,i),'Visible','off');
            end
            if channel <= size(data,1)
                hm_data(i,j) = data(channel,pos);
            else
                hm_data(i,j) = nan;
            end
        end
    end
    set(group.image,'XData',[0.5 group.conf(1)-0.5]);
    set(group.image,'YData',[0.5 group.conf(2)-0.5]);
    set(group.image,'CData',hm_data);
    set(group.heatmap,'XLim',[0 group.conf(1)]);
    set(group.heatmap,'YLim',[0 group.conf(2)]);
    set(group.image,'alphadata',~isnan(hm_data));
    caxis(group.heatmap,[min_v,max_v]);
    set(ax,'XTick',linspace(0,c*rangeX,c+1));
    set(ax,'YTick',linspace(0,r*rangeY,r+1));
    set(ax,'XTickLabel',[]);
    set(ax,'YTickLabel',[]);
    grid(ax,'on');
    set(ax,'XLim',[0,c*rangeX]);
    set(ax,'YLim',[0,r*rangeY]);
    set(ax,'TickLength',[ 0 0 ]);
    
    % move lines to the proper position
    for i=1:length(group.positionLines)
        set(group.positionLines(i),'XData',[(i-1)*rangeX (i-1)*rangeX]+pos);
        set(group.positionLines(i),'YData',[0 r*rangeY]);
    end
end

