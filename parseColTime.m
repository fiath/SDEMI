function [ms,success] = parseColTime(str)
%PARSECOLTIME Summary of this function goes here
%   Detailed explanation goes here
    ms = -1;
    success = 0;

    col_index = find(str == ':');
    if size(col_index,2) == 0
        str = ['0:0:',str];
    elseif size(col_index,2) == 1
        str = ['0:',str];
    elseif size(col_index,2) > 2
        return;
    end
    
    h = -1;
    m = -1;
    s = -1;
    
    format = '^[ ]*(?<h>0|([1-9]+[0-9]*))[ ]*:[ ]*(?<m>0|([1-9]+[0-9]*))[ ]*:[ ]*(?<s>0|([1-9]+[0-9]*))(?<ms>\.([0-9]{1,3}))?[ ]*$';
    r = regexp(str,format,'names');
    if isempty(r)
        % couldn't match the string
        return
    end
    
    h = str2num(r.h);
    m = str2num(r.m);
    s = str2num(r.s);
    
    if size(r.ms,2) ~= 0
        r.ms = r.ms(2:end);
    end
    r.ms = [r.ms, repmat('0',1,3-size(r.ms,2))];
    ms = str2num(r.ms);
    
    ms = ms + 1000*s + 1000*60*m + 1000*60*60*h;
    success = 1;
end

