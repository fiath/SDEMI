function updateTooltip(hObject)
%UPDATETOOLTIP Summary of this function goes here
%   Detailed explanation goes here
    %fprintf('Update tooltip start\n');
    handles = guidata(hObject);
    if handles.datafile.loadingSTA
        return;
    end

    C = get (handles.axes1, 'CurrentPoint');
    XLim = get(handles.axes1, 'XLim');
    YLim = get(handles.axes1, 'YLim');
    if isgraphics(handles.datafile.tooltip.line)
        %fprintf('Deleting line\n');
        delete(handles.datafile.tooltip.line);
        handles.datafile.tooltip.active = 0;
    end
    set(handles.datafile.tooltip.txt,'Visible','off');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        % draw tooltip line and set textbox's position
        %fprintf('Creating new line\n');
        if handles.datafile.tooltip.active
            %fprintf('Double creation\n');
        end
        handles.datafile.tooltip.line = line(handles.axes1,[C(1,1),C(1,1)],YLim,'Color',[0.5,0.5,0.5]);
        handles.datafile.tooltip.active = 1;
        axPos = get(handles.axes1,'Position');
        figPos = get(handles.figure1,'Position');
        bottom = axPos(2)*figPos(4);
        left = (C(1,1)-XLim(1))/(XLim(2)-XLim(1))*axPos(3)*figPos(3) + axPos(1)*figPos(3);
        pos = get(handles.datafile.tooltip.txt,'Position');
        set(handles.datafile.tooltip.txt,'Position',[left - pos(3)/2,bottom - pos(4) - 10,pos(3:4)]);
        timestamp = timeToString(round(C(1,1)*1000),handles.datafile.timeFormat);
        set(handles.datafile.tooltip.txt,'String',timestamp);
        set(handles.datafile.tooltip.txt,'Visible','on');
    end
    
    guidata(hObject,handles);
    %fprintf('Update tooltip end\n');
end

