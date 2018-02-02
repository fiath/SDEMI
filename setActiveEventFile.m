function handles = setActiveEventFile( rawfig,filepath,withoutupdatespikes ,handles)
%SETACTIVEEVENTFILE Summary of this function goes here
%   Detailed explanation goes here
	if nargin <= 3 
		handles = guidata(rawfig);
	end
	
	if ~isMO(filepath)
	
		if ~handles.datafile.eventFiles.isKey(filepath)
			error('Cannot set missing/unregistered eventfile as active')
			return;
		end
		fprintf('Setting active event file: %s\n',filepath);

		handles.datafile.activeEventFile = filepath;
		handles.datafile.allSpikeCount = length(getSpikes(handles.stafig,filepath,handles.datafile));
		handles.datafile.currentSpike = handles.datafile.eventFiles(filepath).Position;
		
	else
		handles.datafile = unsetAEF(handles.datafile);
	end
	if nargin <= 3 || withoutupdatespikes
		handles.datafile = updateSpikes(handles.datafile);
	end
	if nargin <= 3
		guidata(rawfig,handles);
	end
    updateSpikeSelector(handles);

end

function datafile = unsetAEF(datafile)
	fprintf('Removing active event file\n');
	datafile.activeEventFile = -1;
	datafile.allSpikeCount = -1;
	datafile.currentSpike = -1;
end

