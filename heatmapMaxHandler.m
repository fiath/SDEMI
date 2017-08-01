function heatmapMaxHandler(hObject,~)
%HEATMAPMINHANDLER Summary of this function goes here
%   Detailed explanation goes here
    str = get(hObject,'String');
    handles = guidata(hObject);
    if regexp(str,'^[ ]*(-)?[1-9]+[0-9]*(\.[0-9]+)?[ ]*$')
        updateHeatMapRange(handles.stafig,[handles.heatmapRange(1),str2double(str)]);
    else
        set(hObject,'String',num2str(handles.heatmapRange(2)));
    end

    set(hObject, 'Enable', 'off');
    drawnow;
    set(hObject, 'Enable', 'on');
end

