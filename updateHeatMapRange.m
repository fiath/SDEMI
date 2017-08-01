function updateHeatMapRange(fig,range)
%UPDATEHEATMAPRANGE Summary of this function goes here
%   Detailed explanation goes here    
    handles = guidata(fig);
    if nargin < 2
        if isempty(handles.heatmapRange)
            max_abs_v = max(max(abs(handles.data(:,:,handles.unit))));
            range = [-max_abs_v,max_abs_v];
        else
            range = handles.heatmapRange;
        end
    end
    handles.heatmapRange = range;
    guidata(handles.stafig,handles);
    caxis(handles.heatmap,range);
    set(handles.heatmapRangeMin,'String',num2str(range(1)));
    set(handles.heatmapRangeMax,'String',num2str(range(2)));
end

