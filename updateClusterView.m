function updateClusterView(clfig)
%UPDATECLUSTERVIEW Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(clfig);
    plotClusterView(clfig,handles.activeUnit,...
        handles.eventFiles(handles.unitNames{handles.activeUnit}).activeSpike,...
        handles.eventFiles(handles.unitNames{handles.activeUnit}).activePosition);
    
    handles = guidata(clfig);
    state = handles.spikeStateDropDown;
    cluster = handles.activeUnit;
    unit = handles.eventFiles(handles.unitNames{handles.activeUnit});
    reassigned = unit.assignedFrom;
    for i=1:length(reassigned.spikeIds)
        if reassigned.spikeIds(i) == unit.activeSpike
            % spike has been reassigned
            cluster = reassigned.dst(i); % dst == 0 iff the spike was deleted
            break;
        end
    end
    dp = horzcat({'<HTML><FONT COLOR="red"><b>--none--</b></HTML>'},handles.unitNames);
    for i=1:length(dp)
        if i-1 == handles.activeUnit
            dp{i} = ['<HTML><FONT COLOR="#22dd22"><b>',dp{i},'</b></HTML>'];
        elseif i-1 == cluster
            dp{i} = ['<HTML><FONT COLOR="#ff812f"><b>',dp{i},'</b></HTML>'];
        end
    end
    
    set(state,'String',dp);
    set(state,'Value',cluster+1);

end

