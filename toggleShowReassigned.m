function toggleShowReassigned(hObject,~,~)
%TOGGLESHOWREASSIGNED Summary of this function goes here
%   Detailed explanation goes here
    if strcmp(get(hObject,'Checked'),'on')
        set(hObject,'Checked','off');
    else 
        set(hObject,'Checked','on');
    end

end

