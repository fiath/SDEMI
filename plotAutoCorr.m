function numOfSpikes = plotAutoCorr(fig,numOfBins,binSize)
%PLOTAUTOCORR Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    
    evFilePath = handles.unitNames{handles.unit};
    evFilePath = [handles.dirpath,strtok(evFilePath,'.'),'.ev2'];
    acorr = loadAutoCorr(fig,evFilePath,binSize,numOfBins);
    numOfSpikes = acorr(numOfBins+1);
    acorr(numOfBins+1) = 0; % zero out the total number of spikes
    bar(handles.autocorr,(-numOfBins:numOfBins)*binSize*1000/handles.samplingRate,acorr,'hist');
    % dont put space because [-1 - 1] is NOT [-2] but [-1, -1]
    xlim(handles.autocorr,[-numOfBins-1,numOfBins+1]*binSize*1000/handles.samplingRate);
    h = findobj(handles.autocorr,'Type','line');
    set(h,'Marker','none'); 
    set(handles.autocorr,'yaxislocation','right');
    
    set(handles.autocorrbinsize,'String',sprintf('Binsize: %0.2f ms',binSize*1000/handles.samplingRate));
    set(handles.autocorrrange,'String',sprintf('Range: %0.2f ms',binSize*numOfBins*1000/handles.samplingRate));

end

