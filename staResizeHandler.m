function staResizeHandler(hObject,~,~)
    % reposition dropdown menu
    handles = guidata(hObject);
    
    axPos = get(handles.axes1,'Position');
    figPos = get(handles.stafig,'Position');
    
    pos = get(handles.dropDown,'Position');
    width = pos(3);
    height = pos(4);
    top = (axPos(2) + axPos(4))*figPos(4);
    center = (axPos(1) + axPos(3)/2)*figPos(3);
    set(handles.dropDown,'Position',[center - width/2,top + 5,width,height]);
    
    
    % reposition datapoint windows (currDP, totalDP)
    hPos =  get(handles.heatmap,'Position');
    currPos = get(handles.currDP,'Position');
    totPos = get(handles.totalDP,'Position');
    cw = currPos(3);
    ch = currPos(4);
    hTop = (hPos(2) + hPos(4))*figPos(4);
    hCenter = (hPos(1) + hPos(3)/2)*figPos(3);
    set(handles.currDP,'Position',[hCenter - cw,hTop + 5,cw,ch]);
    set(handles.totalDP,'Position',[hCenter + 8,hTop + 9,totPos(3:4)]);
    
    % reposition info view
    infoL = (hPos(1) + hPos(3))*figPos(3) + 100 + 0.05*figPos(3);
    infoT = hTop;
    infoPos = get(handles.infopanel,'Position');
    set(handles.infopanel,'Position',[infoL,infoT-infoPos(4),infoPos(3),infoPos(4)]);
    
    % reposition autocorr
    corrL = infoL;
    corrB = hPos(2)*figPos(4);
    %corrH = hPos(4)*figPos(4) - infoPos(4) - 30;
    corrPos = get(handles.autocorr,'Position');
    set(handles.autocorr,'Position',[corrL,corrB,corrPos(3),corrPos(4)]);
end
