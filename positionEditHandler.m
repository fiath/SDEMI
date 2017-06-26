function positionEditHandler(hObject,~,~)
%POSITIONEDITHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    str = get(hObject, 'String');
    
    [ms,success] = parseTime(str);
    if ~success
        set(hObject,'String',handles.datafile.centerString);
    end
    if success
        centerData = round(ms*handles.datafile.samplingRate/1000);
        ws = handles.datafile.windowSize;
        handles.datafile.dataWindow = [centerData-ceil(ws/2),centerData+floor(ws/2)];
        guidata(hObject,handles);
        % update plot
        refreshDataView(hObject);
        set(hObject, 'Enable', 'off');
        drawnow;
        set(hObject, 'Enable', 'on');
    end
end

