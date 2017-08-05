function scrollVert(hObject,dir)
%SCROLLVERT Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    YLim = get(handles.axes1, 'YLim');
    ySize = YLim(2) - YLim(1);
    if dir < 0 
        YLim = YLim + ySize/20;
    else
        YLim = YLim - ySize/20;
    end

    handles.datafile.ylim = CheckYLim(YLim,handles.datafile);
    set(handles.axes1,'YLim',handles.datafile.ylim);

    % update pivot line
    center = round((handles.datafile.dataWindow(1) + handles.datafile.dataWindow(2))/2);
    delete(handles.datafile.pivotLine);
    handles.datafile.pivotLine = line(handles.axes1,[center,center],get(handles.axes1,'YLim'));
    
    updateIdPositions(handles);
    guidata(hObject, handles);
    updateTooltip(hObject);
end

