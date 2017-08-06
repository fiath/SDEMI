function [datafile,window] = switchToDownSampled(datafile,window)
    fprintf('Switching to downsampled\n');
    datafile.unsampled = struct('length',datafile.length,'samplingRate',datafile.samplingRate);
    datafile.length = size(datafile.downsampled.data,2);
    datafile.samplingRate = datafile.samplingRate/(datafile.downsampled.resolution/2);
    datafile.usingDownsampled = 1;
    
    downSampledWindow = floor(window/(datafile.downsampled.resolution/2));
    [datafile,window,~] = checkDataWindow(datafile,downSampledWindow,1); % dont switch
    handles = guidata(datafile.fig);
    set(handles.filtertoggleview,'Enable','off');
    set(handles.filterchangeview,'Enable','off');
end