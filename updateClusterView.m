function updateClusterView(clfig)
%UPDATECLUSTERVIEW Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(clfig);
    plotClusterView(clfig,handles.activeUnit,...
        handles.eventFiles(handles.unitNames{handles.activeUnit}).activeSpike,...
        handles.eventFiles(handles.unitNames{handles.activeUnit}).activePosition);

end

