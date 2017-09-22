function changeToNextSpike(fig,dir)
%CHANGETONEXTSPIKE Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    nextSpike = 0;
    showReassigned = strcmp(get(handles.showReassignedMenuItem,'Checked'),'on');
    unit = handles.eventFiles(handles.unitNames{handles.activeUnit});
    if strcmp(dir,'forward')
        for i=unit.activeSpike+1:length(unit.spikes)
            if showReassigned || ~ismember(i,unit.assignedFrom.spikeIds)
                nextSpike = i;
                break;
            end
        end
    elseif strcmp(dir,'backward')
        for i=unit.activeSpike-1:-1:1
            if showReassigned || ~ismember(i,unit.assignedFrom.spikeIds)
                nextSpike = i;
                break;
            end
        end
    end
    if nextSpike == 0
        return;
    end
    changeActiveSpike(fig,nextSpike);

end

