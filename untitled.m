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

% Last Modified by GUIDE v2.5 22-Jun-2017 09:43:43

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
set(handles.edit1,'Callback',@channelRangeEditHandler);

dataFile = '/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/dat/ARat_2016_07_18__0_002.dat';
file = dir(dataFile);
datafile = struct(  'numberOfChannels',128,...
                    'resolution',2,...
                    'samplingRate',20000,...
                    'file',-1,...
                    'length',-1,...
                    'channelLines',[],...
                    'activeChannels',[],...
                    'channelRangeString','',...
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
                    'maxWindowSize',10000,... % has to be smaller than maxBufferSize/2
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
datafile.activeChannels = ones(1,datafile.numberOfChannels);
[datafile,success] = changeActiveChannels(datafile,'65:128');
set(handles.edit1,'String',datafile.channelRangeString);
datafile.activeChannels;
%datafile.activeChannels(1,1:120) = 0;
%set(gca,'Units','pixels');
for i=1:datafile.numberOfChannels
    datafile.channelIds(i) = uicontrol('Style','text','String',num2str(i),'Position',[0,0,40,13]);
    set(datafile.channelIds(i),'ButtonDownFcn',{@onChannelIdHandler,i},'Enable','inactive');
    set(datafile.channelIds(i),'HorizontalAlignment','right');
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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
