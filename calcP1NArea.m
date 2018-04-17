function area = calcP1NArea( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
%	returns area in ms*uV
	[~,channel,p1_pos] = calcP1Amplitude(data);
	[~,~,n_pos] = calcNAmplitude(data);
	area = sum(data.sta(channel,p1_pos:n_pos))/data.samplingRate*1000;

end

