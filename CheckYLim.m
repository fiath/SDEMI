function ylim = CheckYLim(ylim,datafile)
%CHECKYLIM Summary of this function goes here
%   Detailed explanation goes here
    numOfActiveChannels = 0;
    for i=1:datafile.numberOfChannels
        if datafile.activeChannels(i)
           numOfActiveChannels = numOfActiveChannels + 1; 
        end
    end
    if numOfActiveChannels == 0
        numOfActiveChannels = 1;
    end
    ymin = datafile.maxYLimDiff(1) + datafile.channelSpacing;
    ymax = datafile.maxYLimDiff(2) + (numOfActiveChannels)*datafile.channelSpacing;
    if ylim(1) < ymin
        ylim = ylim + (ymin - ylim(1));
    end
    if ylim(2) > ymax
        ylim = ylim - (ylim(2)-ymax);
    end
    % crop
    if ylim(1) < ymin
        ylim(1) = ymin;
    end
    if ylim(2) > ymax
        ylim(2) = ymax;
    end
end

