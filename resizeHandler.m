function resizeHandler(hObject,~,~)
    fprintf('ResizeHandler called\n');
    handles = guidata(gcf);
    updateIdPositions(handles.datafile);

