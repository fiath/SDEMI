function [duration,max_amp,max_amp_channel] = calcSpikeDurationAndMaxAmp(data,samplingRate)
%CALCSPIKEDURATION Summary of this function goes here
%   Detailed explanation goes here
    sta = data.sta;
    
    [min_values,min_indices] = min(sta,[],2);
    max_values = zeros(size(sta,1),1);
    max_indices = zeros(size(sta,1),1);
    for i=1:length(max_values)
        % take into account the points before the N 
        [max_values(i),max_indices(i)] = max(sta(i,:));
    end
    [max_amp,max_amp_channel] = max(max_values-min_values);
    
    duration = (max_indices(max_amp_channel))*1000/samplingRate;

end

