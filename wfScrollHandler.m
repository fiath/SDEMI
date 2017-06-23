function wfScrollHandler(fig,direction)
%WFSCOLLHANDLER Summary of this function goes here
%   Detailed explanation goes here

    % move pivot point
    handles = guidata(fig);
    if direction > 0 && handles.position < size(handles.data,2)
        plotHeatmap(fig,handles.position+1);
    elseif direction < 0 && handles.position > 1
        plotHeatmap(fig,handles.position-1);
    end
    
end

