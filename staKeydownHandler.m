function staKeydownHandler(hObject,eventdata,~)
%STAKEYDOWNHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    if strcmp(eventdata.Key,'uparrow') == 1 && handles.unit > 1
        % select the previous unit
        plotSTA(handles.stafig,handles.unit-1);
    elseif strcmp(eventdata.Key,'downarrow') == 1 && handles.unit < size(handles.data,3)
        % select the next unit
        plotSTA(handles.stafig,handles.unit+1);
    end

end

