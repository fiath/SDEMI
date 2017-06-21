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

dataFile = '/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/dat/ARat_2016_07_18__0_002.dat';
file = dir(dataFile);
datafile = struct(  'numberOfChannels',128,...
                    'resolution',2,...
                    'samplingRate',20000,...
                    'file',-1,...
                    'length',-1,...
                    'bufferStart',0,...
                    'bufferEnd',0,...
                    'buffer',[],... % 128*#datapoints
                    'loadStart',100000,... % if center of window is smaller than this
                    'loadEnd',300000,... % if center of window is larger than this
                    'bufferSize',-1,... % the size of the buffer
                    'maxBufferSize',400000,... % in datapoints
                    'dataWindow',[0,20000],...
                    'maxWindowSize',50000,... % has to be smaller than maxBufferSize/4
                    'fileReader',-1,...
                    'newBufferStart',-1,...
                    'newBufferEnd',-1);
datafile.length = file.bytes/datafile.numberOfChannels/datafile.resolution;
% the whole file is loaded at once
datafile.bufferSize = min(datafile.maxBufferSize,datafile.length);
datafile.file = memmapfile(dataFile, 'Format',{'int16', [datafile.numberOfChannels datafile.length], 'x'});
handles.datafile = datafile;
%handles.datafile = changeDataWindow(handles.datafile,[220000,250000]);

% Update handles structure
guidata(hObject, handles);

function buffer = readData(datafile)
    file = fopen(datafile.file,'r');
    %file = datafile.file;
    fseek(file,datafile.newBufferStart*datafile.resolution*...
                                datafile.numberOfChannels,'bof');
    buffer = fread(file,[datafile.numberOfChannels,datafile.bufferSize],'int16');
    fclose(file);
  
% function f = parfeval(~,fun,nout,in1)
%     f = struct('output',fun(in1));
%     
% function [id,out] = fetchNext(f,varargin)
%     id = 1;
%     out = f.output;

% has to be called with datafile.fileReader == -1
function datafile = updateBufferForWindow(datafile)
    % the center of the window relative to the buffer
    center = (datafile.dataWindow(1) + datafile.dataWindow(2))/2 - datafile.bufferStart;
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
    global_center = (datafile.dataWindow(1) + datafile.dataWindow(2))/2;
    beginBuffer = max(0,global_center - floor(datafile.bufferSize/2));
    endBuffer = min(datafile.length,global_center + ceil(datafile.bufferSize/2));
    if beginBuffer == 0
        endBuffer = datafile.bufferSize;
    end
    if endBuffer == datafile.length
        beginBuffer = datafile.length - datafile.bufferSize;
    end
    p = gcp();
    datafile.newBufferStart = beginBuffer;
    datafile.newBufferEnd = beginBuffer + datafile.bufferSize;
    fprintf('Started read at [%d,%d]\n',datafile.newBufferStart,datafile.newBufferEnd);
    datafile.fileReader = parfeval(p,@readData,1,datafile);
    datafile = changeDataWindow(datafile,datafile.dataWindow);

function mousemoveHandler(hObject, eventdata, handles)

function window = checkDataWindow(datafile,window)
    size = min([datafile.length,datafile.maxWindowSize,window(2) - window(1)]);
    if size < 0
        error("newDataWindow.size cannot be negative");
    end
    if window(1) < 0
        window(1) = 0;
        window(2) = size;
    end
    if window(2) >= datafile.length
        window(2) = datafile.length-1;
        window(1) = window(2) - size;
    end
   
function datafile = changeDataWindow(datafile,newDataWindow)
    datafile.dataWindow = checkDataWindow(datafile,newDataWindow);
    return
    if datafile.fileReader == -1
        % we don't have bg fetching
        datafile = updateBufferForWindow(datafile);
    else
        % check if bg fetch finished
        [id,buffer] = fetchNext(datafile.fileReader,0);
        if size(id,1) == 1
            fprintf('Finished read at [%d,%d]\n',datafile.newBufferStart,datafile.newBufferEnd);
            datafile.fileReader = -1;
            datafile.buffer = buffer;
            datafile.bufferStart = datafile.newBufferStart;
            datafile.bufferEnd = datafile.newBufferEnd;
            datafile = changeDataWindow(datafile,datafile.dataWindow);
        else
            % bg is still running
            % check if dataWindow is in intersection
            if datafile.dataWindow(1) >= max(datafile.bufferStart,datafile.newBufferStart) && ...
                    datafile.dataWindow(2) <= min(datafile.bufferEnd,datafile.newBufferEnd)
                % window is in intersection use it
                return
            else
                % window is not contained in intersection
                if datafile.dataWindow(1) >= datafile.newBufferStart && ...
                        datafile.dataWindow(2) <= datafile.newBufferEnd
                    % window is contained in newBuffer
                    % wait for it to load
                    [id,buffer] = fetchNext(datafile.fileReader);
                    fprintf('Finished read at [%d,%d]\n',datafile.newBufferStart,datafile.newBufferEnd);
                    datafile.fileReader = -1;
                    datafile.buffer = buffer;
                    datafile.bufferStart = datafile.newBufferStart;
                    datafile.bufferEnd = datafile.newBufferEnd;
                    datafile = changeDataWindow(datafile,datafile.dataWindow);
                else
                    % window is not contained in bg result
                    % either need to start new bg or use buffer we already
                    % have
                    cancel(datafile.fileReader);
                    datafile.fileReader = -1;
                    datafile = changeDataWindow(datafile,datafile.dataWindow);
                end
            end
        end
    end

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function scrollHandler(hObject, eventdata, handles)
     C = get (gca, 'CurrentPoint');
    XLim = get(gca, 'XLim');
    YLim = get(gca, 'YLim');
    if XLim(1)<=C(1,1) && XLim(2)>=C(1,1) && ...
        YLim(1)<=C(1,2) && YLim(2)>=C(1,2)
        handles = guidata(gcf);
        window = handles.datafile.dataWindow;
        if eventdata.VerticalScrollCount > 0 
            window = window + 1000;
        else
            window = window - 1000;
        end
        handles.datafile = changeDataWindow(handles.datafile,window);
        guidata(hObject, handles);
        startBuff = handles.datafile.dataWindow(1);% - handles.datafile.bufferStart;
        endBuff = handles.datafile.dataWindow(2);% - handles.datafile.bufferStart;
        fprintf('Start: %d, End: %d\n',startBuff,endBuff);
        %fprintf('\nPostion: %d, BuffLength: %d, WindowStart: %d, WindowEnd: %d, BuffWindowStart: %d, BuffWindowEnd: %d\n',...
        %        handles.datafile.bufferStart,handles.datafile.bufferSize,handles.datafile.dataWindow(1),...
        %        handles.datafile.dataWindow(2),startBuff,endBuff);
        plot(gca,handles.datafile.file.Data.x(65,startBuff+1:endBuff));
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
