function currDPHandler(hObject,~,~)
    handles = guidata(hObject);
    format = '^[ ]*(?<pos>[1-9][0-9]*)[ ]*$';
    str = get(handles.currDP,'String');
    m = regexp(str,format,'names');
    if isempty(m)
        % invalid input
        set(hObject,'String',num2str(handles.position));
        return;
    end
    newPos = str2num(m.pos);
    succ = plotHeatmap(handles.stafig,newPos);
    if ~succ
        set(hObject,'String',num2str(handles.position));
        return;
    end
    
    
    set(hObject, 'Enable', 'off');
    drawnow;
    set(hObject, 'Enable', 'on');
end