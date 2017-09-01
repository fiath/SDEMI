function updateHeatmapViewRange(fig,datafile,axesId,range)
%UPDATEHEATMAPRANGE Summary of this function goes here
%   axesId is 'lfp', 'csd' or 'mua'  

    handles = guidata(fig);
    if nargin < 4
        if isempty(handles.(axesId).range)
            if strcmp(axesId,'lfp')
                max_abs_v = datafile.lfpAbsMaxValue;
                range = [-max_abs_v,max_abs_v];
            elseif strcmp(axesId,'mua')
                max_abs_v = datafile.muaAbsMaxValue;
                range = [0,max_abs_v];
            elseif strcmp(axesId,'csd')
                return;
            end
        else
            range = handles.(axesId).range;
        end
    end
    fprintf('Updating %s Range to [%f,%f]\n',axesId,range(1),range(2));
    handles.(axesId).range = range;
    guidata(handles.hmfig,handles);
    caxis(handles.(axesId).axes,range);
    set(handles.(axesId).minText,'String',num2str(range(1)));
    set(handles.(axesId).maxText,'String',num2str(range(2)));
end
