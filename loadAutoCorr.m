% binsize in datapoints (1ms)
% bins, number of bins on each side (>= 1)
function autocorr = loadAutoCorr(filepath,binsize,numOfBins)
%LOADAUTOCORR Summary of this function goes here
%   Detailed explanation goes here
    f = fopen(filepath,'r');

    autocorr = zeros(1,2*numOfBins);
    spikes = [];
    l = fgetl(f);
    while ischar(l)
        dp = sscanf(l,'%d %d %d %d %f %d');
        pos = dp(6);
        spikes = spikes(spikes > (pos - binsize*numOfBins));
        dist = floor((pos - spikes)/binsize) + 1;
        autocorr(numOfBins - dist + 1) = autocorr(numOfBins - dist + 1) + 1;
        autocorr(numOfBins + dist) = autocorr(numOfBins + dist) + 1;
        spikes = [spikes,pos];
        l = fgetl(f);
    end
    
    fclose(f);
end

