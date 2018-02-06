function saveTraceImage(hObject,~,~)
%SAVETRACEIMAGE Summary of this function goes here
%   Detailed explanation goes here

    [file,path] = uiputfile({'*.emf';'*.bmp';'*.png';'*.jpeg';...
		'*.pdf';'*.eps';'*.svg'},'Save as');
	if ~file
        return;
	end
    
	handles = guidata(hObject);
    f = plotTraceAsFig(handles);
    saveas(f,[path,file]);
    close(f);
end

