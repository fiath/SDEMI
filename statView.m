function [ output_args ] = statView( input_args )
%STATVIEW Summary of this function goes here
%   Detailed explanation goes here
    statFig = matlab.hg.internal.openfigLegacy('statview', 'reuse', 'visible');
    handles = struct('features',[],'inputDir','','outputDir','','statFig',statFig);

    handles.features = {'Firing rate',struct('callback',@calcFiringRate,'args',[]);...
                'Burstiness',struct('callback',@calcBurstiness,'args',{{'Threshold (ms)';5}});...
                'Spike duration',struct('callback',@calcSpikeDuration,'args',[]);...
                'Maximal spike amplitude',struct('callback',@calcMaxAmplitude,'args',[]);...
                'Spike 2D expanse - absolute',struct('callback',@(varargin)-1,'args',[]);...
                'Spike 2D expanse - N1',struct('callback',@(varargin)-1,'args',[]);...
                'Spike 2D expanse - P2',struct('callback',@(varargin)-1,'args',[]);...
                'Spike shape',struct('callback',@(varargin)-1,'args',[]);...
                'Spike propagation',struct('callback',@(varargin)-1,'args',[]);...
                'Direction of negative peak propagation',struct('callback',@(varargin)-1,'args',[]);...
                'Distance of negative peak propagation',struct('callback',@(varargin)-1,'args',[]);...
                'Speed of negative peak propagation',struct('callback',@(varargin)-1,'args',[]);...
                'Time of negative peak propagation',struct('callback',@(varargin)-1,'args',[])};
            
    handles.activeFeatures = [1:5];
            
    handles.featureView = findobj(statFig,'Tag','features');
    handles.inputButton = findobj(statFig,'Tag','inputselector');
    handles.outputButton = findobj(statFig,'Tag','outputselector');
    handles.inputPathText = findobj(statFig,'Tag','inputdirpath');
    handles.outputPathText = findobj(statFig,'Tag','outputdirpath');
    handles.calculateButton = findobj(statFig,'Tag','calculate');
    handles.addButton = findobj(statFig,'Tag','addfeature');
    handles.removeButton = findobj(statFig,'Tag','removefeature');
    
    set(handles.removeButton,'Callback',@removeFeature);
    set(handles.addButton,'Callback',@addFeature);
    set(handles.inputButton,'Callback',@inputHandler);
    set(handles.outputButton,'Callback',@outputHandler);
    set(handles.calculateButton,'Callback',@calculateHandler);    
    set(handles.featureView,'Callback',@featureListHandler);
    
    
    guidata(statFig,handles);

    refreshFeatureList(statFig);
end

function refreshFeatureList(fig)
    handles = guidata(fig);
    set(handles.featureView,'String',handles.features(handles.activeFeatures,1)');
    
    index = get(handles.featureView,'Value');
    numF = length(handles.activeFeatures);
    if numF == 0
        index = 0;
    elseif index <= 0 || index > numF
        index = 1;
    end
    set(handles.featureView,'Value',index);
end

function featureListHandler(hObject,~,~)
    handles = guidata(hObject);
    if ~strcmp(get(handles.statFig,'SelectionType'),'open')
        return
    end
    index = get(hObject,'Value');
    args = handles.features{handles.activeFeatures(index),2}.args;
    if isempty(args)
        return
    end
    answer = inputdlg(args(1,:),'Parameters: ',1,arrayfun(@num2str,[args{2,:}]','UniformOutput',false));
    if isempty(answer)
        return % user cancelled
    end
    % TODO: check inputs
    answer = cellfun(@str2num,answer','UniformOutput',false);
    handles.features{handles.activeFeatures(index),2}.args(2,:) = answer;
    
    guidata(hObject,handles);
    
    refreshFeatureList(handles.statFig);
end


function removeFeature(hObject,~,~)
    handles = guidata(hObject);
    
    index = get(handles.featureView,'Value');
    if index == 0
        return
    end
    handles.activeFeatures(index) = [];
    if index > length(handles.activeFeatures)
        index = index - 1;
        set(handles.featureView,'Value',index);
    end
    
    guidata(hObject,handles);
    
    refreshFeatureList(handles.statFig);
end

function addFeature(hObject,~,~)
    handles = guidata(hObject);
    
    indices = 1:size(handles.features,1);
    indices = indices(~ismember(1:end,handles.activeFeatures));
    features = handles.features(indices,1)';
    
    [selection,ok] = listdlg('ListString',features,'Name','Feature selector','OKString','Add');
    
    if ~ok
        return
    end
    
    handles.activeFeatures = sort([handles.activeFeatures,indices(selection)]);
    
    guidata(hObject,handles);
    
    refreshFeatureList(handles.statFig);
end

function inputHandler(hObject,~,~)
    handles = guidata(hObject);
    if ~strcmp(handles.outputDir,'')
        startdir = handles.outputDir;
    else
        startdir = '/';
    end
    dirpath = uigetdir(startdir,'Select the .mat files'' directory');
    if dirpath == 0
        return;
    end
   
    handles.inputDir = dirpath;
    set(handles.inputPathText,'String',handles.inputDir);
    
    if strcmp(handles.outputDir,'')
        handles.outputDir = dirpath;
        set(handles.outputPathText,'String',handles.outputDir);
    end
        
    guidata(hObject,handles);
end

function outputHandler(hObject,~,~)
    handles = guidata(hObject);
    if ~strcmp(handles.inputDir,'')
        startdir = handles.inputDir;
    else
        startdir = '/';
    end
    dirpath = uigetdir(startdir,'Select the destination directory for the .txt files');
    if dirpath == 0
        return;
    end
   
    handles.outputDir = dirpath;
    set(handles.outputPathText,'String',handles.outputDir);
        
    guidata(hObject,handles);
end

function calculateHandler(hObject,~,~)
    handles = guidata(hObject);
    if strcmp(handles.inputDir,'') || strcmp(handles.outputDir,'') || isempty(handles.activeFeatures)
        return
    end
    
    calculateFeatures(handles.inputDir,handles.outputDir,handles.features(handles.activeFeatures,:));
end












