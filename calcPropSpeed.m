function v = calcPropSpeed(data, threshold)
	[start_channel, start_pos, channel, pos] = calcPropagation(data, threshold);
	
	ud = (floor((start_channel-1)/4) - floor(channel/4));
	lr = mod(channel,4) - mod(start_channel,4);
	
	dist = (((ud-1)*20 + ud*2.5)^2 + ((lr-1)*20 + lr*2.5)^2)^0.5;
	
	t = (pos-start_pos)/data.samplingRate*1000;
	
	v = dist/t;
end