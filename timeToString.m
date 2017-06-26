function str = timeToString(time,format)
%TIMETOSTRING Summary of this function goes here
%   Detailed explanation goes here
    h = floor(time/1000/3600);
    m = floor((time - h*3600*1000)/1000/60);
    s = floor((time - h*3600*1000 - m*60*1000)/1000);
    ms = time - h*3600*1000 - m*60*1000 - s*1000;
    str = sprintf(format,h,m,s,ms);

end

