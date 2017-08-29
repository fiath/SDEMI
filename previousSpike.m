function previousSpike(hObject,~,~)
%PREVIOUSSPIKE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    if handles.datafile.currentSpike > 1
        setCurrentSpike(handles.figure1,handles.datafile.currentSpike-1);
    end

end

