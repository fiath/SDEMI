function zoomVert(hObject,dir)
%SCROLLVERT Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    YLim = get(handles.axes1, 'YLim');
    ySize = YLim(2) - YLim(1);
    center = (YLim(1)+YLim(2))/2;
    if dir > 0 
        ySize = ySize + max([ySize*0.05,10]);
    else
       ySize = ySize*0.95;
    end
    YLim = [center - floor(ySize/2),center + ceil(ySize/2)];

    handles.datafile.ylim = CheckYLim(YLim,handles.datafile);
    set(handles.axes1,'YLim',handles.datafile.ylim);

    % update pivot line
    center = round((handles.datafile.dataWindow(1) + handles.datafile.dataWindow(2))/2);
    delete(handles.datafile.pivotLine);
    handles.datafile.pivotLine = line(handles.axes1,[center,center],get(handles.axes1,'YLim'));
    
    repositionSpikeLines(handles.datafile);
    updateIdPositions(handles);
    guidata(hObject, handles);
    updateTooltip(hObject);

