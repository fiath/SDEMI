function spikes = getSpikes( stafig,filepath )
%GETSPIKES Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(stafig);
    if isKey(handles.eventFiles,filepath)
        % event file has already been loaded
        spikes = handles.eventFiles(filepath);
    else
        error('Spikes should have been read from the .mat file in @loadSTA');
        f = fopen(filepath,'r');
        spikes = [];
        l = fgetl(f);
        while ischar(l)
            dp = sscanf(l,'%d %d %d %d %f %d');
            spikes = [spikes,dp(6)];
            l = fgetl(f);
        end
        fclose(f);
        handles.eventFiles(filepath) = spikes;
    end
    guidata(stafig,handles);

end

