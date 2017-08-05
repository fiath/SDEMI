function saveImage(hObject,~,~)
%SAVEASBMP Summary of this function goes here
%   Detailed explanation goes here
    [file,path] = uiputfile({'*.bmp';'*.png'},'Save as');
    if ~file
        return;
    end
    handles = guidata(hObject);
    %imwrite(imcapture(handles.heatmap,'all'),[path,file]);
    im = frame2im(getframe(handles.heatmap));
    imwrite(im,[path, file]);
    
    f = plotHeatmapAsFig(hObject);
    ext_index = find(file=='.',1,'last');
    if isempty(ext_index)
        ext_index = length(file)+1;
    end
    file = [file(1:ext_index-1),'.emf'];
    saveas(f,[path,file]);
    close(f);
end

