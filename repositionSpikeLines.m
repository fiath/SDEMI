function repositionSpikeLines(datafile)
%REPOSITIONSPIKELINES Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(datafile.fig);
    stafig = handles.stafig;
    if ~isgraphics(stafig)
        % nothing to reposition
        return;
    end
    for i=1:length(datafile.spikeLines)
        set(datafile.spikeLines(i),'YData',...
                [datafile.ylim(1),datafile.ylim(1) + ...
                (datafile.ylim(2)-datafile.ylim(1))*0.05]);
    end
    set(datafile.currentSpikeLine,'YData',...
                [datafile.ylim(1),datafile.ylim(1) + ...
                (datafile.ylim(2)-datafile.ylim(1))*0.05]);

end

