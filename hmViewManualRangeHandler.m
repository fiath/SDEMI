function hmViewManualRangeHandler(hObject,axesId)
%HEATMAPRANGEHANDLER Summary of this function goes here
%   axesId is 'lfp', 'csd' or 'mua'
    handles = guidata(hObject);
    state = get(hObject,'Value');
    max_state = get(hObject,'Max');
    min_state = get(hObject,'Min');
    if state == max_state        
        setRangeManualOn(handles,axesId);
    elseif state == min_state
        setRangeManualOff(handles,axesId);
    end
    handles.(axesId).range = []; % invalidate range
    guidata(hObject,handles);
    rawHandles = guidata(handles.rawfig);
    updateHeatmapViewRange(handles.hmfig,rawHandles.datafile,axesId);
end

function setRangeManualOn(handles,axesId)
    set(handles.(axesId).minText,'Enable','on');
    set(handles.(axesId).maxText,'Enable','on');
end

function setRangeManualOff(handles,axesId)
    set(handles.(axesId).minText,'Enable','off');
    set(handles.(axesId).maxText,'Enable','off');
end

