function GenerateDownSampled(res,filepath,outfilepath,updateProgress)
%TESTDOWNSAMPLING Summary of this function goes here
%   Detailed explanation goes here
    file = dir(filepath);
    
    file_length = file.bytes/128/2;
    file = memmapfile(filepath, 'Format',{'int16', [128 file_length], 'x'});

    chunkSize = 100000;
    if mod(chunkSize,res)
        error('chunkSize must be a multiple of res');
    end
    buffer = zeros(128, 2*ceil(file_length/res));
    prev_chunkEnd = 0;
    currMill = 0;
    processedChunks = 0;
    numOfAllChunks = ceil(file_length/chunkSize);
    for i=1:numOfAllChunks
        from_index = (i-1)*chunkSize + 1;
        to_index = min([i*chunkSize,file_length]);
        chunk = downSampleBuffer([],file.Data.x(:,from_index:to_index),res);
        buffer(:,(prev_chunkEnd+1):(prev_chunkEnd+size(chunk,2))) = chunk;
        prev_chunkEnd = prev_chunkEnd + size(chunk,2);
        
        processedChunks = processedChunks + 1;
        if processedChunks*1000 >= (currMill + 1)*numOfAllChunks
            currMill = floor(processedChunks*1000/numOfAllChunks);
            updateProgress(currMill,sprintf('Processing data: %0.1f %%',currMill/10));
        end
    end
    
    data = buffer;
    resolution = res;

    save(outfilepath,'data','resolution');
end

