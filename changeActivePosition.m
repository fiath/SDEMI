function changeActivePosition(clfig,pos)
%CHANGEACTIVESPIKE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(clfig);
    s = handles.eventFiles(handles.unitNames{handles.activeUnit});
    size = handles.range(2)-handles.range(1)+1;
    if pos < 1
        pos = 1;
    elseif pos > size;
        pos = size;
    end
    unit = handles.eventFiles(handles.unitNames{handles.activeUnit});
    unit.activePosition = pos;
    handles.eventFiles(handles.unitNames{handles.activeUnit})= unit;
    
%     handles.activeSpikeText.String = num2str(handles.eventFiles(handles.unitNames{handles.activeUnit}).activeSpike);
    
    guidata(clfig,handles);
    updateClusterView(clfig);

end
