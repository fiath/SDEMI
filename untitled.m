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

% Last Modified by GUIDE v2.5 04-Nov-2017 19:03:06

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
hideAllChildren(handles.figure1);


handles.output = hObject;
handles.figure1.PaperPositionMode = 'auto';

set(handles.figure1,'WindowButtonMotionFcn',@mousemoveHandler);
set(handles.figure1,'WindowScrollWheelFcn',@scrollHandler);
set(handles.figure1,'ResizeFcn',@resizeHandler);
set(handles.figure1,'WindowKeyPressFcn',@keydownHandler);
set(handles.figure1,'WindowKeyReleaseFcn',@keyupHandler);
set(handles.figure1,'CloseRequestFcn',@closeHandler);
set(handles.edit1,'Callback',@channelRangeEditHandler);
set(handles.positionEditText,'Callback',@positionEditHandler);
set(handles.filtertoggleview,'Callback',@filterToggleHandler);
set(handles.filterchangeview,'Callback',@changeFilterHandler);
set(handles.leftspike,'Callback',@previousSpike);
set(handles.rightspike,'Callback',@nextSpike);
set(handles.currentspiketext,'Callback',@currentSpikeChangeHandler);
set(handles.saveasimage,'Callback',@saveTraceImage);
handles.stafig = gobjects;
handles.hmfig = gobjects;
handles.clfig = gobjects;

handles.datafile = struct( 'fig',handles.figure1,... 
                    'ax',handles.axes1,...
                    'downsampled',[],...
                    'usingDownsampled',0,...
                    'numberOfChannels',128,...
                    'resolution',2,...
                    'samplingRate',20000,...
                    'amplitude',1,...
                    'file',-1,...
                    'length',-1,...
                    'channelLines',[],...
                    'activeChannels',[],...
                    'numOfActiveChannels',-1,...
                    'channelRangeString','',...
                    'channelIds',[],...
                    'bufferStart',0,...
                    'bufferEnd',0,...
                    'buffer',[],... % #datapoints * 128
                    'lfpAbsMaxValue',-1,...,
                    'muaAbsMaxValue',-1,...
                    'lfpBuffer',[],...
                    'muaBuffer',[],...
                    'loadStart',0.25,... % if center of window is smaller than this
                    'loadEnd',0.75,... % if center of window is larger than this
                    'bufferSize',-1,... % the size of the buffer
                    'windowUpdating',0,...
                    'maxBufferSize',200000,... % in datapoints
                    'dataWindow',[0,0],...
                    'windowSize',-1,...
                    'maxWindowSize',100000,... % has to be smaller than maxBufferSize/2
                    'fileReader',-1,...
                    'dataResolution',-1,... % number of datapoints per pixel in the horizontal direction
                    'newBufferStart',-1,...
                    'newBufferEnd',-1,...
                    'channelSpacing',1000,...
                    'maxYLimDiff',[-5000,5000],... % below first plot and above last plot
                    'ylim',[0,30000],...
                    'filter',struct('order',3,...
                                    'frequency',0.05,...
                                    'on',0,...
                                    'B',[],...
                                    'A',[]),...
                    'centerString','',...
                    'pivotLine',gobjects,...
                    'dashedLines',[],...
                    'solidLines',[],...
                    'timeFormat','%dh%dm%d.%03ds',...
                    'tooltip',struct('line',gobjects,'txt',handles.tooltiptxt,'active',0),...
                    'loadingSTA',0,...
                    'loadingHM',0,...
                    'loadingCL',0,...
                    'spikeLines',gobjects,...
                    'currentSpikeLine',gobjects,...
                    'currentSpike',-1,...
                    'allSpikeCount',-1);

set(handles.axes1,'YLimMode','manual');
set(handles.axes1,'XLimMode','manual');
%handles.traceCtxMenu = uicontextmenu(handles.figure1);
%topmenu = uimenu('Parent',handles.traceCtxMenu,'Label','Save image','Callback',@saveTraceImage);
%handles.axes1.UIContextMenu = handles.traceCtxMenu;
handles.modifiers = struct('shift',0,'ctrl',0,'alt',0,'space',0);
handles.datLoaded = 0;
[B,A] = butter(handles.datafile.filter.order,...
                handles.datafile.filter.frequency,'high');
handles.datafile.filter.A = A;
handles.datafile.filter.B = B;


% Update handles structure
guidata(hObject, handles);
setSpikeSelectorState(handles,'off');
%loadSTA(hObject,'/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/mat/');

function keydownHandler(hObject, eventdata, handles)
    handles = guidata(hObject);
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
    if strcmp(eventdata.Key,'space') && ~handles.modifiers.space
        fprintf('Space down\n');
        handles.modifiers.space = 1;
    end
    guidata(hObject, handles);
    if strcmp(eventdata.Key,'rightarrow')
        fprintf('Rightarrow down\n');
        if handles.modifiers.ctrl
            zoomHoriz(hObject,-1);
        else
            scrollHoriz(hObject,1);
        end
    elseif strcmp(eventdata.Key,'leftarrow')
        fprintf('Leftarrow down\n');
        if handles.modifiers.ctrl
            zoomHoriz(hObject,1);
        else
            scrollHoriz(hObject,-1);
        end
    elseif strcmp(eventdata.Key,'uparrow')
        fprintf('Uparrow down\n');
        if handles.modifiers.ctrl
            zoomVert(hObject,-1);
        elseif handles.modifiers.alt
            changeAmplitude(hObject,-1);
        else
            scrollVert(hObject,-1);
        end
    elseif strcmp(eventdata.Key,'downarrow')
        fprintf('Downarrow down\n');
        if handles.modifiers.ctrl
            zoomVert(hObject,1);
        elseif handles.modifiers.alt
            changeAmplitude(hObject,1);
        else
            scrollVert(hObject,1);
        end
    end
    
    
function keyupHandler(hObject, eventdata, handles)
    handles = guidata(hObject);
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
    currKey = get(hObject,'CurrentKey');
    if strcmp(eventdata.Key,'space') && ~strcmp(currKey,'space') && handles.modifiers.space
        fprintf('Space up\n');
        handles.modifiers.space = 0;
    end
    guidata(hObject, handles);
    if strcmp(eventdata.Key,'f5')
        handles.datafile = updateWindow(handles,handles.datafile.dataWindow,true);
        guidata(hObject,handles);
    end

function mousemoveHandler(hObject, eventdata, handles)
    %fprintf('MouseMoveEvent\n');
    handles = guidata(hObject);
    if ~handles.datLoaded
        return;
    end
    updateTooltip(hObject);

function closeHandler(hObject,eventdata)
    handles = guidata(hObject);
    if isgraphics(handles.stafig)
        close(handles.stafig);
    end
    if isgraphics(handles.hmfig)
        close(handles.hmfig);
    end
    if isgraphics(handles.clfig)
        close(handles.clfig);
    end
    delete(hObject);


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


% --------------------------------------------------------------------
function views_Callback(hObject, eventdata, handles)
% hObject    handle to views (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function traceview_Callback(hObject, eventdata, handles)
% hObject    handle to traceview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = guidata(hObject);
    loadDat(handles.figure1);


% --------------------------------------------------------------------
function waveformview_Callback(hObject, eventdata, handles)
% hObject    handle to waveformview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fprintf('Waveform open start\n');
    handles = guidata(hObject);
    handles.datafile.loadingSTA = 1;
    guidata(handles.figure1,handles);
    loadSTA(handles.figure1);
    handles = guidata(hObject);
    handles.datafile.loadingSTA = 0;
    guidata(handles.figure1,handles);
    fprintf('Waveform open end\n');



function positionEditText_Callback(hObject, eventdata, handles)
% hObject    handle to positionEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of positionEditText as text
%        str2double(get(hObject,'String')) returns contents of positionEditText as a double


% --- Executes during object creation, after setting all properties.
function positionEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to positionEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filtertoggleview.
function filtertoggleview_Callback(hObject, eventdata, handles)
% hObject    handle to filtertoggleview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtertoggleview


% --- Executes on button press in filterchangeview.
function filterchangeview_Callback(hObject, eventdata, handles)
% hObject    handle to filterchangeview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Transform_Callback(hObject, eventdata, handles)
% hObject    handle to Transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function stagen_Callback(hObject, eventdata, handles)
% hObject    handle to stagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = guidata(hObject);
    transformData(handles.figure1);


% --- Executes on button press in leftspike.
function leftspike_Callback(hObject, eventdata, handles)
% hObject    handle to leftspike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rightspike.
function rightspike_Callback(hObject, eventdata, handles)
% hObject    handle to rightspike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function currentspiketext_Callback(hObject, eventdata, handles)
% hObject    handle to currentspiketext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentspiketext as text
%        str2double(get(hObject,'String')) returns contents of currentspiketext as a double


% --- Executes during object creation, after setting all properties.
function currentspiketext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentspiketext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function heatmapView_Callback(hObject, eventdata, handles)
% hObject    handle to heatmapView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fprintf('HeatmapView open start\n');
    handles = guidata(hObject);
    handles.datafile.loadingHM = 1;
    guidata(handles.figure1,handles);
    openHeatmapView(handles.figure1);
    handles = guidata(hObject);
    handles.datafile.loadingHM = 0;
    guidata(handles.figure1,handles);
    fprintf('HeatmapView open end\n');
    
    
    
    


% --------------------------------------------------------------------
function clusterview_Callback(hObject, eventdata, handles)
% hObject    handle to clusterview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fprintf('ClusterView open start\n');
    handles = guidata(hObject);
    handles.datafile.loadingCL = 1;
    guidata(handles.figure1,handles);
    openClusterView(handles.figure1);
    handles = guidata(hObject);
    handles.datafile.loadingCL = 0;
    guidata(handles.figure1,handles);
    fprintf('ClusterView open end\n');


% --------------------------------------------------------------------
function statistics_Callback(hObject, eventdata, handles)
% hObject    handle to statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = guidata(hObject);
    statView(handles.figure1);
