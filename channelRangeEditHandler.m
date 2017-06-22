function [ output_args ] = channelRangeEditHandler( hObject, eventdata )
%CHANNELRANGEEDITHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(gcf);
    C = get(hObject, 'String');
    %C = [C{:}];
    fprintf('Range: %s\n',C);
    handles = guidata(gcf);
    [handles.datafile,success] = changeActiveChannels(handles.datafile,C);
    fprintf('Success: %d\n',success);
    if success ~= 1
        % signal error
        set(hObject,'String',handles.datafile.channelRangeString);
    end
    if success == 1
        guidata(gcf,handles);
        % update plot
        refreshDataView();
         set(hObject, 'Enable', 'off');
         drawnow;
         set(hObject, 'Enable', 'on');
    end
end

