function burstiness = calcBurstiness(data,threshold)
%CALCBURSTINESS Summary of this function goes here
%   Detailed explanation goes here
    threshold = threshold*data.samplingRate/1000;
    spikes = data.spikes;
    bursting = 0;
    for i=1:length(spikes)
        if i>1 && spikes(i)-spikes(i-1) <= threshold
            bursting = bursting + 1;
        elseif i<length(spikes) && spikes(i+1)-spikes(i) <= threshold
            bursting = bursting + 1;
        end
    end
    %bursting
    burstiness = bursting/length(spikes);
end

