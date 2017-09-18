function changeActiveSpike(clfig,spike)
%CHANGEACTIVESPIKE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(clfig);
    s = handles.eventFiles(handles.unitNames{handles.activeUnit});
    if spike < 1
        spike = 1;
    elseif spike > length(s.spikes)
        spike = length(s.spikes);
    end
    unit = handles.eventFiles(handles.unitNames{handles.activeUnit});
    unit.activeSpike = spike;
    handles.eventFiles(handles.unitNames{handles.activeUnit})= unit;
    
    handles.activeSpikeText.String = num2str(handles.eventFiles(handles.unitNames{handles.activeUnit}).activeSpike);
    
    guidata(clfig,handles);
    updateClusterView(clfig);

end

