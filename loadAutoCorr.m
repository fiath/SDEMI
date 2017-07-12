% binsize in datapoints (1ms)
% bins, number of bins on each side (>= 0)
function autocorr = loadAutoCorr(fig,filepath,binsize,numOfBins)
%LOADAUTOCORR Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    if isKey(handles.eventFiles,filepath)
        % event file has already been loaded
        spikes = handles.eventFiles(filepath);
    else
        f = fopen(filepath,'r');
        spikes = [];
        l = fgetl(f);
        while ischar(l)
            dp = sscanf(l,'%d %d %d %d %f %d');
            spikes = [spikes,dp(6)];
            l = fgetl(f);
        end
        fclose(f);
        handles.eventFiles(filepath) = spikes;
        guidata(fig,handles);
    end

    autocorr = zeros(1,2*numOfBins+1);
    activeSpikes = [];
    for i=1:length(spikes)        
        pos = spikes(i);
        activeSpikes = activeSpikes(activeSpikes >= (pos - binsize*numOfBins));
        dist = ceil((pos - activeSpikes)/binsize);
        if dist == 0
            error('Multiple spikes at the same time from the same neuron');
        end
        autocorr(numOfBins - dist + 1) = autocorr(numOfBins - dist + 1) + 1;
        autocorr(numOfBins + dist + 1) = autocorr(numOfBins + dist + 1) + 1;
        autocorr(numOfBins+1) = autocorr(numOfBins+1)+1; % add spike to 0 bin
        activeSpikes = [activeSpikes,pos];
    end
end

