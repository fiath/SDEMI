function manual = isManualRange(hmfig,axesId)
%ISMANUALRANGE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hmfig);
    
    state = get(handles.(axesId).rangeButton,'Value');
    max_state = get(handles.(axesId).rangeButton,'Max');
    manual = (state == max_state);        
end

