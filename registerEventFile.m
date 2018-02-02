function registerEventFile( rawfig,filepath )
%PUBLISHEVENTFILE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(rawfig);
    if handles.datafile.eventFiles.isKey(filepath)
        error('Cannot register an event file more than once');
        return;
    end
    fprintf('Registering %s\n',filepath);
    handles.datafile.eventFiles(filepath) = struct(...
        'Spikes',-1,...
        'Position',1,...
        'Visible',0,...
        'Color',[0,0,1],...
        'Above',0);
    guidata(rawfig,handles);
end

