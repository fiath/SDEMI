function [duration] = calcSpikeDuration(data)
%CALCSPIKEDURATION Summary of this function goes here
%   Detailed explanation goes here
    [duration,~,~] = calcSpikeDurationAndMaxAmp(data,data.samplingRate);

end

