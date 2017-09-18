function changeActiveUnit(clfig,unit)
%CHANGEACTIVEUNIT Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(clfig);
    if unit < 1
        unit = 1;
    elseif unit > size(handles.eventFiles,1)
        unit = size(handles.eventFiles,1);
    end
    handles.activeUnit = unit;
    handles.dropDown.Value = unit;
    
    handles.activeSpikeText.String = num2str(handles.eventFiles(handles.unitNames{unit}).activeSpike);
    handles.allSpikeText.String = ['/',num2str(length(handles.eventFiles(handles.unitNames{unit}).spikes))];
    
    guidata(clfig,handles);
    updateClusterView(clfig);

end

