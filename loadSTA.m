function loadSTA(fig)
%LOADSTA Summary of this function goes here
%   Detailed explanation goes here

    handles = guidata(fig);

    startdir = handles.datafile.filedir(1:end-1);
    startdir = startdir(1:find(startdir=='/',1,'last')-1);
    dirpath = uigetdir(startdir,'Select the directory containing the .mat files');
    if dirpath == 0
        return;
    end
    
    dirpath = [dirpath '/'];
    dataList = dir([dirpath '*.mat']);
    if isempty(dataList)
        % directory contains no .mat files.
        return
    end
    
    if isgraphics(handles.stafig)
        close(handles.stafig);
    end
    
    % set up gui
    stafig = matlab.hg.internal.openfigLegacy('sta', 'reuse', 'visible');
    set(stafig,'CloseRequestFcn',@closeHandler);
    set(stafig,'ResizeFcn',@resizeHandler);
    set(stafig,'WindowScrollWheelFcn',@scrollHandler);
    set(stafig,'WindowButtonDownFcn',@stafigButtonDownHandler);
    set(stafig,'WindowButtonMotionFcn',@stafigMouseMoveHandler);
    set(stafig,'WindowKeyPressFcn',@staKeydownHandler);
    handles.stafig = stafig;
    set(handles.traceview,'Enable','off');
    guidata(fig,handles);
    handles = struct('rawfig',fig);
    handles.stafig = stafig;
    handles.column = 4;
    handles.lines = gobjects(1,handles.column);
    handles.axes1 = findobj(stafig,'Tag','axes1');
    handles.heatmap = findobj(stafig,'Tag','axes2');
    handles.globalSave = findobj(stafig,'Tag','save');
    handles.totalDP = findobj(stafig,'Tag','totaldatapoints');
    handles.currDP = findobj(stafig,'Tag','currentdatapoint');
    handles.autocorr = findobj(stafig,'Tag','autocorr');
    handles.spikenumber = findobj(stafig,'Tag','spikenumber');
    handles.spikefrequency = findobj(stafig,'Tag','spikefrequency');
    handles.spikemin = findobj(stafig,'Tag','spikemin');
    handles.spikemax = findobj(stafig,'Tag','spikemax');
    set(handles.currDP,'Callback',@currDPHandler);
    set(handles.globalSave,'Callback',@saveFigure);
    hold(handles.axes1,'all');
    handles.heatCtxMenu = uicontextmenu(handles.stafig);
    topmenu = uimenu('Parent',handles.heatCtxMenu,'Label','Save image','Callback',@saveImage);
    %set(handles.heatmap,'ButtonDownFcn',@buttonDownHandler);
    handles.position = -1; % in datapoints
    colormap(handles.heatmap,'jet');
    
    
    
    
    % read data
    handles.data = [];
    handles.unit = -1;
    handles.dirpath = dirpath;
    name = dataList(1).name;
    suffix = name(length(strtok(name,'.'))+1:length(name));
    ids = zeros(1,length(dataList));
    for i=1:length(dataList)
        ids(i) = str2double(strtok(dataList(i).name,'.'));
    end
    ids = sort(ids);
    handles.unitNames = cell(1,length(dataList));
    for i = 1:length(ids)
       data = load([dirpath num2str(ids(i)) suffix]);
       handles.unitNames{i} = [num2str(ids(i)) suffix];
       handles.data = cat(3,handles.data,data.meanSpikeWaveformDetrended);
    end
    handles.dropDown = findobj(stafig,'Tag','unitselector');
    set(handles.dropDown,'String',handles.unitNames);
    set(handles.dropDown,'Callback',@dropdownHandler);
    guidata(stafig,handles);
    set(handles.dropDown,'Value',1);
    set(handles.totalDP,'String',['/ ',num2str(size(handles.data,2))]);
    plotSTA(stafig,1);
end

function closeHandler(hObject,~,~)
    handles = guidata(hObject);
    rawfig = handles.rawfig;
    handles = guidata(rawfig);
    handles.stafig = gobjects;
    set(handles.traceview,'Enable','on');
    guidata(rawfig,handles);
    delete(hObject);
end

function dropdownHandler(hObject,~,~)
    handles = guidata(hObject);
    plotSTA(handles.stafig,get(hObject,'Value'));
end

function resizeHandler(hObject,~,~)
    % reposition dropdown menu
    handles = guidata(hObject);
    
    axPos = get(handles.axes1,'Position');
    figPos = get(handles.stafig,'Position');
    
    pos = get(handles.dropDown,'Position');
    width = pos(3);
    height = pos(4);
    top = (axPos(2) + axPos(4))*figPos(4);
    center = (axPos(1) + axPos(3)/2)*figPos(3);
    set(handles.dropDown,'Position',[center - width/2,top + 5,width,height]);
    
    
    % reposition datapoint windows (currDP, totalDP)
    hPos =  get(handles.heatmap,'Position');
    currPos = get(handles.currDP,'Position');
    totPos = get(handles.totalDP,'Position');
    cw = currPos(3);
    ch = currPos(4);
    hTop = (hPos(2) + hPos(4))*figPos(4);
    hCenter = (hPos(1) + hPos(3)/2)*figPos(3);
    set(handles.currDP,'Position',[hCenter - cw,hTop + 5,cw,ch]);
    set(handles.totalDP,'Position',[hCenter + 8,hTop + 9,totPos(3:4)]);
end

function scrollHandler(hObject,eventdata,~)
    handles = guidata(hObject);
    C = get (handles.axes1, 'CurrentPoint');
    XLim = get(handles.axes1, 'XLim');
    YLim = get(handles.axes1, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        wfScrollHandler(hObject,eventdata.VerticalScrollCount);
        return;
    end
    
    C = get (handles.heatmap, 'CurrentPoint');
    XLim = get(handles.heatmap, 'XLim');
    YLim = get(handles.heatmap, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2) && isfield(handles.heatmap,'ScrollFcn')
        handles.heatmap.ScrollFcn(hObject,eventdata.VerticalScrollCount);
        return;
    end
end

function buttonDownHandler(hObject,eventdata,~)
    fprintf('Waveform clicked\n');
end

function stafigButtonDownHandler(hObject,eventdata,~)
    % expects left mouse click but will work with right click as well
    handles = guidata(hObject);
    C = get (handles.axes1, 'CurrentPoint');
    XLim = get(handles.axes1, 'XLim');
    YLim = get(handles.axes1, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        % clicked inside axes1
        pos = rem(C(1,1),size(handles.data,2)-1);
        pos = floor(pos);
        plotHeatmap(handles.stafig,pos);
    end
end

function stafigMouseMoveHandler(hObject,eventdata,~)
end
