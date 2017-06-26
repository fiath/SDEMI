function [ms,success] = parseTime(str)
%PARSETIME Summary of this function goes here
%   Detailed explanation goes here
    success = 0;
    ms = -1;

    h_index = find(str == 'h');
    m_index = find(str == 'm');
    s_index = find(str == 's');
    
    if size(h_index,2) == 0 && size(m_index,2) == 0 && ...
            size(s_index,2) == 0
        [ms,success] = parseColTime(str);
        return;
    end
    
    col_index = find(str == ':');
    if size(col_index,2) ~= 0
        return;
    end
    % check if there is an 'm' after 'h'
    if size(h_index,2) > 0
        if size(find(str(h_index(1):end) == 'm'),2) == 0
            % there is no 'm' after 'h'
            str = [str(1:h_index(1)-1), ':0m',str(h_index(1)+1:end)];
        else
            str = [str(1:h_index(1)-1), ':',str(h_index(1)+1:end)];
        end
    end
    m_index = find(str == 'm');
    if size(m_index,2) > 0
        if size(find(str(m_index(1):end) == 's'),2) == 0
            % there is no 's' after 'm'
            str = [str(1:m_index(1)-1), ':0s',str(m_index(1)+1:end)];
        else
            str = [str(1:m_index(1)-1), ':',str(m_index(1)+1:end)];
        end
    end
    % remove 's'
    s_index = find(str == 's',1,'last');
    if size(s_index,2) == 0
        error('Has to have an _s_ in it');
    end
    [ms,success] = parseColTime([str(1:s_index(1)-1),str(s_index(1)+1:end)]);
    
end

