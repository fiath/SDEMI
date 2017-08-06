function [datafile,window] = switchToUnSampled(datafile,window)
    fprintf('Switching to nonsampled\n');
    datafile.length = datafile.unsampled.length;
    datafile.samplingRate = datafile.unsampled.samplingRate;
    datafile.usingDownsampled = 0;
    
    unSampledWindow = floor(window*(datafile.downsampled.resolution/2));
    [datafile,window,~] = checkDataWindow(datafile,unSampledWindow,1); % dont switch
    handles = guidata(datafile.fig);
    set(handles.filtertoggleview,'Enable','on');
    set(handles.filterchangeview,'Enable','on');
end

