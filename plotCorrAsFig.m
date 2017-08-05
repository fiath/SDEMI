function f = plotCorrAsFig(hObject)
%PLOTCORRASFIG Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);

    f = figure('Toolbar','None','Menubar','None');
    f.PaperPositionMode = 'auto';
    corr = axes(f);

    c = handles.column;
    r = ceil(size(handles.data,1)/c);
    if c*r == size(handles.data)
        hm_data = reshape(handles.data(:,handles.position,handles.unit),[c,r])';
    else
        hm_data = zeros(r,c);
        for i=1:r
            for j=1:c
                if (i-1)*c+j <= size(handles.data,1)
                    hm_data(i,j) = handles.data((i-1)*c+j,handles.position,handles.unit);
                else
                    hm_data(i,j) = nan;
                end
            end
        end
    end
    h = imagesc(corr,hm_data);
    if c*r ~= size(handles.data)
        set(h,'alphadata',~isnan(hm_data));
    end
    C = colorbar(corr);
    caxis(corr,handles.heatmapRange);
    hm_pos = get(handles.heatmap,'Position');
    sta_pos = get(handles.stafig,'Position');
    margin = [20,20,20,20]; % top,right,bottom,left
    f_pos = get(f,'Position');
    new_f_pos = [f_pos(1:2),hm_pos(3:4).*sta_pos(3:4) + [margin(2)+margin(4),margin(1)+margin(3)]]*1.1;
    set(f,'Position',new_f_pos);
    
    outerpos = corr.OuterPosition;
    ti = corr.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    hm_width = outerpos(3) - ti(1) - ti(3);
    hm_height = outerpos(4) - ti(2) - ti(4);
    corr.Position = [left+0.05 bottom+0.05 hm_width-0.1 hm_height-0.1];

end

