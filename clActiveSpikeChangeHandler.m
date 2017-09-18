function clActiveSpikeChangeHandler(hObject,eventdata)
%CLACTIVESPIKECHANGEHANDLER Summary of this function goes here
%   Detailed explanation goes here
    regex = '^[ ]*(?<spike>[1-9]+[0-9]*)[ ]*$';
    m = regexp(hObject.String,regex,'names');
    handles = guidata(hObject);
    if isempty(m)
        % restore original and do nothing
        handles.activeSpikeText.String = num2str(handles.eventFiles(handles.unitNames{handles.activeUnit}).activeSpike);
    else
        changeActiveSpike(handles.clfig,str2num(m.spike));
    end
    set(hObject, 'Enable', 'off');
    drawnow;
    set(hObject, 'Enable', 'on');

end

