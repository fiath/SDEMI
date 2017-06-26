function saveImage(hObject,~,~)
%SAVEASBMP Summary of this function goes here
%   Detailed explanation goes here
    [file,path] = uiputfile({'*.bmp','*.png'},'Save as');
    if ~file
        return;
    end
    handles = guidata(hObject);
    %imwrite(imcapture(handles.heatmap,'all'),[path,file]);
    im = frame2im(getframe(handles.heatmap));
    imwrite(im,[path, file]);
end

