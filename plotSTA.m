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
    numOfBins = 30;
    binSize =20;
    evFilePath = handles.unitNames{handles.unit};
    evFilePath = [handles.dirpath,strtok(evFilePath,'.'),'.ev2'];
    acorr = loadAutoCorr(evFilePath,binSize,numOfBins);
    numOfSpikes = acorr(numOfBins+1);
    acorr(numOfBins+1) = 0; % zero out the total number of spikes
    bar(handles.autocorr,-numOfBins:numOfBins,acorr,'hist');
    % dont put space because [-1 - 1] is NOT [-2] but [-1, -1]
    xlim(handles.autocorr,[-numOfBins-1,numOfBins+1]);
    h = findobj(handles.autocorr,'Type','line');
    set(h,'Marker','none'); 
    
    %output information
    traceHandles = guidata(handles.rawfig);
    % lenght of the recording in seconds
    time = traceHandles.datafile.length/traceHandles.datafile.samplingRate;
    set(handles.spikenumber,'String',['Number of spikes: ',num2str(numOfSpikes)]);
    set(handles.spikefrequency,'String',['Spiking frequency: ',num2str(numOfSpikes/time),'Hz']);
    [~,min_index] = ind2sub(size(data),min_index);
    [~,max_index] = ind2sub(size(data),max_index);
    set(handles.spikemax,'String',['Maximum: ',num2str(max_v),' at ',num2str(max_index)]);
    set(handles.spikemin,'String',['Minimum: ',num2str(min_v),' at ',num2str(min_index)]);
end

