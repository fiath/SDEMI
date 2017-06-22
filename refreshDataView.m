function refreshDataView()
%REFRESHDATAVIEW Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(gcf);
    
    handles.datafile = updateWindow(handles,handles.datafile.dataWindow,1);
    updateIdPositions(handles.datafile);
    guidata(gcf, handles);
end

