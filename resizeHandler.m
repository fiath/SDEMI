function resizeHandler(hObject,~,~)
    fprintf('ResizeHandler called\n');
    handles = guidata(hObject);
    if handles.datLoaded == 0
        return
    end
    updateIdPositions(handles);
    
    axPos = get(handles.axes1,'Position');
    figPos = get(handles.figure1,'Position');
    top = (axPos(2) + axPos(4))*figPos(4);
    left = axPos(1)*figPos(3);
    Hcenter = (axPos(1) + axPos(3)/2)*figPos(3);
    Vcenter = (axPos(2) + axPos(4)/2)*figPos(4);
    % position channel selector text box
    pos = get(handles.edit1,'Position');
    width = pos(3);
    height = pos(4);
    set(handles.edit1,'Position',[left - width/5,top + 10,width,height]);
    
    % position time selector text box
    pos = get(handles.positionEditText,'Position');
    width = pos(3);
    height = pos(4);
    set(handles.positionEditText,'Position',[Hcenter - width/2,top + 10,width,height]);
    

