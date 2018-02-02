function datafile = updateSpikes(datafile,force)
%UPDATESPIKES Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(datafile.fig);
    if ~handles.datLoaded && (nargin < 2 || ~force)
        return;
    end
    fprintf('Removing %d spikeLines\n',length(datafile.spikeLines));
    % remove spikeLines
    for i=1:length(datafile.spikeLines)
        delete(datafile.spikeLines(i));
    end
    delete(datafile.currentSpikeLine);
    datafile.currentSpikeLine = gobjects(1,0);
    spikeLines = gobjects(1,0);
    allEventFiles = keys(datafile.eventFiles);
    for i=1:length(allEventFiles)
        if ~strcmp(allEventFiles{i},datafile.activeEventFile) && ~datafile.eventFiles(allEventFiles{i}).Visible
            continue;
        end
        datafile = updateSpikesOf(datafile,allEventFiles{i},strcmp(allEventFiles{i},datafile.activeEventFile),handles);
        spikeLines = [spikeLines,datafile.spikeLines];
    end
    datafile.spikeLines = spikeLines;

end

function datafile = updateSpikesOf(datafile,eventFilePath,active,handles)
%UPDATESPIKES Summary of this function goes here
%   Detailed explanation goes here
    % draw spikeLines
    stafig = handles.stafig;
    ax = handles.axes1;
    [spikes,startIndex] = getSpikesInScope(stafig,datafile,datafile.bufferStart,datafile.bufferEnd,eventFilePath);
    fprintf('Drawing %d spikes\n',length(spikes));
    datafile.spikeLines = gobjects(1,length(spikes));
    color = datafile.eventFiles(eventFilePath).Color;
    for i=1:min([1,length(spikes)])
        datafile.spikeLines(i) = line(ax,[spikes(i),spikes(i)],...
                [datafile.ylim(1),datafile.ylim(1) + ...
                (datafile.ylim(2)-datafile.ylim(1))*0.05],'Color',color,'LineWidth',2);
    end
    for i=2:length(spikes)
        % draw only those spikes which are sufficiently far away (visually distinguishable)
        % currently does not do that
        datafile.spikeLines(i) = line(ax,[spikes(i),spikes(i)],...
                [datafile.ylim(1),datafile.ylim(1) + ...
                (datafile.ylim(2)-datafile.ylim(1))*0.05],'Color',color,'LineWidth',2);
    end
    
    if active
        for i=1:length(datafile.spikeLines)
            set(datafile.spikeLines(i),'ButtonDownFcn',@(line,~,~)spikeLineClickHandler(line,startIndex+i-1));
        end
        currentSpike = getSpikeAt(stafig,datafile,datafile.currentSpike);
        % draw current spike
        datafile.currentSpikeLine = line(ax,[currentSpike,currentSpike],...
                    [datafile.ylim(1),datafile.ylim(1) + ...
                    (datafile.ylim(2)-datafile.ylim(1))*0.05],'Color',[1 0 0],'LineWidth',2);
            
    end

end

