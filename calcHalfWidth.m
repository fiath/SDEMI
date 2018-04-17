function dur = calcHalfWidth( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
	[p2,channel,p2_pos] = calcP2Amplitude(data);
	[n,~,n_pos] = calcNAmplitude(data);
	
	threshold = n+(p2-n)/2;
	
	a1 = find(data.sta(channel,1:n_pos) > threshold, 1, 'last');
	a2 = find(data.sta(channel,n_pos:end)> threshold, 1);
	
	a2 = a2-1+n_pos;
	
	% interpolate to yield the proper value
	a1 = a1 + (threshold-data.sta(channel,a1))/(data.sta(channel,a1+1)-data.sta(channel,a1));
	
	a2 = a2 - (data.sta(channel,a2)-threshold)/(data.sta(channel,a2)-data.sta(channel,a2-1));
	
	dur = (a2-a1)/data.samplingRate*1000;

end

