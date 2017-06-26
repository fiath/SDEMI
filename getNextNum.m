% index is the last character in num
% finds a positive number
function [num,index] = getNextNum(str,start)
    num = -1;
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

