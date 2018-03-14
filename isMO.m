function o = isMO( l )
%ISMO Summary of this function goes here
%   Detailed explanation goes here
	if ~isstruct(l) && length(l) == 1 && l == -1
		o = true;
	else
		o = false;
	end

end

