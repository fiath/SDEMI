% binsize in datapoints (1ms)
% bins, number of bins on each side (>= 0)
function autocorr = loadAutoCorr(filepath,binsize,numOfBins)
%LOADAUTOCORR Summary of this function goes here
%   Detailed explanation goes here
    f = fopen(filepath,'r');

    autocorr = zeros(1,2*numOfBins+1);
    spikes = [];
    l = fgetl(f);
    while ischar(l)
        dp = sscanf(l,'%d %d %d %d %f %d');
        pos = dp(6);
        spikes = spikes(spikes >= (pos - binsize*numOfBins));
        dist = ceil((pos - spikes)/binsize);
        if dist == 0
            error('Multiple spikes at the same time from the same neuron');
        end
        autocorr(numOfBins - dist + 1) = autocorr(numOfBins - dist + 1) + 1;
        autocorr(numOfBins + dist + 1) = autocorr(numOfBins + dist + 1) + 1;
        autocorr(numOfBins+1) = autocorr(numOfBins+1)+1; % add spike to 0 bin
        spikes = [spikes,pos];
        l = fgetl(f);
    end
    
    fclose(f);
end

