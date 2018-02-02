function spikeValue = getSpikeAt(stafig,datafile,position)
% @from and @to are in datapoints
%GETSPIKESINSCOPE Summary of this function goes here
%   Returns spikes in time
    if isMO(datafile.activeEventFile)
        error('Why call this when there is no active event file');
        return;
    end
    filepath = datafile.activeEventFile;
    allSpikes = getSpikes(stafig,filepath,datafile);
    spikeValue = allSpikes(position);
    if ~datafile.usingDownsampled
        spikeValue = spikeValue/datafile.samplingRate;
    else
        spikeValue = spikeValue/datafile.unsampled.samplingRate;
    end

end

