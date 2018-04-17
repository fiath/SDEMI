function ud = calcPropDirectionUpDown(data, threshold)
	[start_channel, start_pos, channel, pos] = calcPropagation(data, threshold);
	
	ud = (floor((start_channel-1)/4) - floor(channel/4));
	
	ud = (ud-1)*20 + ud*2.5;
end