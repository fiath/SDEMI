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
    datafile.length = file.bytes/datafile.numberOfChannels/datafile.resolution;
    % the whole file is loaded at once
    datafile.bufferSize = min(datafile.maxBufferSize,datafile.length);
    datafile.file = memmapfile(filepath, 'Format',{'int16', [datafile.numberOfChannels datafile.length], 'x'});
    datafile.channelLines = gobjects(datafile.numberOfChannels,1);
    datafile.channelIds = gobjects(datafile.numberOfChannels,1);
    datafile.activeChannels = ones(1,datafile.numberOfChannels);
    [datafile,success] = changeActiveChannels(datafile,'65:128');
    set(handles.edit1,'String',datafile.channelRangeString);

    for i=1:datafile.numberOfChannels
        datafile.channelIds(i) = uicontrol('Style','text','String',num2str(i),'Position',[0,0,40,13]);
        set(datafile.channelIds(i),'ButtonDownFcn',{@onChannelIdHandler,i},'Enable','inactive');
        set(datafile.channelIds(i),'HorizontalAlignment','right');
    end
    
    handles.datafile = datafile;
    
    ax = handles.axes1;
    set(ax,'YLim',handles.datafile.ylim);
    %ax.Clipping = 'off';
    handles.datafile = updateWindow(handles,[0,100000]);
    updateIdPositions(handles);
    handles.datLoaded = 1;
    
    guidata(fig,handles);
    
    showAllChildren(fig);
    set(handles.waveformview,'Enable','on');
end

