function loadDat(fig)
%LOADDAT Summary of this function goes here
%   Detailed explanation goes here

    [filename,path] = uigetfile('*.dat','Select .dat file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/dat/');
    if filename == 0
        return;
    end
    
    clearTraceView(fig);

    handles = guidata(fig);
    
    filepath = [path filename];
    file = dir(filepath);
    
    datafile = handles.datafile;
    
    datafile.filedir = path;
    set(fig,'Name',filepath);
    datafile.length = file.bytes/datafile.numberOfChannels/datafile.resolution;
    % the whole file is loaded at once
    %datafile.bufferSize = min(datafile.maxBufferSize,datafile.length);
    datafile.file = memmapfile(filepath, 'Format',{'int16', [datafile.numberOfChannels datafile.length], 'x'});
    datafile.channelLines = gobjects(datafile.numberOfChannels,1);
    % plot empty lines for each channel
    for i=1:datafile.numberOfChannels
        datafile.channelLines(i) = plot(handles.axes1,[nan],[nan],'Color','black','hittest','off');
        hold(handles.axes1,'on');
        set(datafile.channelLines(i),'Visible','off');
    end
    datafile.channelIds = gobjects(datafile.numberOfChannels,1);
    datafile.activeChannels = ones(1,datafile.numberOfChannels);
    [datafile,success] = changeActiveChannels(datafile,'65');
    set(handles.edit1,'String',datafile.channelRangeString);

    for i=1:datafile.numberOfChannels
        datafile.channelIds(i) = uicontrol('Style','text','String',num2str(i),'Position',[0,0,40,13]);
        set(datafile.channelIds(i),'ButtonDownFcn',{@onChannelIdHandler,i},'Enable','inactive');
        set(datafile.channelIds(i),'HorizontalAlignment','right');
    end
    % load downsampled data if possible
    try
        extIndex = find(filename=='.',1,'last');
        if isempty(extIndex)
            downSampledFileName = [filename,'_downsampled.mat'];
        else
            downSampledFileName = [filename(1:extIndex-1),'_downsampled.mat'];
        end
        datafile.downsampled = load([datafile.filedir downSampledFileName]);
        datafile.maxWindowSize = 200000;
    catch
        warning('No downsampled file in %s with name %s',datafile.filedir,downSampledFileName);
        datafile.downsampled = [];
        datafile.maxWindowSize = 100000;
    end
    
    handles.datafile = datafile;
    
    ax = handles.axes1;
    set(ax,'YLim',handles.datafile.ylim);
    %ax.Clipping = 'off';
    handles.datafile = updateWindow(handles,[0,100000-1]);
    updateIdPositions(handles);
    handles.datLoaded = 1;
    
    guidata(fig,handles);
    
    showAllChildren(fig);
    set(handles.clusterview,'Enable','on');
    set(handles.heatmapView,'Enable','on');
    set(handles.traceview,'Enable','off');
end

