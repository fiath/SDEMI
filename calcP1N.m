function dur = calcP1N( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
	[~,~,p1_pos] = calcP1Amplitude(data);
	[~,~,n_pos] = calcNAmplitude(data);
	dur = (n_pos - p1_pos)/data.samplingRate*1000;

end

