function transformData(fig)
%TRANSFORMDATA Summary of this function goes here
%   Detailed explanation goes here
    transfig = matlab.hg.internal.openfigLegacy('transform', 'reuse', 'visible');
    handles = struct('datfilepath','','eventdirpath','','outdirpath','','processing',0,'stopExecution',0);
    handles.transfig = transfig;
    handles.progressBar = findobj(transfig,'Tag','progressBar');
    handles.progressPerc = findobj(transfig,'Tag','progressPerc');
    handles.runButton = findobj(transfig,'Tag','runbutton');
    handles.datfilepathTxt = findobj(transfig,'Tag','datfilepath');
    handles.eventdirpathTxt = findobj(transfig,'Tag','eventdirpath');
    handles.outdirpathTxt = findobj(transfig,'Tag','outdirpath');
    handles.datfileSelector = findobj(transfig,'Tag','datfileselector');
    handles.eventdirSelector = findobj(transfig,'Tag','eventdirselector');
    handles.outdirSelector = findobj(transfig,'Tag','outdirselector');
    
    set(handles.runButton,'Callback',@runButtonClickHandler);
    set(handles.datfileSelector,'Callback',@datfileSelectorClickHandler);
    set(handles.eventdirSelector,'Callback',@eventdirSelectorClickHandler);
    set(handles.outdirSelector,'Callback',@outdirSelectorClickHandler);
    
    % set up progressbar state
    bg_color = 'w';
    fg_color = 'g';
    set(handles.progressBar,{'XLim','YLim','XTick','YTick','Color','XColor','YColor'},...
        {[0 1],[0 1],[],[],bg_color,bg_color,bg_color});
    patch([0 0 0 0],[0 1 1 0],fg_color,...
        'Parent',handles.progressBar,...
        'EdgeColor','none',...
        'EraseMode','none');
    
    guidata(transfig,handles);
end

function datfileSelectorClickHandler(hObject,~,~)
    [filename,path] = uigetfile('*.dat','Select .dat file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/dat/');
    if filename == 0
        return;
    end
    
    handles = guidata(hObject);
    handles.datfilepath = [path,filename];
    set(handles.datfilepathTxt,'String',handles.datfilepath);
    guidata(hObject,handles);
end

function eventdirSelectorClickHandler(hObject,~,~)
    handles = guidata(hObject);
    if ~strcmp(handles.outdirpath,'')
        startdir = handles.outdirpath;
    elseif ~strcmp(handles.datfilepath,'')
        startdir = handles.datfilepath;
    else
        startdir = '/';
    end
    dirpath = uigetdir(startdir,'Select the directory containing the .ev2 files');
    if dirpath == 0
        return;
    end
   
    handles.eventdirpath = dirpath;
    set(handles.eventdirpathTxt,'String',handles.eventdirpath);
    
    if strcmp(handles.outdirpath,'')
        handles.outdirpath = dirpath;
        set(handles.outdirpathTxt,'String',handles.outdirpath);
    end
        
    guidata(hObject,handles);
        
end

function outdirSelectorClickHandler(hObject,~,~)
    handles = guidata(hObject);
    if ~strcmp(handles.eventdirpath,'')
        startdir = handles.eventdirpath;
    elseif ~strcmp(handles.datfilepath,'')
        startdir = handles.datfilepath;
    else
        startdir = '/';
    end
    dirpath = uigetdir(startdir,'Select the directory where the .mat files to be placed');
    if dirpath == 0
        return;
    end
    
    handles.outdirpath = dirpath;
    set(handles.outdirpathTxt,'String',handles.outdirpath);
    guidata(hObject,handles);
end


