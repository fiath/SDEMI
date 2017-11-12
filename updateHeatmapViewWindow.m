function updateHeatmapViewWindow(datafile)
%UPDATEHEATMAPVIEWWINDOW Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(datafile.fig);

    if ~isgraphics(handles.hmfig)
        return;
    end    
       
    hmHandles = guidata(handles.hmfig);
    window = datafile.dataWindow/datafile.samplingRate;
    views = {'lfp','csd','mua'};
    for i=1:length(views)
        fprintf('Moving window for %s to [%f,%f]\n',views{i},window(1),window(2));
        set(hmHandles.(views{i}).axes,'XLim',window);
    end

end

