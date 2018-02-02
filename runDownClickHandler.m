function runDownClickHandler(hObject,~,~)
%RUNBUTTONCLICKHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    if handles.processing
        handles.stopExecution = 1;
        guidata(hObject,handles);
        return;
    end
        
    if strcmp(handles.datfilepath,'') || strcmp(handles.outfilepath,'')
        return
    end
    handles.processing = 1;
    handles.stopExecution = 0;
    set(handles.runButton,'String','Stop');
    guidata(hObject,handles);
    try
        GenerateDownSampled(100,handles.datfilepath,handles.outfilepath,...
            @(mill,txt) updateProgress(handles.downfig,handles.progressBar,handles.progressPerc,mill,txt),...
			handles.numberOfChannels);
    catch
        handles.processing = 0;
        handles.stopExecution = 0;
        set(handles.runButton,'String','Run');
        guidata(hObject,handles);
        uiProgressBar(handles.progressBar,1,'r');
        set(handles.progressPerc,'String','Aborted');
        return
    end
    handles.processing = 0;
    handles.stopExecution = 0;
    set(handles.runButton,'String','Run');
    guidata(hObject,handles);
    uiProgressBar(handles.progressBar,1,'g');
    set(handles.progressPerc,'String','Finished');

end

function updateProgress(fig,ax,perc,mill,txt)
    uiProgressBar(ax,mill/1000,'g');
    set(perc,'String',txt);
    drawnow
    handles = guidata(fig);
    if handles.stopExecution
        throw(MException('STOPPED','User stopped execution'));
    end
end

