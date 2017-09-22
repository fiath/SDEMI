function spikeStateDropDownHandler(hObject,~,~)
    handles = guidata(hObject);
    newState= get(hObject,'Value')-1;
    unit = handles.eventFiles(handles.unitNames{handles.activeUnit});
    % check if spike has been reassigned to its original unit
    if newState == handles.activeUnit
        % remove spike from assignedFrom if present
        index = find(unit.assignedFrom.spikeIds == unit.activeSpike,1,'first');
        if ~isempty(index)
            unit.assignedFrom.spikeIds(index) = [];
            unit.assignedFrom.dst(index) = [];
        end
    else
        index = find(unit.assignedFrom.spikeIds == unit.activeSpike,1,'first');
        if ~isempty(index)
            unit.assignedFrom.spikeIds(index) = unit.activeSpike;
            unit.assignedFrom.dst(index) = newState;
        else
            unit.assignedFrom.spikeIds = [unit.assignedFrom.spikeIds,unit.activeSpike];
            unit.assignedFrom.dst = [unit.assignedFrom.dst,newState];
        end
    end
    handles.eventFiles(handles.unitNames{handles.activeUnit}) = unit;
    guidata(hObject,handles);
    
    set(hObject,'Enable','off');
    drawnow;
    set(hObject,'Enable','on');
    
    updateClusterView(handles.clfig);
end