function [start_channel, start_pos, channel, pos] = calcPropagation( data, threshold )
%CALCPROPAGATION Summary of this function goes here
%   Detailed explanation goes here
%	threhsold is from 0% to 100%

	[start_amplitude,start_channel, start_pos] = calcMinPosition(data.sta);
	pos = start_pos;
	amp = start_amplitude;
	channel = start_channel;
	while amp < start_amplitude*threshold/100
		[amp, channel, ~] = calcMinPosition(data.sta(:, pos+1));
		pos = pos+1;
	end
	
end

