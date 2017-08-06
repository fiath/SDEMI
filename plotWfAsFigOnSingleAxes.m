function f = plotWfAsFigOnSingleAxes(hObject)
%PLOTWFASFIG Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    c = handles.column;
    r = ceil(size(handles.data,1)/c);
    
    data = handles.data(:,:,handles.unit);
    range = 50:130;

    global_margin = [0.1, 0.1, 0.1, 0.1]; % top,right,bottom,left, perc of figure
    axes_size = [(1-global_margin(2)-global_margin(4)),(1-global_margin(1)-global_margin(3))];
    axes_margin = [0.05 0.05 0.05 0.05]; % perc of outer_width
    axes_inner_width = 1 -axes_margin(2)-axes_margin(4);
    axes_inner_height = 1 -axes_margin(1)-axes_margin(3);
    
    yMax = max(max(data));
    yMin = min(min(data));
    f = figure('Toolbar','None','Menubar','None');
    fig_pos = get(f,'Position');
    wf_pos = get(handles.axes1,'Position');
    sta_pos = get(handles.stafig,'Position');
    set(f,'Position',[fig_pos(1:2),wf_pos(3:4).*sta_pos(3:4)./axes_size]);
    ax = axes(f,'Position',[global_margin(4) global_margin(3),axes_size]);
    xlim(ax,[0,c]);
    ylim(ax,[0,r]);
    axis(ax,'off');
    for i=1:size(data,1)
        col = mod(i-1,c)+1;
        row = ceil(i/c);
        x = linspace(col-1 + axes_margin(4),col-1 + axes_margin(4)+axes_inner_width,length(range));
        y = (data(i,range)-yMin)/(yMax-yMin)*axes_inner_height+(r-row)+axes_margin(3);
        line(ax,x,y);
    end
end

