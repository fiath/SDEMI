function updateSpikeSelector(handles)
%UPDATESPIKESELECTOR Summary of this function goes here
%   Detailed explanation goes here
    set(handles.currentspiketext,'String',num2str(handles.datafile.currentSpike));
    set(handles.allspiketext,'String',['/',num2str(handles.datafile.allSpikeCount)]);

end

