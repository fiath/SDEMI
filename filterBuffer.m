function buffer = filterBuffer(datafile,buffer)
%FILTERBUFFER Summary of this function goes here
%   Detailed explanation goes here
    buffer = filter(datafile.filter.B,datafile.filter.A,...
                                buffer,[],2);
    buffer = fliplr(buffer);
    buffer = filter(datafile.filter.B,datafile.filter.A,...
                                buffer,[],2);
    buffer = fliplr(buffer);

end

