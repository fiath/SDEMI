function updateIdPositions(handles)
    datafile = handles.datafile;
    YLim = get(handles.axes1, 'YLim');
    axPos = get(handles.axes1,'Position');
    figPos = get(handles.figure1,'Position');
    axPos(1) = axPos(1)*figPos(3);
    axPos(2) = axPos(2)*figPos(4);
    axPos(3) = axPos(3)*figPos(3);
    axPos(4) = axPos(4)*figPos(4);
    labels = datafile.channelIds;
    next_active_offset = 1;
    for i=size(labels,1):-1:1
        if ~datafile.activeChannels(i)
            set(labels(i),'Visible','off');
            continue;
        end
        pos = get(labels(i),'Position');
        width = pos(3);
        height = pos(4);
        if next_active_offset*1000 < YLim(1) || next_active_offset*1000 > YLim(2)
            set(labels(i),'Visible','off');
        else
            bottom = axPos(2) + axPos(4)/(YLim(2)-YLim(1))*(next_active_offset*1000-YLim(1));
            set(labels(i),'Position',[axPos(1)-width-5, bottom - height/2,width,height]);
            set(labels(i),'Visible','on');
        end
        next_active_offset = next_active_offset + 1;
    end

