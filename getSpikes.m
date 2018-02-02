function spikes = getSpikes( stafig,filepath,datafile )
%GETSPIKES Summary of this function goes here
%   Detailed explanation goes here
    if nargin >= 3
        if ~datafile.eventFiles.isKey(filepath)
            error('Cannot get spikes which were not previously registered with rawfig');
            return;
        end
        spikeStruct = datafile.eventFiles(filepath);
        if ~isMO(spikeStruct.Spikes)
            spikes = spikeStruct.Spikes;
            return;
        end
    end
    handles = guidata(stafig);
    if isKey(handles.eventFiles,filepath)
        % event file has already been loaded
        spikes = handles.eventFiles(filepath);
    else
        spikes = LoadEventFile(filepath);
        handles.eventFiles(filepath) = spikes;
    end
    guidata(stafig,handles);

end


