function parallelPrefetch( ~,~,fig )
%PARALLELPREFETCH Summary of this function goes here
%   Detailed explanation goes here
	fprintf('Called timer\n');

	% DO NOT SAVE HANDLES!!!!!
	handles = guidata(fig);
	m = handles.datafile.preprocessed;
	parInputFile = m('inputFile');
	
	if isKey(m,'future') && ~strcmp(m('future').State,'finished')
		fprintf('Block not yet ready\n');
		return;
	end
	chunkSize = 100000;
	from = 1;
	to = chunkSize;
	if isKey(m,'future')
		[out,from,to] = fetchOutputs(m('future'));
		fprintf('Processed block [%d, %d]\n',from,to);
		m('downsampled') = [m('downsampled'),out];
		if to == handles.datafile.length
			fprintf('Finished processing all blocks\n');
			return;
		end
		from = to+1;
		to = min([handles.datafile.length,to+chunkSize]);
	end
	m('future') = parfeval(@readParallel,3,parInputFile,from,to,m('resolution'));
	fprintf('Started processing block [%d, %d]\n',from,to);
end

function [out,from,to] = readParallel(inputFile,from,to,res)
	inputFile = inputFile.Value;
	out = 0.195*double(downsampleData(fread(inputFile,[128, to-from+1],'int16'),res));
end

function out = downsampleData(data,res)
%DOWNSAMPLEBUFFER Summary of this function goes here
%   Detailed explanation goes here
	bufferSize = size(data,2);
    out = zeros(size(data,1),2*ceil(bufferSize/res));
    for i=1:size(out,2)/2-1
        out(:,(i*2-1)) = min(data(:,(((i-1)*res)+1):(i*res)),[],2);
        out(:,(i*2)) = max(data(:,(((i-1)*res)+1):(i*res)),[],2);
    end
    i = size(out,2)/2;
    out(:,(i*2-1)) = min(data(:,(((i-1)*res)+1):end),[],2);
    out(:,(i*2)) = max(data(:,(((i-1)*res)+1):end),[],2);

end

	

