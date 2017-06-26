function saveFigure(hObject,~,~)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    formats = {'*.fig';'*.m';'*.jpg';'*.png';'*.eps';'*.pdf';...
        '*.bmp';'*.emf';'*.pbm';'*.pcx';'*.pgm';'*.ppm';'*.tif'};
    [file,path,formatIndex] = uiputfile(formats,'Save as');
    if ~file
        return;
    end
    handles = guidata(hObject);
    format = formats{formatIndex};
    saveas(handles.stafig,[path,file]);
end

