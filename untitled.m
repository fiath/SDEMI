function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 20-Jun-2017 08:28:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

set(handles.figure1,'WindowButtonMotionFcn',@mousemoveHandler);
set(handles.figure1,'WindowScrollWheelFcn',@scrollHandler);
set(handles.figure1,'ResizeFcn',@resizeHandler);
set(handles.figure1,'WindowKeyPressFcn',@keydownHandler);
set(handles.figure1,'WindowKeyReleaseFcn',@keyupHandler);

dataFile = '/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/dat/ARat_2016_07_18__0_002.dat';
file = dir(dataFile);
datafile = struct(  'numberOfChannels',128,...
                    'resolution',2,...
                    'samplingRate',20000,...
                    'file',-1,...
                    'length',-1,...
                    'channelLines',[],...
                    'activeChannels',[],...
                    'channelIds',[],...
                    'bufferStart',0,...
                    'bufferEnd',0,...
                    'buffer',[],... % 128*#datapoints
                    'loadStart',5000,... % if center of window is smaller than this
                    'loadEnd',15000,... % if center of window is larger than this
                    'bufferSize',-1,... % the size of the buffer
                    'maxBufferSize',20000,... % in datapoints
                    'dataWindow',[0,0],...
                    'windowSize',-1,...
                    'maxWindowSize',5000,... % has to be smaller than maxBufferSize/4
                    'fileReader',-1,...
                    'newBufferStart',-1,...
                    'newBufferEnd',-1,...
                    'ylim',[0,30000]);
datafile.length = file.bytes/datafile.numberOfChannels/datafile.resolution;
% the whole file is loaded at once
datafile.bufferSize = min(datafile.maxBufferSize,datafile.length);
datafile.file = memmapfile(dataFile, 'Format',{'int16', [datafile.numberOfChannels datafile.length], 'x'});
datafile.channelLines = gobjects(datafile.numberOfChannels,1);
datafile.channelIds = gobjects(datafile.numberOfChannels,1);
%set(gca,'Units','pixels');
for i=1:datafile.numberOfChannels
    datafile.channelIds(i) = uicontrol('Style','text','String',num2str(i),'Position',[0,0,20,13]);
    set(datafile.channelIds(i),'ButtonDownFcn',{@onChannelIdHandler,i},'Enable','inactive');
    %set(datafile.channelIds(i),'Enable','inactive');
end
handles.datafile = datafile;
% hold(handles.axes1,'on');
ax = gca;
set(ax,'YLim',handles.datafile.ylim);
ax.Clipping = 'off';
handles.datafile = updateWindow(handles,[0,1000]);
updateIdPositions(handles.datafile);
modifiers = struct('shift',0,'ctrl',0,'alt',0);
handles.modifiers = modifiers;

% Update handles structure
guidata(hObject, handles);

function keydownHandler(hObject, eventdata, handles)
    handles = guidata(gcf);
    if any(strcmp(eventdata.Modifier,'shift')) && (~handles.modifiers.shift)
        fprintf('Shift down\n');
        handles.modifiers.shift = 1;
    end
    if any(strcmp(eventdata.Modifier,'control')) && ~handles.modifiers.ctrl
        fprintf('Ctrl down\n');
        handles.modifiers.ctrl = 1;
    end
    if any(strcmp(eventdata.Modifier,'alt')) && ~handles.modifiers.alt
        fprintf('Alt down\n');
        handles.modifiers.alt = 1;
    end
    guidata(hObject, handles);
    
function keyupHandler(hObject, eventdata, handles)
    handles = guidata(gcf);
    if ~any(strcmp(eventdata.Modifier,'shift')) && handles.modifiers.shift
        fprintf('Shift up\n');
        handles.modifiers.shift = 0;
    end
    if ~any(strcmp(eventdata.Modifier,'control')) && handles.modifiers.ctrl
        fprintf('Ctrl up\n');
        handles.modifiers.ctrl = 0;
    end
    if ~any(strcmp(eventdata.Modifier,'alt')) && handles.modifiers.alt
        fprintf('Alt up\n');
        handles.modifiers.alt = 0;
    end
    guidata(hObject, handles);

function mousemoveHandler(hObject, eventdata, handles)
    C = get (gca, 'CurrentPoint');
    %fprintf('Mouse: [%d,%d]\n',C(1,1),C(1,2));

function window = checkDataWindow(datafile,window)
    size = min([datafile.length,datafile.maxWindowSize,window(2) - window(1)]);
    if size < 0
        error("newDataWindow.size cannot be negative");
    end
    center = floor((window(1) + window(2))/2)
    window(1) = center - ceil(size/2);
    window(2) = center + floor(size/2);
    if window(1) < 0
        window(1) = 0;
        window(2) = size;
    end
    if window(2) >= datafile.length
        window(2) = datafile.length-1;
        window(1) = window(2) - size;
    end
    
 function datafile = updateBuffer(datafile,newWindow)
    center = floor((newWindow(1) + newWindow(2))/2 - datafile.bufferStart);
    if datafile.bufferEnd ~= 0
        % we already have a valid buffer
        if center > datafile.loadStart && center < datafile.loadEnd
            % we don't have to update the buffer
            return
        end
        if center <= datafile.loadStart && datafile.bufferStart == 0
            % we have no data before
            return
        end
        if center >= datafile.loadEnd && datafile.bufferEnd == datafile.length
            % we have no data after
            return
        end
    end
    % center the buffer at center
    global_center = floor((newWindow(1) + newWindow(2))/2);
    beginBuffer = max(0,global_center - floor(datafile.bufferSize/2));
    endBuffer = min(datafile.length,global_center + ceil(datafile.bufferSize/2));
    if beginBuffer == 0
        endBuffer = datafile.bufferSize;
    end
    if endBuffer == datafile.length
        beginBuffer = datafile.length - datafile.bufferSize;
    end
    datafile.buffer = 0.195*int32(datafile.file.Data.x(:,beginBuffer+1:endBuffer))';
    for i=1:datafile.numberOfChannels
        datafile.buffer(:,i) = datafile.buffer(:,i) + i*1000;
    end
    cla;
    x = linspace(beginBuffer,endBuffer,size(datafile.buffer,1));
    for i=1:datafile.numberOfChannels
        datafile.channelLines(i) = plot(x,datafile.buffer(:,i),'Color','black');
        set(datafile.channelLines(i),'ButtonDownFcn',{@onchannelclickHandler,i});
        hold on;
    end
    set(gca,'YTickLabel',[]);
    yticks((1:128)*1000);
%     ax = gca;
    datafile.bufferStart = beginBuffer;
    datafile.bufferEnd = endBuffer;
   
 function onChannelIdHandler(object,~,id)
     handles = guidata(gcf);
     onchannelclickHandler(handles.datafile.channelLines(id),0,id);
     
function updateIdPositions(datafile)
    YLim = get(gca, 'YLim');
    axPos = get(gca,'Position');
    figPos = get(gcf,'Position');
    axPos(1) = axPos(1)*figPos(3);
    axPos(2) = axPos(2)*figPos(4);
    axPos(3) = axPos(3)*figPos(3);
    axPos(4) = axPos(4)*figPos(4);
    labels = datafile.channelIds;
    for i=1:size(labels,1)
        pos = get(labels(i),'Position');
        width = pos(3);
        height = pos(4);
        if i*1000 < YLim(1) || i*1000 > YLim(2)
            set(labels(i),'Visible','off');
        else
            bottom = axPos(2) + axPos(4)/(YLim(2)-YLim(1))*(i*1000-YLim(1));
            set(labels(i),'Position',[axPos(1)-width-5, bottom - height/2,width,height]);
            set(labels(i),'Visible','on');
        end
    end
     
 function onchannelclickHandler(object,~,id)
     handles = guidata(gcf);
     lines = handles.datafile.channelLines;
     ids = handles.datafile.channelIds;
     for i=1:size(lines,1)
         lines(i).Color = 'black';
         lines(i).LineWidth = 1;
         ids(i).ForegroundColor = 'black';
     end
     object.Color = 'red';
     object.LineWidth = 2;
     ids(id).ForegroundColor = 'red';
    
function datafile = updateWindow(handles,newWindow)
        datafile = handles.datafile;
        newWindow = checkDataWindow(datafile,newWindow);
        datafile = updateBuffer(datafile,newWindow);
        startWindow = newWindow(1);      
        endWindow = newWindow(2);
        fprintf('Start: %d, End: %d\n',startWindow,endWindow);
%         axes(handles.axes1);
%         cla
        set(gca,'YLim',datafile.ylim);
        set(gca,'XLim',[newWindow(1),newWindow(2)]);
        datafile.dataWindow = newWindow;
        datafile.windowSize = datafile.dataWindow(2)-datafile.dataWindow(1);
        
function resizeHandler(hObject,~,~)
    handles = guidata(gcf);
    updateIdPositions(handles.datafile);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function scrollHandler(hObject, eventdata, handles)
    C = get (gca, 'CurrentPoint');
    XLim = get(gca, 'XLim');
    YLim = get(gca, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        handles = guidata(gcf);
        if ~handles.modifiers.shift
            ySize = YLim(2) - YLim(1);
            center = (YLim(1)+YLim(2))/2;
            if ~handles.modifiers.ctrl
                if eventdata.VerticalScrollCount < 0 
                    YLim = YLim + ySize/20;
                else
                    YLim = YLim - ySize/20;
                end
            else 
                if eventdata.VerticalScrollCount > 0 
                    ySize = ySize + max([ySize*0.05,10]);
                else
                   ySize = ySize*0.95;
                end
                YLim = [center - floor(ySize/2),center + ceil(ySize/2)];
            end
            handles.datafile.ylim = YLim;
            set(gca,'YLim',handles.datafile.ylim);
        else
            window = handles.datafile.dataWindow;
            if ~handles.modifiers.ctrl
                if eventdata.VerticalScrollCount > 0 
                    window = window + floor(handles.datafile.windowSize/20);
                else
                    window = window - floor(handles.datafile.windowSize/20);
                end
            else
                center = floor((window(1) + window(2))/2);
                if eventdata.VerticalScrollCount > 0 
                    handles.datafile.windowSize = floor(handles.datafile.windowSize + max([5,handles.datafile.windowSize*0.05]));
                else
                    handles.datafile.windowSize = floor(handles.datafile.windowSize*0.95);
                end
                window = [center - floor(handles.datafile.windowSize/2),...
                          center + ceil(handles.datafile.windowSize/2)];
            end
            handles.datafile = updateWindow(handles,window);
        end
        updateIdPositions(handles.datafile);
        guidata(hObject, handles);
    end


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
