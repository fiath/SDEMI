function as = calcAsymmetry( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
	[p1,~,~] = calcP1Amplitude(data);
	[p2,~,~] = calcP2Amplitude(data);
	as = (p2-p1)/(p2+p1);

end

