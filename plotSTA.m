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
    [min_v,min_index] = min(data(:));
    [max_v,max_index] = max(data(:));
    rangeX = size(data,2)-1;
    rangeY = max_v-min_v;%max([abs(max_v),abs(min_v)])*2*1.1;
    plotZero = abs(min_v); % rangeY/2
    c = handles.column;
    r = ceil(size(data,1)/c); % necessary number of rows
    for i=1:r
        for j=1:c
            if (i-1)*c + j <= size(data,1)
                offsetX = (j-1)*rangeX;
                offsetY = (r-i)*rangeY;
                plot(ax,offsetX:1:(offsetX+rangeX),data((i-1)*c+j,:) + offsetY + plotZero,'Color','red','LineWidth',1);
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
    set(ax,'TickLength',[ 0 0 ])
    handles.unit = unit;
    handles.crossCorrUnit = unit;
    set(handles.dropDown,'Value',unit);
    set(handles.corrSelector,'Value',unit);
    % if manual is not active
    if get(handles.heatmapRangeManual,'Value') == get(handles.heatmapRangeManual,'Min')
        handles.heatmapRange = [];
    end
    guidata(fig,handles);
    
    [~,min_pos] = min(min(data));
    plotHeatmap(fig,min_pos);
   
    
    % plot autocorrelation 30 ms and 1ms binSize by default
    plotCrossCorr(fig,handles.numOfBins,handles.binSize,handles.unit);
    
    unitName = handles.unitNames{handles.unit};
    evFilePath = [handles.dirpath,strtok(unitName,'.'),'.ev2'];
    numOfSpikes = length(getSpikes(fig,evFilePath));
    
    %output information
    traceHandles = guidata(handles.rawfig);
    % lenght of the recording in seconds
    if isfield(handles,'measurementLength')
        time = handles.measurementLength;
    else
        time = traceHandles.datafile.length/traceHandles.datafile.samplingRate;
    end
    set(handles.spikenumber,'String',['Number of spikes: ',num2str(numOfSpikes)]);
    if time < 0
        % .dat file is not loaded
        set(handles.spikefrequency,'String',['Spiking frequency: -']);
    else
        set(handles.spikefrequency,'String',['Spiking frequency: ',num2str(numOfSpikes/time),'Hz']);
        % .dat file is loaded
    end
    [min_channel,min_index] = ind2sub(size(data),min_index);
    [max_channel,max_index] = ind2sub(size(data),max_index);
    set(handles.spikemax,'String',['Maximum: ',num2str(max_v),' at ',num2str(max_index),'@',num2str(max_channel)]);
    set(handles.spikemin,'String',['Minimum: ',num2str(min_v),' at ',num2str(min_index),'@',num2str(min_channel)]);
    
    %update traceview's spikeLines
    setActiveEventFile(handles.rawfig,evFilePath);
end

