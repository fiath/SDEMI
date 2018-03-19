function openHierView()
    modal = matlab.hg.internal.openfigLegacy('hiercluster', 'reuse', 'visible');
    
    % populate drop-down menu
    
    handles = struct(...
				'fig', modal,...
                'list',findobj(modal,'Tag','features_group'),...
                'calculate',findobj(modal,'Tag','calculate_button'),...
				'metric', findobj(modal, 'Tag', 'metric_popup'),...
				'method', findobj(modal, 'Tag', 'method_popup'),...
				'input_text',findobj(modal, 'Tag', 'input_text'),...
				'output_text',findobj(modal, 'Tag', 'output_text'));
	
	set(handles.metric, 'Callback', @metricChange);
	set(handles.method, 'Callback', @methodChange);
	handles.fig.Name = 'Hierarchical clustering';
	
	handles.metric_strings = {'euclidean','squaredeuclidean',...
		'seuclidean','mahalanobis','cityblock','minkowski','chebychev',...
		'cosine','correlation','hamming','jaccard','spearman'};
            
	handles.method.String = {'average','centroid','complete','median',...
		'single','ward','weighted'};
	handles.metric.String = handles.metric_strings;
    set(findobj(modal,'Tag','input_button'),'Callback',@inputSelect);
	set(findobj(modal,'Tag','output_button'),'Callback',@outputSelect);
	
	set(handles.calculate,'Callback',@calcCallback);
    
    set(modal,'WindowScrollWheelFcn', {@scrollfunc});
    set(modal,'WindowButtonMotionFcn', {@movefunc});
            
	handles.data = struct();
	handles.features = {};
    
    guidata(modal,handles);
end

function metricChange(obj,~,~)
	handles = guidata(obj);
	handles.fig.Name = 'Hierarchical clustering';
end

function methodChange(obj,~,~)
	handles = guidata(obj);
	handles.fig.Name = 'Hierarchical clustering';
	
	active_method = handles.method.String{handles.method.Value};
	active_metric = handles.metric.String{handles.metric.Value};
	
	if any(strcmp(active_method,{'centroid','median','ward'}))
		handles.metric.String = {'euclidean','minkowski'};
		if strcmp(active_metric,'minkowski')
			handles.metric.Value = 2;
		else
			handles.metric.Value = 1;
		end
	else
		handles.metric.String = handles.metric_strings;
		index = find(strcmp(active_metric,handles.metric_strings),1);
		handles.metric.Value = index;
	end
end

function inputSelect(obj,~,~)
	handles = guidata(obj);
	[filename, dir] = uigetfile('*.mat','Select feature file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/');
	if isequal(filename,0)
		return
	end
	handles.fig.Name = 'Hierarchical clustering';
	data = load([dir filename]);
	for i=1:length(handles.features)
		delete(handles.features{i}.uicheckbox);
		delete(handles.features{i}.uitext);
	end
	handles.features = cell(1,length(data.featureNames));
	for i=1:length(data.featureNames)
		handles.features{i} = struct('Name',data.featureNames{i},'Active',1);
	end
	handles.input_text.String = [dir, filename];
	handles.data = data;
	guidata(obj, handles);
	updateFeatureList(obj);
end

function outputSelect(obj,~,~)
	handles = guidata(obj);
	[file, path] = uiputfile('*.mat','Select output file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/');
	handles.output_text.String = [path,file];
	handles.fig.Name = 'Hierarchical clustering';
	guidata(obj, handles);
end

function updateFeatureList(fig)
	handles = guidata(fig);
	for i=1:length(handles.features)
        bottom = handles.list.Position(4)-(i-1)*20-40;
        f = handles.features{i};
        f.uicheckbox = uicontrol(handles.list,'Style','checkbox',...
                    'Units','pixels',...
                    'Position',[10 bottom 15 15],...
                    'Value',f.Active,...
                    'Callback',{@checkBox,i});
        f.uitext = uicontrol(handles.list,'Style','text',...
                    'Units','pixels',...
                    'String',f.Name,...
                    'Position',[40 bottom handles.list.Position(3)-40 15],...
                    'HorizontalAlignment','left');
        handles.features{i} = f;
	end
	
	handles.listHeight = 20*(length(handles.features)-1) + 40 + 10;
    handles.scrollPos = 0;
    handles.scrollMax = max([0,handles.listHeight-handles.list.Position(4)]);
    handles.scrollDelta = 6;
	
	guidata(fig,handles);
end

function checkBox(obj,~,feature_index)
    handles = guidata(obj);
	handles.fig.Name = 'Hierarchical clustering';
    handles.features{feature_index}.Active = obj.Value;
    guidata(obj,handles);
end

function updateScrollPosition(obj,handles)
    for i=1:length(handles.features)
        bottom = handles.list.Position(4)-(i-1)*20-40 + handles.scrollPos;
        file = handles.features{i};
        file.uicheckbox.Position(2) = bottom;
        file.uitext.Position(2) = bottom;
    end
end

function scrollfunc(obj,edata,~)
    pos = get(obj,'CurrentPoint');
    handles = guidata(obj);
    if pos(1) > handles.list.Position(1) && pos(1) < handles.list.Position(1)+handles.list.Position(3) ...
            && pos(2) > handles.list.Position(2) && pos(2) < handles.list.Position(2)+handles.list.Position(4)
        %fprintf('They see me scrolling they hatin''\n');
        dir = edata.VerticalScrollCount;
        if dir < 0 && handles.scrollPos > 0
            handles.scrollPos = max([handles.scrollPos-handles.scrollDelta,0]);
            guidata(obj,handles);
            updateScrollPosition(obj,handles);
        elseif dir > 0 && handles.scrollPos < handles.scrollMax
            handles.scrollPos = min([handles.scrollPos+handles.scrollDelta,handles.scrollMax]);
            guidata(obj,handles);
            updateScrollPosition(obj,handles);
        end
    end
end

function calcCallback(obj,~,~)
	handles = guidata(obj);
	if isempty(fieldnames(handles.data))
		return
	end
	if isempty(handles.output_text.String)
		return
	end
	active_features = [];
	for i=1:length(handles.features)
		if handles.features{i}.Active == 1
			active_features = [active_features, i];
		end
	end
	fprintf('Calculating for features [%s]\n',num2str(active_features));
	method = handles.method.String{handles.method.Value};
	metric = handles.metric.String{handles.metric.Value};
	output = linkage(handles.data.Z(:,active_features), method, metric);
	[warnMsg, warnId] = lastwarn;
	input = handles.data;
	save(handles.output_text.String,'input','active_features','output','metric','method');
	if ~isempty(warnMsg) && strcmp(warnId,'stats:linkage:NonMonotonicTree')
        handles.fig.Name = 'Hierarchical clustering (Done) [NonMonotonicTree]';
		warning('','');
	else
		handles.fig.Name = 'Hierarchical clustering (Done)';
	end
	
end

function movefunc(obj,edata)
    pos = get(obj,'CurrentPoint');
    %fprintf('They see me moving they hatin'': %f %f\n',pos(1),pos(2));
end