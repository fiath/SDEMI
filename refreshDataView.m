function refreshDataView(hObject)
%REFRESHDATAVIEW Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    
    handles.datafile = updateWindow(handles,handles.datafile.dataWindow,1);
    updateIdPositions(handles);
    guidata(hObject, handles);
end

