function autocorrChangeHandler(hObject,~,~)
%AUTOCORRCHANGEHANDLER Summary of this function goes here
%   Detailed explanation goes here

    handles = guidata(hObject);
    
    answer = inputdlg({'Binsize [ms]: ','Range [ms]: '},...
                            'AutoCorrelation',1,{num2str(1),num2str(30)});
    if isempty(answer)
        % user cancelled
        return;
    end
    binsize = str2double(answer{1});
    range = str2double(answer{2});
    
    % binsize must be greater than the resolution
    binsize = max([floor(binsize*handles.samplingRate/1000),1]);
    numOfBins = min([max([floor(range*handles.samplingRate/1000/binsize),1]),100]);
    
    handles.binSize = binsize;
    handles.numOfBins = numOfBins;
    guidata(hObject,handles);

    plotCrossCorr(handles.stafig,numOfBins,binsize,handles.unit);
end

