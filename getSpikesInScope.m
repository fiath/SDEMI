function spikes = getSpikesInScope(stafig,from,to)
% @from and @to are in datapoints
%GETSPIKESINSCOPE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(stafig);
    % name of the active unit
    evFilePath = handles.unitNames{handles.unit};
    evFilePath = [handles.dirpath,strtok(evFilePath,'.'),'.ev2'];
    allSpikes = handles.eventFiles(evFilePath);
    spikes = allSpikes(allSpikes>from & allSpikes <= to);

end

