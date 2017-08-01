function heatmapRangeHandler(hObject,~,~)
%HEATMAPRANGEHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    state = get(hObject,'Value');
    max_state = get(hObject,'Max');
    min_state = get(hObject,'Min');
    if state == max_state        
        setRangeManualOn(handles);
        max_abs_v = max(max(abs(handles.data(:,:,handles.unit))));
        handles.heatmapRange = [-max_abs_v,max_abs_v];
    elseif state == min_state
        setRangeManualOff(handles);
        handles.heatmapRange = [];
    end
    guidata(hObject,handles);
    updateHeatMapRange(handles.stafig);
end

function setRangeManualOn(handles)
    set(handles.heatmapRangeMin,'Enable','on');
    set(handles.heatmapRangeMax,'Enable','on');
end

function setRangeManualOff(handles)
    set(handles.heatmapRangeMin,'Enable','off');
    set(handles.heatmapRangeMax,'Enable','off');
end

