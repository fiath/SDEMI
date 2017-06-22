function onChannelIdHandler(object,~,id)
     handles = guidata(gcf);
     onchannelclickHandler(handles.datafile.channelLines(id),0,id);

