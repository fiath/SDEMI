function GenerateDownSampled(res)
%TESTDOWNSAMPLING Summary of this function goes here
%   Detailed explanation goes here
    tic;
    [filename,path] = uigetfile('*.dat','Select .dat file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/dat/');
    if filename == 0
        return;
    end
    
    filepath = [path filename];
    file = dir(filepath);
    
    file_length = file.bytes/128/2;
    file = memmapfile(filepath, 'Format',{'int16', [128 file_length], 'x'});
    if nargin<1
        res = 100;
    end
    chunkSize = 100000;
    if mod(chunkSize,res)
        error('chunkSize must be a multiple of res');
    end
    buffer = zeros(128, 2*ceil(file_length/res));
    prev_chunkEnd = 0;
    for i=1:ceil(file_length/chunkSize)
        from_index = (i-1)*chunkSize + 1;
        to_index = min([i*chunkSize,file_length]);
        chunk = downSampleBuffer([],file.Data.x(:,from_index:to_index),res);
        buffer(:,(prev_chunkEnd+1):(prev_chunkEnd+size(chunk,2))) = chunk;
        prev_chunkEnd = prev_chunkEnd + size(chunk,2);
    end
    toc
    data = buffer;
    resolution = res;
    extIndex = find(filename == '.',1,'last');
    if isempty(extIndex)
        downFileName = [filename,'_downsampled.mat'];
    else
        downFileName = [filename(1:extIndex-1),'_downsampled.mat'];
    end
    save([path downFileName],'data','resolution');
end

