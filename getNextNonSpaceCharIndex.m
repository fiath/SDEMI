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


