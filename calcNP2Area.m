function area = calcNP2Area( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
%	returns area in ms*uV
	[~,channel,n_pos] = calcNAmplitude(data);
	[~,~,p2_pos] = calcP2Amplitude(data);
	area = sum(data.sta(channel,n_pos:p2_pos))/data.samplingRate*1000;

end

