function dur = calcNP2( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
	[~,~,p2_pos] = calcP2Amplitude(data);
	[~,~,n_pos] = calcNAmplitude(data);
	dur = (p2_pos - n_pos)/data.samplingRate*1000;

end

