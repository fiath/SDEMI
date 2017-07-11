function resChanged = ResolutionChanged(handles,window)
%RESOLUTIONCHANGED Summary of this function goes here
%   Detailed explanation goes here
    fig = handles.figure1;
    figPos = get(fig,'Position');
    ax = handles.axes1;
    axPos = get(ax,'Position');
    xSize = axPos(3)*figPos(3);
    res = floor((window(2)-window(1)+1)/xSize);
    if res >= handles.datafile.dataResolution
        resChanged = false;
    else
        resChanged = true;
    end
end

