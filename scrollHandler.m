function scrollHandler(hObject, eventdata, handles)
    C = get (gca, 'CurrentPoint');
    XLim = get(gca, 'XLim');
    YLim = get(gca, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        handles = guidata(gcf);
        if ~handles.modifiers.shift
            ySize = YLim(2) - YLim(1);
            center = (YLim(1)+YLim(2))/2;
            if ~handles.modifiers.ctrl
                if eventdata.VerticalScrollCount < 0 
                    YLim = YLim + ySize/20;
                else
                    YLim = YLim - ySize/20;
                end
            else 
                if eventdata.VerticalScrollCount > 0 
                    ySize = ySize + max([ySize*0.05,10]);
                else
                   ySize = ySize*0.95;
                end
                YLim = [center - floor(ySize/2),center + ceil(ySize/2)];
            end
            handles.datafile.ylim = YLim;
            set(gca,'YLim',handles.datafile.ylim);
        else
            window = handles.datafile.dataWindow;
            if ~handles.modifiers.ctrl
                if eventdata.VerticalScrollCount > 0 
                    window = window + floor(handles.datafile.windowSize/20);
                else
                    window = window - floor(handles.datafile.windowSize/20);
                end
            else
                center = floor((window(1) + window(2))/2);
                if eventdata.VerticalScrollCount > 0 
                    handles.datafile.windowSize = floor(handles.datafile.windowSize + max([5,handles.datafile.windowSize*0.05]));
                else
                    handles.datafile.windowSize = floor(handles.datafile.windowSize*0.95);
                end
                window = [center - floor(handles.datafile.windowSize/2),...
                          center + ceil(handles.datafile.windowSize/2)];
            end
            handles.datafile = updateWindow(handles,window);
        end
        updateIdPositions(handles.datafile);
        guidata(hObject, handles);
    end

