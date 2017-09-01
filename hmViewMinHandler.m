function hmViewMinHandler(hObject,axesId)
%HEATMAPMINHANDLER Summary of this function goes here
%   Detailed explanation goes here
    str = get(hObject,'String');
    handles = guidata(hObject);
    rawHandles = guidata(handles.rawfig);
    if regexp(str,'^[ ]*(-)?[1-9]+[0-9]*(\.[0-9]+)?[ ]*$')
        updateHeatmapViewRange(handles.hmfig,rawHandles.datafile,axesId,[str2double(str),handles.(axesId).range(2)]);
    else
        set(hObject,'String',num2str(handles.(axesId).range(1)));
    end

    set(hObject, 'Enable', 'off');
    drawnow;
    set(hObject, 'Enable', 'on');
end

