function changeAmplitude(hObject,dir)
    handles = guidata(hObject);
    if dir < 0
        scale = 1.1;
        handles.datafile.amplitude = handles.datafile.amplitude*1.1;
    else
        scale = 0.91;
        handles.datafile.amplitude = handles.datafile.amplitude*0.91;
    end
    nextActive = 1;
    for i=handles.datafile.numberOfChannels:-1:1
        if ~handles.datafile.activeChannels(i)
            continue;
        end
        set(handles.datafile.channelLines(i),'YData',...
            (get(handles.datafile.channelLines(i),'YData') - ...
            nextActive*handles.datafile.channelSpacing)*scale + ...
            nextActive*handles.datafile.channelSpacing);
        nextActive = nextActive+1;
    end
    guidata(hObject,handles);
end