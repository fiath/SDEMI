function createVideo( obj,~,~ )
%CREATEVIDEO Summary of this function goes here
%   Detailed explanation goes here
	vid = VideoWriter('test.avi', 'Uncompressed AVI');

	adaptiveRange = true;
	adaptiveFrameRate = true;
	maxDeltaPerFrame = 0.01;
	
	handles = guidata(obj);
	data = handles.data(:,:,handles.unit);
	range = handles.heatmapRange;
	map = jet;
	c = handles.column;
	r = ceil(size(data,1)/c);
	if size(data(:,1)) < c*r
		% add nan cells
		data = [data;nan(c*r-size(data,1),size(data,2))];
	end
	pixelSize = 10;
	
	open(vid);
	
	relData = [];
	for i=1:size(data,2)
		if adaptiveRange
			range = [min(data(:,i)),max(data(:,i))];
		end
		frame = (data(:,i)-range(1))/(range(2)-range(1));
		if adaptiveFrameRate && ~isempty(relData)
			difference = frame - relData(:,end);
			delta = max(abs(difference));	
			times = ceil(delta/maxDeltaPerFrame);
			for j=1:times
				relData = [relData,(relData(:,end) + difference/times)];
			end
		elseif adaptiveFrameRate
			relData = frame;
		end
	end
	
	fprintf('Writing %d frames to video\n',size(relData,2));
	
	
	for i=1:size(relData,2)
		im = reshape(relData(:,i),[c,r])';
		indices = ceil(size(map,1)*im);
		indices(indices < 1) = 1;
		indices(indices > size(map,1)) = size(map,1);
		im = zeros(size(indices,1)*pixelSize,size(indices,2)*pixelSize,3);
		for j=1:size(indices,1)
			for k=1:size(indices,2)
				if isnan(indices(j,k))
					m=zeros(pixelSize,pixelSize,3);
				else
					m = repmat(reshape(map(indices(j,k),:),[1,1,3]),pixelSize);
				end
				im((j-1)*pixelSize+1:(j*pixelSize),(k-1)*pixelSize+1:(k*pixelSize),:) = m;
			end
		end
		writeVideo(vid,im);
	end
	close(vid);
end

