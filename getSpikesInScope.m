function [spikes,startIndex] = getSpikesInScope(stafig,datafile,from,to,filepath)
% @from and @to are in datapoints
%GETSPIKESINSCOPE Summary of this function goes here
%   Returns spikes in time
    allSpikes = getSpikes(stafig, filepath,datafile);
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

