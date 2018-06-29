function ud = calcPropDirectionUpDown(data, threshold)
% returns the distance along the VERTICAL axis in [um]
% UP is positive, so if it propagates toward the lower channels
	[start_channel, start_pos, channel, pos] = calcPropagation(data, threshold);
	
	ud = (floor((start_channel-1)/4) - floor((channel-1)/4));
	
	ud = (ud-1)*20 + ud*2.5;
end