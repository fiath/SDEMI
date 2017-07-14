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
    datafile.spikeLines = gobjects;
    if isgraphics(stafig)
        % draw spikeLines
        spikes = getSpikesInScope(stafig,datafile.bufferStart,datafile.bufferEnd);
        fprintf('Drawing %d spikes\n',length(spikes));
        datafile.spikeLines = gobjects(1,length(spikes));
        for i=1:length(spikes)
            datafile.spikeLines(i) = line(ax,[spikes(i)/datafile.samplingRate,spikes(i)/datafile.samplingRate],...
                    [datafile.maxYLimDiff(1)+datafile.channelSpacing,datafile.maxYLimDiff(2) + ...
                    datafile.numOfActiveChannels*datafile.channelSpacing],'Color',[1 0 0],'hittest','off');
        end
    end

end

