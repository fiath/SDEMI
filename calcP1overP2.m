function ratio = calcP1overP2( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
	[p1,~,~] = calcP1Amplitude(data);
	[p2,~,~] = calcP2Amplitude(data);
	ratio = p1/p2;

end

