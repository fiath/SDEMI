function ratio = calcAreaAsymmetry( data )
%CALCP1AMPLITUDE Summary of this function goes here
%   Detailed explanation goes here
%	returns area in ms*uV
	ratio = calcP1NArea(data)/calcNP2Area(data);

end

