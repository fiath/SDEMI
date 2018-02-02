function setCurrentSpike(fig,spike)
%SETCURRENTSPIKEHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    if spike < 1 || spike > handles.datafile.allSpikeCount
        error('Invalid spike id');
    end
    handles.datafile.currentSpike = spike;
    file = handles.datafile.eventFiles(handles.datafile.activeEventFile);
    file.Position = spike;
    handles.datafile.eventFiles(handles.datafile.activeEventFile) = file;
    updateSpikeSelector(handles);
    guidata(fig,handles);
    set(handles.currentspiketext,'Enable','off');
    drawnow;
    set(handles.currentspiketext,'Enable','on');
    
    spikeValue = getSpikeAt(handles.stafig,handles.datafile,handles.datafile.currentSpike);
    
    center = round(spikeValue*handles.datafile.samplingRate);
    ws = handles.datafile.windowSize;
    handles.datafile =  updateWindow(handles,[center-ceil(ws/2),center+floor(ws/2)]);
    guidata(fig,handles);
    
    % check if the currentSpikeLine has been set
    pos = get(handles.datafile.currentSpikeLine,'XData');
    if abs(pos(1)-spikeValue) < 1/handles.datafile.samplingRate/2
        % has been moved don't do anything
        return;
    end
    % draw current spike
    delete(handles.datafile.currentSpikeLine);
    handles.datafile.currentSpikeLine = line(handles.axes1,[spikeValue,spikeValue],...
                [handles.datafile.ylim(1),handles.datafile.ylim(1) + ...
                (handles.datafile.ylim(2)-handles.datafile.ylim(1))*0.1],...
                'Color',[1 0 0],'hittest','off','LineWidth',2);
    guidata(fig,handles);
end

