function dist = calcPropDistance(data, threshold)
% distance between endpoints of the propagation in [um]
% UP is positive
% RIGHT is positive
	[start_channel, start_pos, channel, pos] = calcPropagation(data, threshold);
	
	ud = (floor((start_channel-1)/4) - floor((channel-1)/4));
	lr = mod(channel-1,4) - mod(start_channel-1,4);
	
	dist = (((ud-1)*20 + ud*2.5)^2 + ((lr-1)*20 + lr*2.5)^2)^0.5;
end