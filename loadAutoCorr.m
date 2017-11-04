% binsize in datapoints (1ms)
% bins, number of bins on each side (>= 0)
function autocorr = loadAutoCorr(fig,filepath,binsize,numOfBins)
%LOADAUTOCORR Summary of this function goes here
%   Detailed explanation goes here
    spikes = getSpikes(fig,filepath);

    autocorr = zeros(1,2*numOfBins+1);
    activeSpikes = [];
    for i=1:length(spikes)        
        pos = spikes(i);
        activeSpikes = activeSpikes(activeSpikes >= (pos - binsize*numOfBins));
        dist = ceil((pos - activeSpikes)/binsize);
        if ~all(dist)
            % multiple spikes at the same time from the same neuron, ignore
            % spike
            continue;
            error('Multiple spikes at the same time from the same neuron');
        end
        for j=1:length(dist)
            autocorr(numOfBins - dist(j) + 1) = autocorr(numOfBins - dist(j) + 1) + 1;
            autocorr(numOfBins + dist(j) + 1) = autocorr(numOfBins + dist(j) + 1) + 1;
        end
        autocorr(numOfBins+1) = autocorr(numOfBins+1)+1; % add spike to 0 bin
        activeSpikes = [activeSpikes,pos];
    end
end

