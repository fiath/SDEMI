function [amp, channel, pos ] = calcMinPosition( X )
%CALCMINPOSITION Summary of this function goes here
%   Detailed explanation goes here
	[amp, idx] = min(X(:));
	[channel, pos] = ind2sub(size(X),idx);

end

