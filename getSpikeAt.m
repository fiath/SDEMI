function spikeValue = getSpikesAt(stafig,datafile,position)
% @from and @to are in datapoints
%GETSPIKESINSCOPE Summary of this function goes here
%   Returns spikes in time
    handles = guidata(stafig);
    % name of the active unit
    evFilePath = handles.unitNames{handles.unit};
    evFilePath = [handles.dirpath,strtok(evFilePath,'.'),'.ev2'];
    allSpikes = getSpikes(stafig,evFilePath);
    spikeValue = allSpikes(position);
    if ~datafile.usingDownsampled
        spikeValue = spikeValue/datafile.samplingRate;
    else
        spikeValue = spikeValue/datafile.unsampled.samplingRate;
    end

end

