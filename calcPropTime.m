function t = calcPropTime(data, threshold)
	[start_channel, start_pos, channel, pos] = calcPropagation(data, threshold);
	
	t = (pos-start_pos)/data.samplingRate*1000;
end