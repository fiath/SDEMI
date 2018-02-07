function openSpikeModal(rawfig,~,~)
    rawHandles = guidata(rawfig);
    if isgraphics(rawHandles.spikemodal)
        close(rawHandles.spikemodal);
    end
    
    eventFiles = rawHandles.datafile.eventFiles.keys;

    modal = matlab.hg.internal.openfigLegacy('spikemodal', 'reuse', 'visible');
    
    % populate drop-down menu
    
    handles = struct(...
                'rawfig',rawfig,...
                'activedd', findobj(modal,'Tag','activedd'),...
                'list',findobj(modal,'Tag','staticpanel'),...
                'save',findobj(modal,'Tag','save'),...
                'cancel',findobj(modal,'Tag','cancel'));
    handles.eventFiles = containers.Map;
    handles.rawEventFilePaths = eventFiles;
    for i=1:length(eventFiles)
        handles.eventFiles(eventFiles{i}) = rawHandles.datafile.eventFiles(eventFiles{i});
    end
            
    set(handles.cancel,'Callback',@(obj,~,~)delete(modal));
    set(handles.save,'Callback',{@saveHandler,modal});
    
    set(modal,'WindowScrollWheelFcn', {@scrollfunc});
    set(modal,'WindowButtonMotionFcn', {@movefunc});
            
    tEventFiles = {};
    for i=1:length(eventFiles)
        reg = regexp(eventFiles{i},['.*' filesep '(?<filename>[^' filesep ']*)$'],'names');
        tEventFiles{i} = reg.filename;
    end
    set(handles.activedd,'String',tEventFiles);
    active = rawHandles.datafile.activeEventFile;
    if active ~= -1
        index = find(strcmp(eventFiles,active));
        handles.activedd.Value = index;
        handles.activedd.String{index} = ['<HTML><FONT COLOR="#22dd22"><b>',tEventFiles{index},'</b></HTML>'];
    end
    
    for i=1:length(eventFiles)
        bottom = handles.list.Position(4)-(i-1)*20-40;
        file = handles.eventFiles(eventFiles{i});
        file.uicheckbox = uicontrol(handles.list,'Style','checkbox',...
                    'Units','pixels',...
                    'Position',[10 bottom 15 15],...
                    'Value',rawHandles.datafile.eventFiles(eventFiles{i}).Visible,...
                    'Callback',{@checkBox,eventFiles{i}});
        file.uicolor = uicontrol(handles.list,'Style','pushbutton',...
                    'Units','pixels',...
                    'Position',[30 bottom 15 15],...
                    'BackgroundColor',rawHandles.datafile.eventFiles(eventFiles{i}).Color,...
                    'Callback',{@colorPickerCallback,eventFiles{i}});
        file.uitext = uicontrol(handles.list,'Style','text',...
                    'Units','pixels',...
                    'String',tEventFiles{i},...
                    'Position',[50 bottom handles.list.Position(3)-40 15],...
                    'HorizontalAlignment','left');
        handles.eventFiles(eventFiles{i}) = file;
    end
    
    handles.listHeight = 20*(length(eventFiles)-1) + 40 + 10;
    handles.scrollPos = 0;
    handles.scrollMax = max([0,handles.listHeight-handles.list.Position(4)]);
    handles.scrollDelta = 6;
    
    guidata(modal,handles);
end

function colorPickerCallback(obj,edata,filename)
    color = uisetcolor;
	if isZ(color)
		return
	end
    obj.BackgroundColor = color;
    handles = guidata(obj);
    file = handles.eventFiles(filename);
    file.Color = color;
    handles.eventFiles(filename) = file;
    guidata(obj,handles);
end

function checkBox(obj,eData,filename)
    handles = guidata(obj);
    file = handles.eventFiles(filename);
    file.Visible = obj.Value;
    handles.eventFiles(filename) = file;
    guidata(obj,handles);
end

function saveHandler(obj,~,modal)
    handles = guidata(modal);
    activeFile = handles.rawEventFilePaths{handles.activedd.Value};
    setActiveEventFile(handles.rawfig,activeFile);
    rawHandles = guidata(handles.rawfig);
    keys = handles.eventFiles.keys;
    for i=1:length(keys)
        if rawHandles.datafile.eventFiles.isKey(keys{i})
            event = rawHandles.datafile.eventFiles(keys{i});
			if ~strcmp(keys{i},activeFile)
				% don't overwrite visibility
				event.Visible = handles.eventFiles(keys{i}).Visible;
			end
            event.Color = handles.eventFiles(keys{i}).Color;
            rawHandles.datafile.eventFiles(keys{i}) = event;
        end
    end
    rawHandles.datafile = updateSpikes(rawHandles.datafile);
    guidata(handles.rawfig,rawHandles);
    delete(modal);
end

function updateScrollPosition(obj,handles)
    keys = handles.eventFiles.keys;
    for i=1:length(keys)
        bottom = handles.list.Position(4)-(i-1)*20-40 + handles.scrollPos;
        file = handles.eventFiles(keys{i});
        file.uicheckbox.Position(2) = bottom;
        file.uicolor.Position(2) = bottom;
        file.uitext.Position(2) = bottom;
    end
end

function scrollfunc(obj,edata,~)
    pos = get(obj,'CurrentPoint');
    handles = guidata(obj);
    if pos(1) > handles.list.Position(1) && pos(1) < handles.list.Position(1)+handles.list.Position(3) ...
            && pos(2) > handles.list.Position(2) && pos(2) < handles.list.Position(2)+handles.list.Position(4)
        %fprintf('They see me scrolling they hatin''\n');
        dir = edata.VerticalScrollCount;
        if dir < 0 && handles.scrollPos > 0
            handles.scrollPos = max([handles.scrollPos-handles.scrollDelta,0]);
            guidata(obj,handles);
            updateScrollPosition(obj,handles);
        elseif dir > 0 && handles.scrollPos < handles.scrollMax
            handles.scrollPos = min([handles.scrollPos+handles.scrollDelta,handles.scrollMax]);
            guidata(obj,handles);
            updateScrollPosition(obj,handles);
        end
    end
end

function movefunc(obj,edata)
    pos = get(obj,'CurrentPoint');
    %fprintf('They see me moving they hatin'': %f %f\n',pos(1),pos(2));
end