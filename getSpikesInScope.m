function [spikes,startIndex] = getSpikesInScope(stafig,datafile,from,to)
% @from and @to are in datapoints
%GETSPIKESINSCOPE Summary of this function goes here
%   Returns spikes in time
    handles = guidata(stafig);
    % name of the active unit
    evFilePath = handles.unitNames{handles.unit};
    evFilePath = [handles.dirpath,strtok(evFilePath,'.'),'.ev2'];
    allSpikes = handles.eventFiles(evFilePath);
    if ~datafile.usingDownsampled
        spikes = allSpikes(allSpikes>from & allSpikes <= to);
        startIndex = find(allSpikes>from,1,'first');
        spikes = spikes/datafile.samplingRate;
    else
        scale = datafile.downsampled.resolution/2;
        spikes = allSpikes(allSpikes>from*scale & allSpikes <= to*scale);
        startIndex = find(allSpikes>from*scale,1,'first');
        spikes = spikes/datafile.unsampled.samplingRate;
    end

end

