 function onchannelclickHandler(object,~,id)
     handles = guidata(object);
     lines = handles.datafile.channelLines;
     ids = handles.datafile.channelIds;
     for i=1:size(lines,1)
         if ~handles.datafile.activeChannels(i)
             continue;
         end
         lines(i).Color = 'black';
         lines(i).LineWidth = 1;
         ids(i).ForegroundColor = 'black';
     end
     object.Color = 'red';
     object.LineWidth = 2;
     ids(id).ForegroundColor = 'red';

