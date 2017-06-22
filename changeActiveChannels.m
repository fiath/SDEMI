function [datafile,success] = changeActiveChannels( datafile,newActiveString )
%CHANGEACTIVECHANNELS Summary of this function goes here
%   Detailed explanation goes here
    success = -1;
    if strcmp(datafile.channelRangeString,newActiveString)
        success = 0;
        return
    end
    tmp = zeros(1,datafile.numberOfChannels);
    % start parsing the string
    index = 0; % length of string already parsed
    while true
        [a,b,c,i] = getNextBlock(newActiveString,index + 1);
        if i==-1 || a < 1 || b < 1 || a > c || c > datafile.numberOfChannels
            % invalid newActiveString do nothing
            return
        end
        for j = a:b:c
            tmp(j) = 1;
        end
        index = getNextNonSpaceCharIndex(newActiveString,i+1);
        if index == -1
            % we finished parsing -> success
            datafile.activeChannels = tmp;
            datafile.channelRangeString = newActiveString;
            success = 1;
            return;
        else
            if newActiveString(index) ~= ','
                % invalid newActiveString
                return
            else
                % parse the next block
                continue;
            end
        end
    end
end

function [a,b,c,index] = getNextBlock(str,start)
    [n,i] = getNextNum(str,start);
    if i == -1
        index = -1;
        return
    end
    a = n;
    prev_i = i;
    i = getNextNonSpaceCharIndex(str,prev_i+1);
    if i==-1 || str(i) ~= ':'
        index = prev_i;
        b = 1;
        c = a;
        return;
    end
    prev_i = i;
    [n,i] = getNextNum(str,prev_i+1);
    if i==-1
        index = -1;
        return;
    end
    b = n;
    prev_i = i;
    i = getNextNonSpaceCharIndex(str,prev_i+1);
    if i==-1 || str(i) ~= ':'
        index = prev_i;
        c = b;
        b = 1;
        return;
    end
    prev_i = i;
    [n,i] = getNextNum(str,prev_i+1);
    if i==-1
        index = -1;
        return;
    end
    index = i;
    c = n;
end

% index is the last character in num
function [num,index] = getNextNum(str,start)
    i = getNextNonSpaceCharIndex(str,start);
    if i==-1
        index = -1;
        return
    end
    if str(i) <= '0' || str(i) > '9'
        index = -1;
        return
    end
    % str(i) is [1-9]
    num = str(i) - '0';
    while true
        prev_i = i;
        i = getNextNonSpaceCharIndex(str,prev_i+1);
        if i==-1 || str(i) < '0' || str(i) > '9'
            index = prev_i;
            return;
        end
        num = 10*num + (str(i)-'0');
    end
end
           

% returns index of first non-space character after (and including) start
function index = getNextNonSpaceCharIndex(str,start)
    if start > size(str,2)
        index = -1;
        return;
    end
    index = start;
    while str(index) == ' '
        index = index + 1;
        % ran out of chars
        if index > size(str,2)
            index = -1;
            return;
        end
    end
end

