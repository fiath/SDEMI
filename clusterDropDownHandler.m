function clusterDropDownHandler(hObject,~,~)
%CLUSTERDROPDOWNHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    changeActiveUnit(handles.clfig,get(hObject,'Value'));

    set(hObject,'Enable','off');
    drawnow;
    set(hObject,'Enable','on');
end

