function success = plotHeatmap( fig, position )
%UPDATEHEATMAP Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    if position < 1 || position > size(handles.data,2)
        success = 0;
        return;
    end
    success = 1;
    
    handles.position = position;
    c = handles.column;
    r = ceil(size(handles.data,1)/c);
    if c*r == size(handles.data)
        hm_data = reshape(handles.data(:,position,handles.unit),[c,r])';
    else
        hm_data = zeros(r,c);
        for i=1:r
            for j=1:c
                if (i-1)*c+j <= size(handles.data,1)
                    hm_data(i,j) = handles.data((i-1)*c+j,position,handles.unit);
                else
                    hm_data(i,j) = nan;
                end
            end
        end
    end
    max_abs_v = max(max(abs(handles.data(:,:,handles.unit))));
    h = imagesc(handles.heatmap,hm_data);
    handles.heatMapImage = h;
    h.UIContextMenu = handles.heatCtxMenu;
    if c*r ~= size(handles.data)
        set(h,'alphadata',~isnan(hm_data));
    end
    caxis(handles.heatmap,[-max_abs_v,max_abs_v]);
    C = colorbar(handles.heatmap);
    C.UIContextMenu = '';
    
    guidata(fig,handles);
    updateLinePosition(fig);
    updateDatapointTextBoxes(fig);
end

function updateLinePosition(fig)
    handles = guidata(fig);
    for i=1:size(handles.lines,2)
        delete(handles.lines(i));
        Xpos  = (i-1)*(size(handles.data,2)-1) + (handles.position-1);
        handles.lines(i) = line(handles.axes1,[Xpos,Xpos],get(handles.axes1,'YLim'),'Color','red');
    end
    guidata(fig,handles);
end

