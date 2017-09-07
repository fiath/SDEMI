function datafile = updateSpikes(datafile)
%UPDATESPIKES Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(datafile.fig);
    stafig = handles.stafig;
    ax = handles.axes1;
    % remove spikeLines
    for i=1:length(datafile.spikeLines)
        delete(datafile.spikeLines(i));
    end
    delete(datafile.currentSpikeLine);
    datafile.currentSpikeLine = gobjects;
    datafile.spikeLines = gobjects;
    if isgraphics(stafig)
        % draw spikeLines
        [spikes,startIndex] = getSpikesInScope(stafig,datafile,datafile.bufferStart,datafile.bufferEnd);
        currentSpike = getSpikeAt(stafig,datafile,datafile.currentSpike);
        fprintf('Drawing %d spikes\n',length(spikes));
        datafile.spikeLines = gobjects(1,length(spikes));
        for i=1:min([1,length(spikes)])
            datafile.spikeLines(i) = line(ax,[spikes(i),spikes(i)],...
                    [datafile.ylim(1),datafile.ylim(1) + ...
                    (datafile.ylim(2)-datafile.ylim(1))*0.05],'Color',[0 0 1],'LineWidth',2);
        end
        for i=2:length(spikes)
            % draw only those spikes which are sufficiently far away (visually distinguishable)
            % currently does not do that
            datafile.spikeLines(i) = line(ax,[spikes(i),spikes(i)],...
                    [datafile.ylim(1),datafile.ylim(1) + ...
                    (datafile.ylim(2)-datafile.ylim(1))*0.05],'Color',[0 0 1],'LineWidth',2);
        end
        for i=1:length(datafile.spikeLines)
            set(datafile.spikeLines(i),'ButtonDownFcn',@(line,~,~)spikeLineClickHandler(line,startIndex+i-1));
        end
        % draw current spike
        datafile.currentSpikeLine = line(ax,[currentSpike,currentSpike],...
                    [datafile.ylim(1),datafile.ylim(1) + ...
                    (datafile.ylim(2)-datafile.ylim(1))*0.05],'Color',[1 0 0],'LineWidth',2);
    end

end

