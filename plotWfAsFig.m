function f = plotWfAsFig(hObject)
%PLOTWFASFIG Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    c = handles.column;
    r = ceil(size(handles.data,1)/c);
    
    data = handles.data(:,:,handles.unit);

    global_margin = [0.1, 0.1, 0.1, 0.1]; % top,right,bottom,left, perc of figure
    axes_margin_relative = [0.05 0.05 0.05 0.05]; % perc of outer_width
    axes_outer_width = (1-global_margin(2)-global_margin(4))/c;
    axes_outer_height = (1-global_margin(1)-global_margin(3))/r;
    axes_margin([2,4]) = axes_margin_relative([2,4])*axes_outer_width;
    axes_margin([1,3]) = axes_margin_relative([1,3])*axes_outer_height;
    axes_inner_width = axes_outer_width -axes_margin(2)-axes_margin(4);
    axes_inner_height = axes_outer_height -axes_margin(1)-axes_margin(3);
    
    yMax = max(max(data));
    yMin = min(min(data));
    f = figure('Toolbar','None','Menubar','None');
    axs = gobjects(size(data,1),1);
    for i=1:size(data,1)
        col = mod(i-1,c)+1;
        row = ceil(i/c);
        axs(i) = axes(f,'Position',[global_margin(4)+axes_outer_width*(col-1)+axes_margin(4) , ...
                                    1-(global_margin(1)+axes_outer_height*row)+axes_margin(3), ...
                                    axes_inner_width, axes_inner_height]);
        line(axs(i),50:130,data(i,50:130));
        ylim(axs(i),[yMin,yMax]);
        xlim(axs(i),[50,130]);
        axis(axs(i),'off');
    end
end

