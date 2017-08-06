function saveTraceImage(hObject,~,~)
%SAVETRACEIMAGE Summary of this function goes here
%   Detailed explanation goes here

    [file,path] = uiputfile({'*.bmp';'*.png'},'Save as');
    if ~file
        return;
    end
    
    %f = plotTraceAsFig(hObject);
    handles = guidata(hObject);
    saveas(handles.figure1,[path,file]);
    %close(f);
end

