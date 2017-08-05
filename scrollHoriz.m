function scrollHoriz(hObject,dir)
%SCROLLLEFT Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    window = handles.datafile.dataWindow;
    if dir > 0 
        window = window + floor(handles.datafile.windowSize/20);
    else
        window = window - floor(handles.datafile.windowSize/20);
    end
    handles.datafile = updateWindow(handles,window);

    updateIdPositions(handles);
    guidata(hObject, handles);
    updateTooltip(hObject);
end

