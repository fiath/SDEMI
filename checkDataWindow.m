function [datafile,window,switched] = checkDataWindow(datafile,window,dontSwitch)
    if nargin < 3
        dontSwitch = 0;
    end
    size = min([datafile.length,datafile.maxWindowSize,window(2) - window(1)+1]);
    if size < 0
        error('newDataWindow.size cannot be negative');
    end
    center = floor((window(1) + window(2))/2);
    window(1) = center - ceil(size/2)+1;
    window(2) = window(1) + size-1;
    if window(1) < 0
        window(1) = 0;
        window(2) = size-1;
    end
    if window(2) >= datafile.length
        window(2) = datafile.length-1;
        window(1) = window(2) - size+1;
    end
    
    switched = 0;
    if ~dontSwitch && ~isempty(datafile.downsampled) && ~datafile.filter.on
        figPos = get(datafile.fig,'Position');
        axPos = get(datafile.ax,'Position');
        xSize = axPos(3)*figPos(3); % size of axes in pixels
        dataPerPixel = floor((window(2)-window(1)+1)/xSize);
        if ~datafile.usingDownsampled && dataPerPixel > datafile.downsampled.resolution
            [datafile,window] = switchToDownSampled(datafile,window);
            switched = 1;
        elseif datafile.usingDownsampled && dataPerPixel < 2
            [datafile,window] = switchToUnSampled(datafile,window);
            switched = 1;
        end
    end
end

