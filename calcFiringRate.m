function [firingrate] = calcFiringRate(data)
%CALCFIRINGRATE Summary of this function goes here
%   Detailed explanation goes here
    spikes = data.spikes;
    firingrate = length(spikes)/data.measurementLength;

end

