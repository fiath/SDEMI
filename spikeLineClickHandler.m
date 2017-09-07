function spikeLineClickHandler(line,pos)
%SPIKELINECLICKHANDLER Summary of this function goes here
%   Detailed explanation goes here
    fprintf('Clickhandler called on Spike Line %d\n',pos);
    handles = guidata(line);
    setCurrentSpike(handles.figure1,pos);

end

