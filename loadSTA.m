function loadSTA(fig)
%LOADSTA Summary of this function goes here
%   Detailed explanation goes here

    handles = guidata(fig);
    
    answer = inputdlg({'Number of colummns: '},...
                            'Columns',1,{'4'});
    if isempty(answer)
        % user cancelled
        return;
    end
    answer = str2double(answer);
    if isnan(answer)
        % invalid input
        return;
    end
    answer = floor(abs(answer));
    if answer < 1 || answer > 6
        % invalid input
        return;
    end

    startdir = handles.datafile.filedir(1:end-1);
    startdir = startdir(1:find(startdir=='/',1,'last')-1);
    dirpath = uigetdir(startdir,'Select the directory containing the .mat files');
    if dirpath == 0
        return;
    end
    
    dirpath = [dirpath '/'];
    dataList = dir([dirpath '*.mat']);
    if isempty(dataList)
        % directory contains no .mat files.
        return
    end
    
    if isgraphics(handles.stafig)
        close(handles.stafig);
    end
    
    % set up gui
    stafig = matlab.hg.internal.openfigLegacy('sta', 'reuse', 'visible');
    set(stafig,'CloseRequestFcn',@closeHandler);
    set(stafig,'ResizeFcn',@staResizeHandler);
    set(stafig,'WindowScrollWheelFcn',@scrollHandler);
    set(stafig,'WindowButtonDownFcn',@stafigButtonDownHandler);
    set(stafig,'WindowButtonMotionFcn',@stafigMouseMoveHandler);
    set(stafig,'WindowKeyPressFcn',@staKeydownHandler);
    handles.stafig = stafig;
    set(handles.traceview,'Enable','off');
    samplingRate = handles.datafile.samplingRate;
    guidata(fig,handles);
    handles = struct('rawfig',fig);
    handles.stafig = stafig;
    handles.samplingRate = samplingRate;
    handles.column = answer;
    % <String,[Int]> maps the name of the file to the array of spike
    % positions in datapoints
    handles.eventFiles = containers.Map;
    %handles.autoCorrBinSize = 20;
    %handles.autoCorrRange = 30;
    
    % graphic objects
    handles.lines = gobjects(1,handles.column);
    handles.axes1 = findobj(stafig,'Tag','axes1');
    handles.heatmap = findobj(stafig,'Tag','axes2');
    handles.heatmapOriginalPosition = get(handles.heatmap,'Position');
    handles.globalSave = findobj(stafig,'Tag','save');
    handles.totalDP = findobj(stafig,'Tag','totaldatapoints');
    handles.currDP = findobj(stafig,'Tag','currentdatapoint');
    handles.corrSelector = findobj(stafig,'Tag','crosscorrsel');
    handles.autocorr = findobj(stafig,'Tag','autocorr');
    handles.autocorrInf = findobj(stafig,'Tag','autocorrinf');
    handles.autocorrChange = findobj(stafig,'Tag','autocorrchange');
    handles.autocorrbinsize = findobj(stafig,'Tag','autocorrbinsize');
    handles.autocorrrange = findobj(stafig,'Tag','autocorrrange');
    handles.infopanel = findobj(stafig,'Tag','infopanel');
    handles.spikenumber = findobj(stafig,'Tag','spikenumber');
    handles.spikefrequency = findobj(stafig,'Tag','spikefrequency');
    handles.spikemin = findobj(stafig,'Tag','spikemin');
    handles.spikemax = findobj(stafig,'Tag','spikemax');
    
    set(handles.currDP,'Callback',@currDPHandler);
    set(handles.globalSave,'Callback',@saveFigure);
    hold(handles.axes1,'all');
    handles.heatCtxMenu = uicontextmenu(handles.stafig);
    topmenu = uimenu('Parent',handles.heatCtxMenu,'Label','Save image','Callback',@saveImage);
    %set(handles.heatmap,'ButtonDownFcn',@buttonDownHandler);
    handles.position = -1; % in datapoints
    colormap(handles.heatmap,'jet');
    
    
    
    
    % read data
    handles.data = [];
    handles.unit = -1;
    handles.crossCorrUnit = -1;
    handles.binSize = 20;
    handles.numOfBins = 30;
    handles.dirpath = dirpath;
    suffix = '.ev2.mat';
    ids = cell(length(dataList),2);
    regex = '.*([^0-9]|^)(?<id>[0-9]+)\.ev2\.mat$';
    for i=1:length(ids)
        ids{i,1} = dataList(i).name;
        m = regexp(ids{i,1},regex,'names');
        if isempty(m)
            error('.mat file is of invalid form');
        end
        ids{i,2} = str2double(m.id);
    end
    ids = sortrows(ids,2);
    handles.unitNames = cell(1,length(dataList));
    for i = 1:length(ids)
       data = load([dirpath ids{i,1}]);
       handles.unitNames{i} = ids{i,1};
       handles.data = cat(3,handles.data,data.meanSpikeWaveformDetrended);
    end
    handles.dropDown = findobj(stafig,'Tag','unitselector');
    set(handles.dropDown,'String',handles.unitNames);
    set(handles.dropDown,'Callback',@dropdownHandler);
    set(handles.corrSelector,'String',handles.unitNames);
    set(handles.corrSelector,'Callback',@corrSelectorHandler);
    set(handles.autocorrChange,'Callback',@autocorrChangeHandler);
    guidata(stafig,handles);
    set(handles.dropDown,'Value',1);
    set(handles.totalDP,'String',['/ ',num2str(size(handles.data,2))]);
    plotSTA(stafig,1);
end

function closeHandler(hObject,~,~)
    handles = guidata(hObject);
    rawfig = handles.rawfig;
    rawHandles = guidata(rawfig);
    rawHandles.stafig = gobjects;
    set(rawHandles.traceview,'Enable','on');
    guidata(rawfig,rawHandles);
    delete(hObject);
    rawHandles = guidata(rawfig);
    rawHandles.datafile = updateSpikes(rawHandles.datafile);
    guidata(rawfig,rawHandles);
end

function dropdownHandler(hObject,~,~)
    handles = guidata(hObject);
    plotSTA(handles.stafig,get(hObject,'Value'));
end

function scrollHandler(hObject,eventdata,~)
    handles = guidata(hObject);
    C = get (handles.axes1, 'CurrentPoint');
    XLim = get(handles.axes1, 'XLim');
    YLim = get(handles.axes1, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        wfScrollHandler(hObject,eventdata.VerticalScrollCount);
        return;
    end
    
    C = get (handles.heatmap, 'CurrentPoint');
    XLim = get(handles.heatmap, 'XLim');
    YLim = get(handles.heatmap, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2) && isfield(handles.heatmap,'ScrollFcn')
        handles.heatmap.ScrollFcn(hObject,eventdata.VerticalScrollCount);
        return;
    end
end

function buttonDownHandler(hObject,eventdata,~)
    fprintf('Waveform clicked\n');
end

function stafigButtonDownHandler(hObject,eventdata,~)
    % expects left mouse click but will work with right click as well
    handles = guidata(hObject);
    C = get (handles.axes1, 'CurrentPoint');
    XLim = get(handles.axes1, 'XLim');
    YLim = get(handles.axes1, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        % clicked inside axes1
        pos = rem(C(1,1),size(handles.data,2)-1);
        pos = floor(pos);
        plotHeatmap(handles.stafig,pos);
    end
end

function stafigMouseMoveHandler(hObject,eventdata,~)
end
