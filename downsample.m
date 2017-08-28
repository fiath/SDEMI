function downsample()
%TRANSFORMDATA Summary of this function goes here
%   Detailed explanation goes here
    downfig = matlab.hg.internal.openfigLegacy('downsampler', 'reuse', 'visible');
    handles = struct('datfilepath','','outfilepath','','processing',0,'stopExecution',0);
    handles.downfig = downfig;
    handles.progressBar = findobj(downfig,'Tag','progressBar');
    handles.progressPerc = findobj(downfig,'Tag','progressPerc');
    handles.runButton = findobj(downfig,'Tag','runbutton');
    handles.datfilepathTxt = findobj(downfig,'Tag','datfilepath');
    handles.outfilepathTxt = findobj(downfig,'Tag','outfilepath');
    handles.datfileSelector = findobj(downfig,'Tag','datfileselector');
    handles.outfileSelector = findobj(downfig,'Tag','outfileselector');
    
    set(handles.runButton,'Callback',@runDownClickHandler);
    set(handles.datfileSelector,'Callback',@datfileSelectorClickHandler);
    set(handles.outfileSelector,'Callback',@outfileSelectorClickHandler);
    
    % set up progressbar state
    bg_color = 'w';
    fg_color = 'g';
    set(handles.progressBar,{'XLim','YLim','XTick','YTick','Color','XColor','YColor'},...
        {[0 1],[0 1],[],[],bg_color,bg_color,bg_color});
    patch([0 0 0 0],[0 1 1 0],fg_color,...
        'Parent',handles.progressBar,...
        'EdgeColor','none',...
        'EraseMode','none');
    
    guidata(downfig,handles);
end

function datfileSelectorClickHandler(hObject,~,~)
    [filename,path] = uigetfile('*.dat','Select .dat file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/dat/');
    if filename == 0
        return;
    end
    
    handles = guidata(hObject);
    handles.datfilepath = [path,filename];
    set(handles.datfilepathTxt,'String',handles.datfilepath);
    if strcmp(handles.outfilepath,'')
        extIndex = find(filename == '.',1,'last');
        if isempty(extIndex)
            downFileName = [filename,'_downsampled.mat'];
        else
            downFileName = [filename(1:extIndex-1),'_downsampled.mat'];
        end
        handles.outfilepath = [path downFileName];
        set(handles.outfilepathTxt,'String',handles.outfilepath);
    end
    guidata(hObject,handles);
end

function outfileSelectorClickHandler(hObject,~,~)
    handles = guidata(hObject);
    if ~strcmp(handles.outfilepath,'')
        startdir = handles.outfilepath;
    elseif ~strcmp(handles.datfilepath,'')
        startdir = handles.datfilepath;
    else
        startdir = '/';
    end
    outfilepath = uiputfile('*.mat','Select output file',startdir);
    if outfilepath == 0
        return;
    end
    
    handles.outfilepath = outfilepath;
    set(handles.outfilepathTxt,'String',handles.outfilepath);
    guidata(hObject,handles);
end


