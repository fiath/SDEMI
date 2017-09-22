function clusterViewResizeHandler(fig,~,~)
%CLUSTERVIEWRESIZEHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    function setNewPos(objName)
        nPos = handles.([objName 'NormPos']);
        handles.(objName).Position(1) = nPos(1)*fig.Position(3);
        handles.(objName).Position(2) = nPos(2)*fig.Position(4);
    end
    setNewPos('dropDown');
    setNewPos('activeSpikeText');
    setNewPos('spikeStateDropDown');
    
    handles.stateLabel.Position(1) = handles.spikeStateDropDown.Position(1) - handles.stateLabel.Position(3) - 5;
    handles.stateLabel.Position(2) = handles.spikeStateDropDown.Position(2) + handles.spikeStateDropDown.Position(4)/2 - ...
            handles.stateLabel.Position(4)/2;
    
    handles.allSpikeText.Position(1) = handles.activeSpikeText.Position(1) + handles.activeSpikeText.Position(3) + 5;
    handles.allSpikeText.Position(2) = handles.activeSpikeText.Position(2) + handles.activeSpikeText.Position(4)/2 - ...
            handles.allSpikeText.Position(4)/2;
end

