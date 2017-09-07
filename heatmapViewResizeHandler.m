function heatmapViewResizeHandler(fig,~,~)
%HEATMAPVIEWRESIZEHANDLER Summary of this function goes here
%   Detailed explanation goes here
    updateHeatmapViewAxes(fig);
    
    % reposition panels
    handles = guidata(fig);
    views = {'lfp','csd','mua'};
    for i=1:length(views)
        axes = handles.(views{i}).axes.Position;
        panel = handles.(views{i}).panel;
        panel.Position(1) = (axes(1)+axes(3)/2)*fig.Position(3)-panel.Position(3)/2;
        panel.Position(2) = fig.Position(4)-(1-axes(2)-axes(4))/2*fig.Position(4)-panel.Position(4)/2;
    end
end

