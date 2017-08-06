function filterToggleHandler(hObject,~,~)
%FILTERTOGGLEHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    if handles.datafile.usingDownsampled
        error('Cannot filter while using downsampled');
    end
    state = get(hObject,'Value');
    max_state = get(hObject,'Max');
    min_state = get(hObject,'Min');
    if state == max_state        
        handles.datafile.filter.on = 1;
    elseif state == min_state
        handles.datafile.filter.on = 0;
    end
    guidata(hObject,handles);
    refreshDataView(handles.figure1);
end

