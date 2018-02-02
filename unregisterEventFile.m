function unregisterEventFile( rawfig,filepath,withoutupdatespikes )
%UNREGISTEREVENTFILE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(rawfig);
    if ~handles.datafile.eventFiles.isKey(filepath)
        error('Cannot unregister non-registered event file');
        return;
    end
    
    if ~isMO(handles.datafile.eventFiles(filepath).Spikes)
        error('Cannot unregister materialized event file (i.e. not added through STAView)');
        return;
    end
    fprintf('Unregistering %s\n',filepath);
    handles.datafile.eventFiles.remove(filepath);
	
	guidata(rawfig,handles);
	
	if strcmp(filepath,handles.datafile.activeEventFile)
        setActiveEventFile(rawfig,-1,withoutupdatespikes);
	end    

end

