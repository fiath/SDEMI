function scrollHandler(hObject, eventdata, handles)
    handles = guidata(hObject);
    if ~handles.datLoaded
        return;
    end
    C = get (handles.axes1, 'CurrentPoint');
    XLim = get(handles.axes1, 'XLim');
    YLim = get(handles.axes1, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        if ~handles.modifiers.shift
            ySize = YLim(2) - YLim(1);
            center = (YLim(1)+YLim(2))/2;
            if ~handles.modifiers.ctrl
                scrollVert(hObject,eventdata.VerticalScrollCount);
                return;
            else 
                if eventdata.VerticalScrollCount > 0 
                    ySize = ySize + max([ySize*0.05,10]);
                else
                   ySize = ySize*0.95;
                end
                YLim = [center - floor(ySize/2),center + ceil(ySize/2)];
            end
            handles.datafile.ylim = CheckYLim(YLim,handles.datafile);
            set(handles.axes1,'YLim',handles.datafile.ylim);
            
            % update pivot line
            center = round((handles.datafile.dataWindow(1) + handles.datafile.dataWindow(2))/2);
            delete(handles.datafile.pivotLine);
            handles.datafile.pivotLine = line(handles.axes1,[center,center],get(handles.axes1,'YLim'));
        else
            window = handles.datafile.dataWindow;
            if ~handles.modifiers.ctrl
                scrollHoriz(hObject,eventdata.VerticalScrollCount);
                return;
            else
                center = floor((window(1) + window(2))/2);
                if eventdata.VerticalScrollCount > 0 
                    handles.datafile.windowSize = floor(handles.datafile.windowSize + max([5,handles.datafile.windowSize*0.05]));
                else
                    handles.datafile.windowSize = floor(handles.datafile.windowSize*0.95);
                end
                window = [center - floor(handles.datafile.windowSize/2),...
                          center + ceil(handles.datafile.windowSize/2)];
                if ResolutionChanged(handles,window)
                   handles.datafile = updateWindow(handles,window,true);
                else
                   handles.datafile = updateWindow(handles,window);
                end
            end
%             handles.datafile = updateWindow(handles,window);
        end
        updateIdPositions(handles);
        guidata(hObject, handles);
        updateTooltip(hObject);
        %drawnow;
    end

