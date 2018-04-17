function area = calcP1P2Area( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
%	returns area in ms*uV
	[~,channel,p1_pos] = calcP1Amplitude(data);
	[~,~,p2_pos] = calcP2Amplitude(data);
	area = sum(data.sta(channel,p1_pos:p2_pos))/data.samplingRate*1000;

end

