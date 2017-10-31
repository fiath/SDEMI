function [absolute,negative,positive] = calcSpikeExpanse(data,threshold)
%SPIKEEXPANSE Summary of this function goes here
%   Detailed explanation goes here
    sta = data.sta;
    
    [min_values,min_indices] = min(sta,[],2);
    max_values = zeros(size(sta,1),1);
    max_indices = zeros(size(sta,1),1);
    for i=1:length(max_values)
        % only count the amplitude if the max is after the min
        [max_values(i),max_indices(i)] = max(sta(i,min_indices(i):end));
    end
    
    absolute = sum((max_values-min_values) > threshold);
    negative = sum(min_values < threshold);
    positive = sum(max_values > threshold);

end

