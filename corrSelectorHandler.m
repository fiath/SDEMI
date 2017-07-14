function  corrSelectorHandles(hObject,~,~)
%CORRSELECTORHANDLES Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    handles.crossCorrUnit = get(hObject,'Value');
    guidata(handles.stafig,handles);
    
    plotCrossCorr(handles.stafig,handles.numOfBins,handles.binSize,handles.unit);

end

