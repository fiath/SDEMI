function updateDatapointTextBoxes(fig)
%UPDATEDATAPOINTTEXTBOXES Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    set(handles.currDP,'String',num2str(handles.position));

end

