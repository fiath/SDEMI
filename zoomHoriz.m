function zoomHoriz(hObject,dir)
%SCROLLLEFT Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    window = handles.datafile.dataWindow;
    center = floor((window(1) + window(2))/2);
    if dir > 0 
        handles.datafile.windowSize = floor(handles.datafile.windowSize + max([5,handles.datafile.windowSize*0.05]));
    else
        handles.datafile.windowSize = floor(handles.datafile.windowSize*0.95);
    end
    window = [center - floor(handles.datafile.windowSize/2),...
              center + ceil(handles.datafile.windowSize/2)];
    if ResolutionChanged(handles,window)
       handles.datafile = updateWindow(handles,window,true);
    else
       handles.datafile = updateWindow(handles,window);
    end

    updateIdPositions(handles);
    guidata(hObject, handles);
    updateTooltip(hObject);
end

