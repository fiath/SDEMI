function onChannelIdHandler(hObject,~,id)
     handles = guidata(hObject);
     onchannelclickHandler(handles.datafile.channelLines(id),0,id);

