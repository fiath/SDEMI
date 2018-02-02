function openEventListEditor(rawfig,~,~)
%OPENSPIKELISTEDITOR Summary of this function goes here
%
%   Detailed explanation goes here
    rawHandles = guidata(rawfig);
	if isgraphics(rawHandles.eventlisteditor)
        close(rawHandles.eventlisteditor);
	end
    
    eventFiles = rawHandles.datafile.eventFiles.keys;
    
    materEventFiles = {};
    for i=1:length(eventFiles)
        if ~isMO(rawHandles.datafile.eventFiles(eventFiles{i}).Spikes)
            materEventFiles{end+1} = eventFiles{i};
        end
    end

    modal = matlab.hg.internal.openfigLegacy('eventlisteditor', 'reuse', 'visible');
    
    % populate drop-down menu
    
    handles = struct(...
                'rawfig',rawfig,...
                'list',findobj(modal,'Tag','eventlist'),...
                'add',findobj(modal,'Tag','add'),...
                'remove',findobj(modal,'Tag','remove'),...
                'save',findobj(modal,'Tag','save'),...
                'cancel',findobj(modal,'Tag','cancel'));
            
	handles.materEventFiles = materEventFiles;		
	% populate list
	set(handles.list,'String',materEventFiles);
    set(handles.cancel,'Callback',@(obj,~,~)delete(modal));
    set(handles.save,'Callback',{@saveHandler,modal});
    
    set(handles.add,'Callback', {@addfunc});
    set(handles.remove,'Callback', {@removefunc});
	
	guidata(modal,handles);

end

function addfunc(obj,edata)
	handles = guidata(obj);
	[filename,path] = uigetfile('*.ev2','Select event file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/ev2/');
	if filename == 0
		return;
	end
	file = [path,filename];
	index = find(strcmp(handles.materEventFiles,file));
	if ~isempty(index)
		warning('Cannot add event file already added');
		return;
	end
	handles.materEventFiles{end+1} = file;
	guidata(obj,handles);
	
	set(handles.list,'String',handles.materEventFiles);
	set(handles.list,'Value',length(handles.materEventFiles));
end

function removefunc(obj,edata)
	handles = guidata(obj);
    
    index = get(handles.list,'Value');
    if isempty(index) || index == 0 || isempty(handles.list.String)
        return
    end
    handles.materEventFiles(index) = [];
    if index > length(handles.materEventFiles)
		% we removed the last one move the cursor down
        index = index - 1;
        set(handles.list,'Value',index);
    end
    
    guidata(obj,handles);
	set(handles.list,'String',handles.materEventFiles);
end

function saveHandler(obj,~,modal)

	handles = guidata(modal);
    rawHandles = guidata(handles.rawfig);
    keys = handles.materEventFiles;
	% add new ones
	for i=1:length(keys)
		if ~rawHandles.datafile.eventFiles.isKey(keys{i})
			fprintf('Adding event file: %s\n',keys{i});
            event = struct('Spikes',LoadEventFile(keys{i}),...
							'Color',[0,0,1],...
							'Visible',1,...
							'Position',1,...
							'Above',0);
			rawHandles.datafile.eventFiles(keys{i}) = event;
		end
	end
	% remove old ones
	origKeys = rawHandles.datafile.eventFiles.keys;
	for i=1:length(origKeys)
		if ~isMO(rawHandles.datafile.eventFiles(origKeys{i}).Spikes) && ...
			isempty(find(strcmp(handles.materEventFiles,origKeys{i}),1))
			% origKeys{i} has been remove
			fprintf('Removing event file: %s\n',origKeys{i});
			rawHandles.datafile.eventFiles.remove(origKeys{i});
			if strcmp(origKeys{i},rawHandles.datafile.activeEventFile)
				% we just removed the active event file, set it to -1
				rawHandles = setActiveEventFile([],-1,true,rawHandles);
			end
		end
	end
    rawHandles.datafile = updateSpikes(rawHandles.datafile);
    guidata(handles.rawfig,rawHandles);
    delete(modal);

end

