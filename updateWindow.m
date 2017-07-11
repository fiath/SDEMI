function datafile = updateWindow(handles,newWindow,force)
        if nargin < 3
            force = 0;
        end
        ax = handles.axes1;
        datafile = handles.datafile;
        newWindow = checkDataWindow(datafile,newWindow);
        datafile = updateBuffer(ax,datafile,newWindow,force);
        startWindow = newWindow(1);      
        endWindow = newWindow(2);
        fprintf('Start: %d, End: %d\n',startWindow,endWindow);
%         axes(handles.axes1);
%         cla
        datafile.ylim = CheckYLim(datafile.ylim,datafile);
        set(ax,'YLim',datafile.ylim);
        set(ax,'XLim',[newWindow(1)/datafile.samplingRate,newWindow(2)/datafile.samplingRate]);
        datafile.dataWindow = newWindow;
        datafile.centerString = timeToString(round((datafile.dataWindow(1) + ...
            datafile.dataWindow(2))/2*1000/datafile.samplingRate),...
            handles.datafile.timeFormat);
        set(handles.positionEditText,'String',datafile.centerString);
        datafile.windowSize = datafile.dataWindow(2)-datafile.dataWindow(1);
        
        % we don't need pivotline
        % update pivot line
        %center = round((datafile.dataWindow(1) + datafile.dataWindow(2))/2/datafile.samplingRate);
        %delete(datafile.pivotLine);
        %datafile.pivotLine = line(ax,[center,center],get(ax,'YLim'));
        

function window = checkDataWindow(datafile,window)
    size = min([datafile.length,datafile.maxWindowSize,window(2) - window(1)]);
    if size < 0
        error('newDataWindow.size cannot be negative');
    end
    center = floor((window(1) + window(2))/2);
    window(1) = center - ceil(size/2);
    window(2) = center + floor(size/2);
    if window(1) < 0
        window(1) = 0;
        window(2) = size;
    end
    if window(2) >= datafile.length
        window(2) = datafile.length-1;
        window(1) = window(2) - size;
    end
    
 function datafile = updateBuffer(ax,datafile,newWindow,force)
    center = floor((newWindow(1) + newWindow(2))/2 - datafile.bufferStart);
    if ~force && datafile.bufferEnd ~= 0
        % we already have a valid buffer
        if center > datafile.loadStart && center < datafile.loadEnd
            % we don't have to update the buffer
            return
        end
        if center <= datafile.loadStart && datafile.bufferStart == 0
            % we have no data before
            return
        end
        if center >= datafile.loadEnd && datafile.bufferEnd == datafile.length
            % we have no data after
            return
        end
    end
    % center the buffer at center
    global_center = floor((newWindow(1) + newWindow(2))/2);
    beginBuffer = max(0,global_center - floor(datafile.bufferSize/2));
    endBuffer = min(datafile.length,global_center + ceil(datafile.bufferSize/2));
    if beginBuffer == 0
        endBuffer = datafile.bufferSize;
    end
    if endBuffer == datafile.length
        beginBuffer = datafile.length - datafile.bufferSize;
    end
    datafile.buffer = 0.195*int32(datafile.file.Data.x(:,beginBuffer+1:endBuffer))';
    % if filter is active carry out high-pass filtering
    if datafile.filter.on
        datafile.buffer = filter(datafile.filter.B,datafile.filter.A,...
                                    datafile.buffer,[],2);
        datafile.buffer = fliplr(datafile.buffer);
        datafile.buffer = filter(datafile.filter.B,datafile.filter.A,...
                                    datafile.buffer,[],2);
        datafile.buffer = fliplr(datafile.buffer);
    end
    next_active_offset = 1;
    for i=1:datafile.numberOfChannels
        if datafile.activeChannels(i)
            datafile.buffer(:,i) = datafile.buffer(:,i) + next_active_offset*datafile.channelSpacing;
            next_active_offset = next_active_offset + 1;
        end
    end
    cla(ax);
    x = linspace(beginBuffer/datafile.samplingRate,endBuffer/datafile.samplingRate,size(datafile.buffer,1));
    for i=1:datafile.numberOfChannels
         if ~datafile.activeChannels(i)
             continue;
         end
        datafile.channelLines(i) = plot(ax,x,datafile.buffer(:,i),'Color','black');
        set(datafile.channelLines(i),'ButtonDownFcn',{@onchannelclickHandler,i});
        hold on;
    end
    % place whole lines at each second and dashed lines at each 200ms mark
    wholeLinePos = floor(beginBuffer/datafile.samplingRate):ceil(endBuffer/datafile.samplingRate);
    dashedLinePos = floor(beginBuffer/datafile.samplingRate):0.2:ceil(endBuffer/datafile.samplingRate);
    for i=1:length(dashedLinePos)
        line(ax,[dashedLinePos(i),dashedLinePos(i)],...
                [datafile.maxYLimDiff(1)+datafile.channelSpacing,datafile.maxYLimDiff(2) + ...
                (next_active_offset-1)*datafile.channelSpacing],'Color',[0.2 0.2 0.2],'LineStyle','--');
    end
    for i=1:length(wholeLinePos)
        line(ax,[wholeLinePos(i),wholeLinePos(i)],...
                [datafile.maxYLimDiff(1)+datafile.channelSpacing,datafile.maxYLimDiff(2) + ...
                (next_active_offset-1)*datafile.channelSpacing],'Color',[0 0 0]);
    end
    set(ax,'YTickLabel',[]);
    yticks((1:(next_active_offset-1))*datafile.channelSpacing);
%     ax = gca;
    datafile.bufferStart = beginBuffer;
    datafile.bufferEnd = endBuffer;
   
   
