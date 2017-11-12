function ldr = loadLDR(ldr_file_name)
%LOADLDR Summary of this function goes here
%   Detailed explanation goes here
    try
        ldr_fid=fopen(ldr_file_name);

        next_line = fgetl(ldr_fid);
        if ~ischar(next_line)
            error('Invalid ldr file format');
        end

        regex = '^(?<out>[1-9][0-9]*) (?<in>[1-9][0-9]*)$';

        val = regexp(next_line,regex,'names');
        if isempty(val)
            error('Invalid ldr file format');
        end

        nofchannels_out = str2double(val.out);
        nofchannels_in = str2double(val.in);

        next_line = fgetl(ldr_fid); % empty line
        next_line = fgetl(ldr_fid); % line with input channel ids
        next_line = fgetl(ldr_fid); % empty line

        ldr = zeros(nofchannels_out, nofchannels_in);

        for iLine = 1:nofchannels_out
            next_line = fgets(ldr_fid);
            if ~ischar(next_line) % prematurely reached EOF
                error('Invalid ldr file format');
            end
            vector_temp = sscanf(next_line,'%g');
            if vector_temp(1) ~= iLine || length(vector_temp) ~= nofchannels_in + 1
                error('Invalid ldr file format');
            end
            ldr(iLine,:) = vector_temp(2:end)';
        end
    catch ex
        if ldr_fid ~= -1
            fclose(ldr_fid);
        end
        throw(ex);
    end

end

