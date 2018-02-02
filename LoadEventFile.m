function spikes = LoadEventFile(filepath)
    f = fopen(filepath,'r');
    if f == -1
        error(['Couldn''t find event file: ', filepath])
    end
    spikes = [];
    l = fgetl(f);
    while ischar(l)
        dp = sscanf(l,'%d %d %d %d %f %d');
        spikes = [spikes,dp(6)];
        l = fgetl(f);
    end
    fclose(f);
end