function spikes = getSpikesInScope(stafig,datafile,from,to)
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
        spikes = spikes/datafile.samplingRate;
    else
        scale = datafile.downsampled.resolution/2;
        spikes = allSpikes(allSpikes>from*scale & allSpikes <= to*scale);
        spikes = spikes/datafile.unsampled.samplingRate;
    end

end

