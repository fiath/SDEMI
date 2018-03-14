function avail = isRegionAvailableAt(datafile,beginBuffer,endBuffer,dataPerPixel)
	if datafile.preprocessed('resolution') > dataPerPixel
		avail = false;
		return;
	end
	ds = datafile.preprocessed('downsampled');
	last = ceil(endBuffer/datafile.preprocessed('resolution')*2);
	first = ceil(beginBuffer/datafile.preprocessed('resolution')*2);
	
	if last <= size(ds,2) && first >= 1 && first <= last
		avail = true;
	else
		avail= false;
	end
end