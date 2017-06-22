function loadSTA(fig, dirpath )
%LOADSTA Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    stafig = matlab.hg.internal.openfigLegacy('sta', 'reuse', 'visible');
    set(stafig,'CloseRequestFcn',@closeHandler);
    handles.stafig = stafig;
    guidata(fig,handles);
    handles = struct('rawfig',fig);
    handles.stafig = stafig;
    handles.axes1 = findobj(stafig,'Type','axes');
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
    handles = rmfield(handles,'stafig');
    guidata(rawfig,handles);
    delete(hObject);
end

function dropdownHandler(hObject,~,~)
    handles = guidata(hObject);
    plotSTA(handles.stafig,get(hObject,'Value'));
end

