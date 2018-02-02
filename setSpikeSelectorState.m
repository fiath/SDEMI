function setSpikeSelectorState(handles,state)
%SETSPIKESELECTORSTATE Summary of this function goes here
%   Detailed explanation goes here
    if strcmp(state,'on')
        set(handles.leftspike,'Enable','on');
        set(handles.currentspiketext,'Enable','on');
        set(handles.rightspike,'Enable','on');
    elseif strcmp(state,'off')
        set(handles.leftspike,'Enable','off');
        set(handles.currentspiketext,'Enable','off');
        set(handles.rightspike,'Enable','off');
    end
        

end

