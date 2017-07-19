function newBuffer = downSampleBuffer(datafile,buffer)
%DOWNSAMPLEBUFFER Summary of this function goes here
%   Detailed explanation goes here
    bufferSize = size(buffer,2);
    dataPerPixel = datafile.dataResolution;
    newBuffer = zeros(datafile.numberOfChannels,2*ceil(bufferSize/dataPerPixel));
    for i=1:size(newBuffer,2)/2-1
        newBuffer(:,(i*2-1)) = min(buffer(:,(((i-1)*dataPerPixel)+1):(i*dataPerPixel)),[],2);
        newBuffer(:,(i*2)) = max(buffer(:,(((i-1)*dataPerPixel)+1):(i*dataPerPixel)),[],2);
    end
    i = size(newBuffer,2)/2;
    newBuffer(:,(i*2-1)) = min(buffer(:,(((i-1)*dataPerPixel)+1):end),[],2);
    newBuffer(:,(i*2)) = max(buffer(:,(((i-1)*dataPerPixel)+1):end),[],2);

end
