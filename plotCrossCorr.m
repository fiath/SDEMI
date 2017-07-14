function plotCrossCorr(fig,numOfBins,binSize,unit)
%PLOTAUTOCORR Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    
    AFilePath = handles.unitNames{handles.unit};
    AFilePath = [handles.dirpath,strtok(AFilePath,'.'),'.ev2'];
    BFilePath = handles.unitNames{handles.crossCorrUnit};
    BFilePath = [handles.dirpath,strtok(BFilePath,'.'),'.ev2'];
    %acorr = calcCrossCorr(fig,AFilePath,BFilePath,binSize,numOfBins);

    if handles.unit == handles.crossCorrUnit
        acorr = loadAutoCorr(fig,AFilePath,binSize,numOfBins);
        acorr(numOfBins+1) = 0; % zero out the total number of spikes if autocorrelation
    else
        acorr = calcCrossCorr(fig,AFilePath,BFilePath,binSize,numOfBins);
    end
    bar(handles.autocorr,(-numOfBins:numOfBins)*binSize*1000/handles.samplingRate,acorr,'hist');
    % dont put space because [-1 - 1] is NOT [-2] but [-1, -1]
    xlim(handles.autocorr,[-numOfBins-1,numOfBins+1]*binSize*1000/handles.samplingRate);
    h = findobj(handles.autocorr,'Type','line');
    set(h,'Marker','none'); 
    set(handles.autocorr,'yaxislocation','right');
    
    set(handles.autocorrbinsize,'String',sprintf('Binsize: %0.2f ms',binSize*1000/handles.samplingRate));
    set(handles.autocorrrange,'String',sprintf('Range: %0.2f ms',binSize*numOfBins*1000/handles.samplingRate));

end
