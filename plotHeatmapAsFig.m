function f = plotHeatmapAsFig(hObject)
%SAVEIMAGEASFIG Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);

    f = figure('Toolbar','None','Menubar','None');
    f.PaperPositionMode = 'auto';
    %hm = axes(f);
    copyobj(handles.heatmap,f);
    hm = f.CurrentAxes;
    
    %caxis(hm,handles.heatmapRange);
    hm_pos = get(handles.heatmap,'Position');
    sta_pos = get(handles.stafig,'Position');
    margin = [20,20,20,20]; % top,right,bottom,left
    f_pos = get(f,'Position');
    new_f_pos = [f_pos(1:2),hm_pos(3:4).*sta_pos(3:4) + [margin(2)+margin(4),margin(1)+margin(3)]]*1.1;
    set(f,'Position',new_f_pos);
    
    ti = hm.TightInset+0.05; 
    h_margin = ti(1) + ti(3);
    v_margin = ti(2) + ti(4);
    hm.Position = [ti(1) ti(2) 1-h_margin 1-v_margin];
    
    C = colorbar(hm);
end

