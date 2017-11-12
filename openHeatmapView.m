function openHeatmapView(rawfig)
%OPENHEATMAPVIEW Summary of this function goes here
%   Detailed explanation goes here
    rawHandles = guidata(rawfig);
    if isgraphics(rawHandles.hmfig)
        close(rawHandles.hmfig);
    end

    hmFig = matlab.hg.internal.openfigLegacy('heatmapview', 'reuse', 'visible');
    rawHandles.hmfig = hmFig;
    set(rawHandles.heatmapView,'Enable','off');
    
    handles = struct('hmfig',hmFig,'rawfig',rawfig);
    views = {'lfp','csd','mua'};
    for i=1:length(views)
        handles.(views{i}) = struct();
        handles.(views{i}).axes = findobj(hmFig,'Tag',[views{i},'axes']);
        handles.(views{i}).panel = findobj(hmFig,'Tag',[views{i},'panel']);
        handles.(views{i}).axesWidth = handles.(views{i}).axes.Position(3); % normalized
        handles.(views{i}).image = imagesc(handles.(views{i}).axes,[]);
        handles.(views{i}).colorbarWidth = 30; % pixel
        handles.(views{i}).colorbarMargin = 10; % pixel
        handles.(views{i}).colorbar = colorbar(handles.(views{i}).axes,'Location','manual','Units','pixels');
        handles.(views{i}).colorbar.Position(3) = handles.(views{i}).colorbarWidth;
        handles.(views{i}).colorbar.UIContextMenu = '';
        handles.(views{i}).rangeButton = findobj(hmFig,'Tag',[views{i},'rangebutton']);
        handles.(views{i}).minText = findobj(hmFig,'Tag',[views{i},'min']);
        handles.(views{i}).maxText = findobj(hmFig,'Tag',[views{i},'max']);
        handles.(views{i}).range = [];
        
        set(handles.(views{i}).rangeButton,'Callback',@(hObject,~,~) hmViewManualRangeHandler(hObject,views{i}));
        set(handles.(views{i}).minText,'Callback',@(hObject,~,~) hmViewMinHandler(hObject,views{i}));
        set(handles.(views{i}).maxText,'Callback',@(hObject,~,~) hmViewMaxHandler(hObject,views{i}));
    end
    
    % load ldr files
    handles.ldr_csd = loadLDR('./CSD32x3.ldr');
    handles.ldr_hamming = loadLDR('./csdh30.ldr');
    handles.ldr_composite = handles.ldr_hamming*handles.ldr_csd;
    
    %set(handles.csd.rangeButton,'Enable','off');
    
    set(hmFig,'CloseRequestFcn',@closeHandler);
    set(hmFig,'ResizeFcn',@heatmapViewResizeHandler);
    
    guidata(hmFig,handles);
    
    guidata(rawfig,rawHandles);
    
    %set(rawHandles.traceview,'Enable','on');
    
    refreshDataView(rawfig);
    updateHeatmapViewAxes(hmFig);
end

function closeHandler(hObject,~,~)
    handles = guidata(hObject);
    rawfig = handles.rawfig;
    rawHandles = guidata(rawfig);
    rawHandles.hmfig = gobjects;
    set(rawHandles.heatmapView,'Enable','on');
    guidata(rawfig,rawHandles);
    delete(hObject);
end

