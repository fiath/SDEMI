function [ output_args ] = channelRangeEditHandler( hObject, eventdata )
%CHANNELRANGEEDITHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    C = get(hObject, 'String');
    %C = [C{:}];
    fprintf('Range: %s\n',C);
    [handles.datafile,success] = changeActiveChannels(handles.datafile,C);
    fprintf('Success: %d\n',success);
    if success ~= 1
        % signal error
        set(hObject,'String',handles.datafile.channelRangeString);
    end
    if success == 1
        %position window to encompass all channels
        handles.datafile.ylim = [-Inf,Inf];
        handles.datafile.amplitude = 1;
        guidata(hObject,handles);        
        % update plot
        refreshDataView(hObject);
         set(hObject, 'Enable', 'off');
         drawnow;
         set(hObject, 'Enable', 'on');
    end
end

