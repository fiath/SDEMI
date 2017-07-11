function datafile = updateWindow(handles,newWindow,force)
        if handles.datafile.windowUpdating
            datafile = handles.datafile;
            return;
        end
        handles.datafile.windowUpdating = 1;
        guidata(handles.figure1,handles);
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
        %drawnow
        datafile.dataWindow = newWindow;
        datafile.centerString = timeToString(round((datafile.dataWindow(1) + ...
            datafile.dataWindow(2))/2*1000/datafile.samplingRate),...
            handles.datafile.timeFormat);
        set(handles.positionEditText,'String',datafile.centerString);
        datafile.windowSize = datafile.dataWindow(2)-datafile.dataWindow(1)+1;
        datafile.windowUpdating = 0;
        
        % we don't need pivotline
        % update pivot line
        %center = round((datafile.dataWindow(1) + datafile.dataWindow(2))/2/datafile.samplingRate);
        %delete(datafile.pivotLine);
        %datafile.pivotLine = line(ax,[center,center],get(ax,'YLim'));
        

function window = checkDataWindow(datafile,window)
    size = min([datafile.length,datafile.maxWindowSize,window(2) - window(1)+1]);
    if size < 0
        error('newDataWindow.size cannot be negative');
    end
    center = floor((window(1) + window(2))/2);
    window(1) = center - ceil(size/2)+1;
    window(2) = window(1) + size-1;
    if window(1) < 0
        window(1) = 0;
        window(2) = size-1;
    end
    if window(2) >= datafile.length
        window(2) = datafile.length-1;
        window(1) = window(2) - size+1;
    end
    
 function datafile = updateBuffer(ax,datafile,newWindow,force)
    center = floor((newWindow(1) + newWindow(2))/2 - datafile.bufferStart);
    while ~force && datafile.bufferEnd ~= 0
        if newWindow(1) < datafile.bufferStart
            break;
        end
        if newWindow(2) > datafile.bufferEnd-1
            break;
        end
        % we already have a valid buffer
        if center > floor(datafile.loadStart*datafile.bufferSize) && center < floor(datafile.loadEnd*datafile.bufferSize)
            % we don't have to update the buffer
            return
        end
        if center <= floor(datafile.loadStart*datafile.bufferSize) && datafile.bufferStart == 0
            % we have no data before
            return
        end
        if center >= floor(datafile.loadEnd*datafile.bufferSize) && datafile.bufferEnd == datafile.length
            % we have no data after
            return
        end
    end
    drawnow;
    tic;
    datafile.bufferSize = (newWindow(2)-newWindow(1)+1)*2;
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
    fprintf('Reading from %d to %d, a total of %d\n',beginBuffer+1,endBuffer,datafile.bufferSize);
    datafile.buffer = 0.195*int32(datafile.file.Data.x(:,beginBuffer+1:endBuffer)).';
    % if filter is active carry out high-pass filtering
    if datafile.filter.on
        datafile.buffer = filter(datafile.filter.B,datafile.filter.A,...
                                    datafile.buffer);
        datafile.buffer = flipud(datafile.buffer);
        datafile.buffer = filter(datafile.filter.B,datafile.filter.A,...
                                    datafile.buffer);
        datafile.buffer = flipud(datafile.buffer);
    end
    next_active_offset = 1;
    for i=1:datafile.numberOfChannels
        if datafile.activeChannels(i)
            datafile.buffer(:,i) = datafile.buffer(:,i) + next_active_offset*datafile.channelSpacing;
            next_active_offset = next_active_offset + 1;
        end
    end
    % get size of ax in pixels
    fig = get(ax,'Parent');
    figPos = get(fig,'Position');
    axPos = get(ax,'Position');
    xSize = axPos(3)*figPos(3); % size of axes in pixels
    dataPerPixel = floor((newWindow(2)-newWindow(1)+1)/xSize);
    fprintf('DataPerPixel: %d\n',dataPerPixel);
    %dataPerPixel = 0;
    datafile.dataResolution = dataPerPixel;
    if dataPerPixel > 8
        newBuffer = zeros(2*ceil(datafile.bufferSize/dataPerPixel),datafile.numberOfChannels);
        for i=1:size(newBuffer,1)/2-1
            for j=1:datafile.numberOfChannels
                if datafile.activeChannels(j)
                    newBuffer(i*2-1,j) = min(datafile.buffer((((i-1)*dataPerPixel)+1):(i*dataPerPixel),j));
                    newBuffer(i*2,j) = max(datafile.buffer((((i-1)*dataPerPixel)+1):(i*dataPerPixel),j));
                end
            end
        end
        i = size(newBuffer,1)/2;
        for j=1:datafile.numberOfChannels
            if datafile.activeChannels(j)
                newBuffer(i*2-1,j) = min(datafile.buffer((((i-1)*dataPerPixel)+1):end,j));
                newBuffer(i*2,j) = max(datafile.buffer((((i-1)*dataPerPixel)+1):end,j));   
            end
        end
        datafile.buffer = newBuffer;
    end
    cla(ax);
    x = linspace(beginBuffer/datafile.samplingRate,endBuffer/datafile.samplingRate,size(datafile.buffer,1));
%     interX = linspace(beginBuffer/datafile.samplingRate,endBuffer/datafile.samplingRate,size(datafile.buffer,1)*2/dataPerPixel);
    holdOnCalled = 0;
    for i=1:datafile.numberOfChannels
         if ~datafile.activeChannels(i)
             continue;
         end
%         if dataPerPixel > 8
%             interY = interp1(x,double(datafile.buffer(:,i).'),interX);
%             datafile.channelLines(i) = plot(ax,interX,interY,'Color','black','hittest','off');
%         else
%             datafile.channelLines(i) = plot(ax,x,datafile.buffer(:,i).','Color','black','hittest','off');
%         end
        datafile.channelLines(i) = plot(ax,x,datafile.buffer(:,i).','Color','black','hittest','off');
        %set(datafile.channelLines(i),'ButtonDownFcn',{@onchannelclickHandler,i});
        % not neccessary for line
        if holdOnCalled == 0
            hold(ax,'on');
            holdOnCalled = 1;
        end
    end
    % place whole lines at each second and dashed lines at each 200ms mark
    wholeLinePos = floor(beginBuffer/datafile.samplingRate):ceil(endBuffer/datafile.samplingRate);
    dashedLinePos = floor(beginBuffer/datafile.samplingRate):0.2:ceil(endBuffer/datafile.samplingRate);
    for i=1:length(dashedLinePos)
        line(ax,[dashedLinePos(i),dashedLinePos(i)],...
                [datafile.maxYLimDiff(1)+datafile.channelSpacing,datafile.maxYLimDiff(2) + ...
                (next_active_offset-1)*datafile.channelSpacing],'Color',[0.2 0.2 0.2],'LineStyle','--','hittest','off');
    end
    for i=1:length(wholeLinePos)
        line(ax,[wholeLinePos(i),wholeLinePos(i)],...
                [datafile.maxYLimDiff(1)+datafile.channelSpacing,datafile.maxYLimDiff(2) + ...
                (next_active_offset-1)*datafile.channelSpacing],'Color',[0 0 0],'hittest','off');
    end
    set(ax,'YTickLabel',[]);
    yticks((1:(next_active_offset-1))*datafile.channelSpacing);
%     ax = gca;
    datafile.bufferStart = beginBuffer;
    datafile.bufferEnd = endBuffer;
    drawnow;
    fprintf('Finished reading. ');toc
   
   
