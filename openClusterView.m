function openClusterView(rawfig)
%OPENCLUSTERVIEW Summary of this function goes here
%   Detailed explanation goes here
    rawHandles = guidata(rawfig);
    if isgraphics(rawHandles.clfig)
        close(rawHandles.clfig);
    end
    
    startdir = rawHandles.datafile.filedir(1:end-1);
    startdir = startdir(1:find(startdir=='/',1,'last')-1);
    dirpath = uigetdir(startdir,'Select the directory containing the .ev2 files or .ev2.mat files');
    if dirpath == 0
        return;
    end
    
    dirpath = [dirpath '/'];
    dataList = dir([dirpath '*.ev2']);
    if isempty(dataList)
        % directory contains no .ev2 files.
        dataList = dir([dirpath '*.mat']);
        if isempty(dataList)
            % directory contains no .mat files either.
            return
        end
        usingMatFiles = true;
    else
        usingMatFiles = false;
    end
    %dataList = dataList(1:3); % for live comment out

    clFig = matlab.hg.internal.openfigLegacy('clusterview', 'reuse', 'visible');
    rawHandles.clfig = clFig;
    set(rawHandles.traceview,'Enable','off');
    
    handles = struct('clfig',clFig,'rawfig',rawfig);
    handles.range = [-80 80];
%     handles.channelConf = gobjects(32,4);
    groups = {'group1','group2'};
    handles.groups = groups;
    handles.modifiers = struct('ctrl',0);
    handles.dropDown = findobj(clFig,'Tag','dropdown');
    handles.activeSpikeText = findobj(clFig,'Tag','activespike');
    handles.allSpikeText = findobj(clFig,'Tag','allspikes');
    handles.stateLabel = findobj(clFig,'Tag','statelabel');
    handles.spikeStateDropDown = findobj(clFig,'Tag','editspike');
    handles.showReassignedMenuItem = findobj(clFig,'Tag','showreassigned');
    
    function norm = getNormPos(obj)
        norm = [obj.Position(1)/clFig.Position(3),obj.Position(2)/clFig.Position(4)];
    end
    
    handles.dropDownNormPos = getNormPos(handles.dropDown);
    handles.activeSpikeTextNormPos = getNormPos(handles.activeSpikeText);
    handles.allSpikeTextNormPos = getNormPos(handles.allSpikeText);
    handles.stateLabelNormPos = getNormPos(handles.stateLabel);
    handles.spikeStateDropDownNormPos = getNormPos(handles.spikeStateDropDown);
    
    offset = 0;
    for i=1:length(groups)
        handles.(groups{i}) = struct();
        handles.(groups{i}).offset = offset; % channels before this group
        handles.(groups{i}).conf = [4 16];
        handles.(groups{i}).positionLines = gobjects(handles.(groups{i}).conf(1),1);
        handles.(groups{i}).lines = gobjects(handles.(groups{i}).conf);
        offset = offset + handles.(groups{i}).conf(1)*handles.(groups{i}).conf(2);
        handles.(groups{i}).axes = findobj(clFig,'Tag',['axes',num2str((i-1)*2+1)]);
        handles.(groups{i}).heatmap = findobj(clFig,'Tag',['axes',num2str((i-1)*2+2)]);
        for j=1:length(handles.(groups{i}).positionLines)
            handles.(groups{i}).positionLines(j) = line(handles.(groups{i}).axes,[0 0],[0 0]);
        end
        for j=1:size(handles.(groups{i}).lines,1)
            for k=1:size(handles.(groups{i}).lines,2)
                handles.(groups{i}).lines(j,k) = line(handles.(groups{i}).axes,[0 0],[0 0],'Color','red','LineWidth',1);
            end
        end
%         handles.(groups{i}).axesWidth = handles.(groups{i}).axes.Position(3); % normalized
        handles.(groups{i}).image = imagesc(handles.(groups{i}).heatmap,[]);
        handles.(groups{i}).colorbarWidth = 30; % pixel
        handles.(groups{i}).colorbarMargin = 10; % pixel
        handles.(groups{i}).colorbar = colorbar(handles.(groups{i}).heatmap);
%         handles.(groups{i}).colorbar = colorbar(handles.(groups{i}).heatmap,'Location','manual','Units','pixels');
%         handles.(groups{i}).colorbar.Position(3) = handles.(groups{i}).colorbarWidth;
        handles.(groups{i}).colorbar.UIContextMenu = '';
%         handles.(groups{i}).rangeButton = findobj(clFig,'Tag',[groups{i},'rangebutton']);
%         handles.(groups{i}).minText = findobj(clFig,'Tag',[groups{i},'min']);
%         handles.(groups{i}).maxText = findobj(clFig,'Tag',[groups{i},'max']);
%         handles.(groups{i}).range = [];
        
%         set(handles.(groups{i}).rangeButton,'Callback',@(hObject,~,~) hmViewManualRangeHandler(hObject,groups{i}));
%         set(handles.(groups{i}).minText,'Callback',@(hObject,~,~) hmViewMinHandler(hObject,groups{i}));
%         set(handles.(groups{i}).maxText,'Callback',@(hObject,~,~) hmViewMaxHandler(hObject,groups{i}));
    end
    
%     set(handles.csd.rangeButton,'Enable','off');

    % load EVENT FILES 
    handles.dirpath = dirpath;
    ids = cell(length(dataList),2);
    if ~usingMatFiles
        regex = '.*([^0-9]|^)(?<id>[0-9]+)\.ev2$';
        for i=1:length(ids)
            ids{i,1} = dataList(i).name;
            m = regexp(ids{i,1},regex,'names');
            if isempty(m)
                error('.ev2 file is of invalid form');
            end
            ids{i,2} = str2double(m.id);
        end
    else
        regex = '.*([^0-9]|^)(?<id>[0-9]+)\.ev2\.mat$';
        for i=1:length(ids)
            ids{i,1} = dataList(i).name;
            m = regexp(ids{i,1},regex,'names');
            if isempty(m)
                error('.mat file is of invalid form');
            end
            ids{i,2} = str2double(m.id);
        end
    end
    ids = sortrows(ids,2);
    handles.unitNames = cell(1,length(dataList));
    handles.eventFiles = containers.Map;
    if ~usingMatFiles
        for i=1:length(ids)
            handles.unitNames{i} = ids{i,1};
            filepath = [handles.dirpath, handles.unitNames{i}];
            f = fopen(filepath,'r');
            spikes = [];
            l = fgetl(f);
            while ischar(l)
                dp = sscanf(l,'%d %d %d %d %f %d');
                spikes = [spikes,dp(6)];
                l = fgetl(f);
            end
            fclose(f);
            handles.eventFiles(handles.unitNames{i}) = ...
                struct( 'spikes',spikes,...
                        'activeSpike',1,...
                        'activePosition',80,...
                        'assignedTo',struct('spikeIds',[],'src',[]),...
                        'assignedFrom',struct('spikeIds',[],'dst',[]));
        end
    else
        for i=1:length(ids)
            handles.unitNames{i} = ids{i,1};
            filepath = [handles.dirpath, handles.unitNames{i}];
            data = load(filepath);
            spikes = data.spikes;
            handles.eventFiles(handles.unitNames{i}) = ...
                struct( 'spikes',spikes,...
                        'activeSpike',1,...
                        'activePosition',80,...
                        'assignedTo',struct('spikeIds',[],'src',[]),...
                        'assignedFrom',struct('spikeIds',[],'dst',[]));
        end
    end
    handles.activeUnit = 1;
    
    
    % add callbacks
    set(clFig,'CloseRequestFcn',@closeHandler);
    set(clFig,'ResizeFcn',@clusterViewResizeHandler);
    set(handles.dropDown,'String',handles.unitNames);
    set(handles.dropDown,'Callback',@clusterDropDownHandler);
    set(handles.showReassignedMenuItem,'Callback',@toggleShowReassigned);
    set(handles.spikeStateDropDown,'Callback',@spikeStateDropDownHandler);
    set(handles.activeSpikeText,'Callback',@clActiveSpikeChangeHandler);
    set(clFig,'WindowKeyPressFcn',@clKeyDownHandler);
    set(clFig,'WindowKeyReleaseFcn',@clKeyUpHandler);
    set(handles.dropDown,'Value',1);
    
    guidata(clFig,handles);
    
    guidata(rawfig,rawHandles);
    
    set(rawHandles.traceview,'Enable','on');
    
%     refreshDataView(rawfig);
    changeActiveUnit(clFig,1);

end

function closeHandler(hObject,~,~)
    handles = guidata(hObject);
    rawfig = handles.rawfig;
    rawHandles = guidata(rawfig);
    rawHandles.clfig = gobjects;
    set(rawHandles.traceview,'Enable','on');
    guidata(rawfig,rawHandles);
    delete(hObject);
end

function clKeyDownHandler(hObject,eventdata,~)
%STAKEYDOWNHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    if any(strcmp(eventdata.Modifier,'control')) && ~handles.modifiers.ctrl
        fprintf('Ctrl down\n');
        handles.modifiers.ctrl = 1;
    end
    guidata(hObject,handles);
    unit = handles.eventFiles(handles.unitNames{handles.activeUnit});
    if strcmp(eventdata.Key,'uparrow') == 1 && handles.activeUnit > 1
        % select the previous unit
        changeActiveUnit(handles.clfig,handles.activeUnit-1);
    elseif strcmp(eventdata.Key,'downarrow') == 1 && handles.activeUnit < size(handles.eventFiles,1)
        % select the next unit
        changeActiveUnit(handles.clfig,handles.activeUnit+1);
    end
    if ~handles.modifiers.ctrl
        if strcmp(eventdata.Key,'leftarrow') == 1 && unit.activeSpike > 1
            % select the previous unit
            changeToNextSpike(handles.clfig,'backward');
        elseif strcmp(eventdata.Key,'rightarrow') == 1 && unit.activeSpike < length(unit.spikes)
            % select the next unit
            changeToNextSpike(handles.clfig,'forward');
        end
    else
        if strcmp(eventdata.Key,'leftarrow') == 1 && unit.activePosition > 1
            % select the previous unit
            changeActivePosition(handles.clfig,unit.activePosition-1);
        elseif strcmp(eventdata.Key,'rightarrow') == 1 && unit.activePosition < handles.range(2)-handles.range(1)+1
            % select the next unit
            changeActivePosition(handles.clfig,unit.activePosition+1);
        end
    end
end

function clKeyUpHandler(hObject, eventdata, ~)
    handles = guidata(hObject);
    if ~any(strcmp(eventdata.Modifier,'ctrl')) && handles.modifiers.ctrl
        fprintf('Ctrl up\n');
        handles.modifiers.ctrl = 0;
    end
    guidata(hObject,handles);
end

