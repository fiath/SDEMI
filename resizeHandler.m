function resizeHandler(hObject,~,~)
    fprintf('ResizeHandler called\n');
    handles = guidata(hObject);
    updateIdPositions(handles);
    
    pos = get(handles.edit1,'Position');
    width = pos(3);
    height = pos(4);
    axPos = get(handles.axes1,'Position');
    figPos = get(handles.figure1,'Position');
    top = (axPos(2) + axPos(4))*figPos(4);
    left = axPos(1)*figPos(3);
    set(handles.edit1,'Position',[left - width/5,top + 10,width,height]);

