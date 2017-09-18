function clusterDropDownHandler(hObject,~,~)
%CLUSTERDROPDOWNHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    handles.activeUnit = get(hObject,'Value');
    guidata(hObject,handles);
    updateClusterView(handles.clfig);

    set(hObject,'Enable','off');
    drawnow;
    set(hObject,'Enable','on');
end

