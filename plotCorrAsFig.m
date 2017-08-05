function f = plotCorrAsFig(hObject)
%PLOTCORRASFIG Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);

    f = figure('Toolbar','None','Menubar','None');
    f.PaperPositionMode = 'auto';
    %hm = axes(f);
    copyobj(handles.autocorr,f);
    corr = f.CurrentAxes;
    set(corr,'Units','normalized');
    
    %caxis(hm,handles.heatmapRange);
    hm_pos = get(handles.autocorr,'Position');
    sta_pos = get(handles.stafig,'Position');
    hm_pos([1,3]) = hm_pos([1,3])/sta_pos(3);
    hm_pos([2,4]) = hm_pos([2,4])/sta_pos(4);
    margin = [20,20,20,20]; % top,right,bottom,left
    f_pos = get(f,'Position');
    new_f_pos = [f_pos(1:2),hm_pos(3:4).*sta_pos(3:4) + [margin(2)+margin(4),margin(1)+margin(3)]]*1.1;
    set(f,'Position',new_f_pos);
    
    ti = corr.TightInset+0.05; 
    h_margin = ti(1) + ti(3);
    v_margin = ti(2) + ti(4);
    corr.Position = [ti(1) ti(2) 1-h_margin 1-v_margin];

end

