function plotHeatmapView(datafile)
%PLOTHEATMAPVIEW Summary of this function goes here
%   Detailed explanation goes here
    rawHandles = guidata(datafile.fig);

    if ~isgraphics(rawHandles.hmfig)
        return;
    end
    
    fprintf('Updating LFP,CSD and MUA with range [%f,%f],\n',...
        datafile.bufferStart/datafile.samplingRate,...
        datafile.bufferEnd/datafile.samplingRate);

    handles = guidata(rawHandles.hmfig);
    
    % plot lfp
    set(handles.lfp.axes,'YLim',[0 datafile.numberOfChannels]);
    set(handles.lfp.image,'XData',[datafile.bufferStart,datafile.bufferEnd]/datafile.samplingRate);
    set(handles.lfp.image,'YData',[0.5 datafile.numberOfChannels-0.5]);
    set(handles.lfp.image,'CData',datafile.lfpBuffer);
    
    % plot csd
    set(handles.csd.axes,'YLim',[1.5 31.5]);
    set(handles.csd.image,'XData',[datafile.bufferStart,datafile.bufferEnd]/datafile.samplingRate);
    set(handles.csd.image,'YData',[2 31]);
    set(handles.csd.image,'CData',datafile.csdBuffer);

    % plot mua
    set(handles.mua.axes,'YLim',[0 datafile.numberOfChannels]);
    set(handles.mua.image,'XData',[datafile.bufferStart,datafile.bufferEnd]/datafile.samplingRate);
    set(handles.mua.image,'YData',[0.5 datafile.numberOfChannels-0.5]);
    set(handles.mua.image,'CData',datafile.muaBuffer);
    
    if ~isManualRange(handles.hmfig,'lfp')
        handles.lfp.range = []; % invalidate range to automatically recalculate
    end
    if ~isManualRange(handles.hmfig,'csd')
        handles.csd.range = []; % invalidate range to automatically recalculate
    end
    if ~isManualRange(handles.hmfig,'mua')
        handles.mua.range = []; % invalidate range to automatically recalculate
    end
    
    guidata(handles.hmfig,handles);
    
    updateHeatmapViewRange(handles.hmfig,datafile,'lfp');
    updateHeatmapViewRange(handles.hmfig,datafile,'csd');
    updateHeatmapViewRange(handles.hmfig,datafile,'mua');
end

