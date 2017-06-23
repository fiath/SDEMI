function loadSTA(fig)
%LOADSTA Summary of this function goes here
%   Detailed explanation goes here

    dirpath = uigetdir('','Select the directory containing the .mat files');
    if dirpath == 0
        return;
    end
    
    % set up gui
    handles = guidata(fig);
    stafig = matlab.hg.internal.openfigLegacy('sta', 'reuse', 'visible');
    set(stafig,'CloseRequestFcn',@closeHandler);
    set(stafig,'ResizeFcn',@resizeHandler);
    set(stafig,'WindowScrollWheelFcn',@scrollHandler);
    handles.stafig = stafig;
    guidata(fig,handles);
    handles = struct('rawfig',fig);
    handles.stafig = stafig;
    handles.column = 4;
    handles.lines = gobjects(1,handles.column);
    handles.axes1 = findobj(stafig,'Tag','axes1');
    handles.heatmap = findobj(stafig,'Tag','axes2');
    handles.position = -1; % in datapoints
    colormap(handles.heatmap,'jet');
    
    
    
    
    % read data
    handles.data = [];
    handles.unit = -1;
    dataList = dir([dirpath '*.mat']);
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
    plotSTA(stafig,1);
end

function closeHandler(hObject,~,~)
    handles = guidata(hObject);
    rawfig = handles.rawfig;
    handles = guidata(rawfig);
    handles.stafig = gobjects;
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
    
    pos = get(handles.dropDown,'Position');
    width = pos(3);
    height = pos(4);
    axPos = get(handles.axes1,'Position');
    figPos = get(handles.stafig,'Position');
    top = (axPos(2) + axPos(4))*figPos(4);
    center = (axPos(1) + axPos(3)/2)*figPos(3);
    set(handles.dropDown,'Position',[center - width/2,top + 5,width,height]);
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

