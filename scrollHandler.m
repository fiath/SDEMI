function scrollHandler(hObject, eventdata, ~)
    handles = guidata(hObject);
    if ~handles.datLoaded
        return;
    end
    C = get (handles.axes1, 'CurrentPoint');
    XLim = get(handles.axes1, 'XLim');
    YLim = get(handles.axes1, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        if ~handles.modifiers.alt
            if ~handles.modifiers.shift
                if ~handles.modifiers.ctrl
                    scrollVert(hObject,eventdata.VerticalScrollCount);
                else 
                    zoomVert(hObject,eventdata.VerticalScrollCount);
                end
            else
                if ~handles.modifiers.ctrl
                    scrollHoriz(hObject,eventdata.VerticalScrollCount);
                else
                    zoomHoriz(hObject,eventdata.VerticalScrollCount);
                end
            end
        else
            % change amplitude
            changeAmplitude(hObject,eventdata.VerticalScrollCount);
        end
    end

