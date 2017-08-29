function currentSpikeChangeHandler(hObject,~)
    handles = guidata(hObject);
    C = get(hObject, 'String');
    fprintf('Spike: %s\n',C);
    regex = '[ ]*(?<pos>[1-9]+[0-9]*)[ ]*';
    m = regexp(C,regex,'names');
    if isempty(m)
        % not a valid spike position
        set(hObject,'String',num2str(handles.datafile.currentSpike));
    end
    pos = min([str2num(m.pos),handles.datafile.allSpikeCount]);
    setCurrentSpike(handles.figure1,pos);
end