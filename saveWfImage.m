function saveWfImage(hObject,~,~)
%SAVEWFIMAGE Summary of this function goes here
%   Detailed explanation goes here
    [file,path] = uiputfile({'*.emf'},'Save as');
    if ~file
        return;
    end
    
    f = plotWfAsFigOnSingleAxes(hObject);
    %f = plotWfAsFig(hObject);
    saveas(f,[path,file]);
    close(f);

end

