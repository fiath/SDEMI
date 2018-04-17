function [amp, channel, pos] = calcNAmplitude( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
	[~,max_amp,channel] = calcSpikeDurationAndMaxAmp(data,data.samplingRate);
	
	[amp, pos] = min(data.sta(channel, :));

end

