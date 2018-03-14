function stat3DView(rawfig)
    % -1 means that automatic
    visual = struct('xlim',-1,...
                    'ylim',-1,...
                    'zlim',-1,...
                    'default',[-37.5,30],...
                    'xy',[0,90],...
                    'xz',[0,0],...
                    'yz',[90,0],...
                    'view',-1);
	selected_features = struct('x', -1,...
						'y', -1,...
						'z', -1);
					
	feature_list = {};

    % Set up graphics
    fig = matlab.hg.internal.openfigLegacy('stat3dview', 'reuse', 'visible');
    handles = struct();
    handles.axes = findobj(fig,'Tag','axes');
	handles.open = findobj(fig,'Tag','open_menu');
	handles.values_radio = findobj(fig,'Tag','values_radio');
	handles.zscores_radio = findobj(fig,'Tag','zscores_radio');
	set(handles.values_radio,'Callback',@valuesetChangeListener);
	set(handles.zscores_radio,'Callback',@zscoresetChangeListener);
	handles.x_popup = findobj(fig,'Tag','x_popup');
	handles.y_popup = findobj(fig,'Tag','y_popup');
	handles.z_popup = findobj(fig,'Tag','z_popup');
	set(findobj(fig,'Tag','update_button'), 'Callback',@update);
	set(handles.open,'Callback',@openHandler);
    h = rotate3d(handles.axes);
    h.Enable = 'on';
    h.RotateStyle = 'orbit';
    
    orientations = {'default','xy','xz','yz'};
    for i=1:length(orientations)
        set(findobj(fig,'Tag',[orientations{i},'_orientation']),'Callback',@orientationChangedListener);
    end
    
    function orientationChangedListener(obj,~,~)
        tag = obj.Tag;
        name = strtok(tag,'_');
        view(handles.axes,visual.(name));
    end

    axii = {'xaxis','yaxis','zaxis'};
	for i=1:length(axii)
        handles.([axii{i},'_radio']) = findobj(fig,'Tag',[axii{i},'_radio']);
        handles.([axii{i},'_min']) = findobj(fig,'Tag',[axii{i},'_min']);
        handles.([axii{i},'_max']) = findobj(fig,'Tag',[axii{i},'_max']);
        set(handles.([axii{i},'_radio']),'Callback',@radioChangedListener);
        set(handles.([axii{i},'_min']),'Callback',@axisMinChangedListener);
        set(handles.([axii{i},'_max']),'Callback',@axisMaxChangedListener);
	end
	
	guidata(fig, handles)
    
    function radioChangedListener(obj,~,~)
        name = strtok(obj.Tag,'_');
        axis = name(1);
        mi = handles.([name,'_min']);
        ma = handles.([name,'_max']);
        if obj.Value == 1
            handles.axes.([upper(axis),'LimMode']) = 'manual';
            visual.([axis,'lim']) = handles.axes.([upper(axis),'Lim']);
            mi.Enable = 'on';
            ma.Enable = 'on';
        else
            handles.axes.([upper(axis),'LimMode']) = 'auto';
            visual.([axis,'lim']) = -1;
            mi.Enable = 'off';
            ma.Enable = 'off';
        end
        % lose focus
        obj.Enable = 'off';
        drawnow;
        obj.Enable = 'on';
        updateAxii();
    end

    function axisMinChangedListener(obj,~,~)
        name = strtok(obj.Tag,'_');
        axis = name(1); % x,y or z
        val = str2double(obj.String);
        lim = visual.([axis,'lim']);
        if ~isnan(val) && val <= lim(2)
            visual.([axis,'lim']) = [val,lim(2)]; 
        end
        
        % lose focus
        obj.Enable = 'off';
        drawnow;
        obj.Enable = 'on';
        updateAxii();
    end

    function axisMaxChangedListener(obj,~,~)
        name = strtok(obj.Tag,'_');
        axis = name(1); % x,y or z
        val = str2double(obj.String);
        lim = visual.([axis,'lim']);
        if ~isnan(val) && val >= lim(1)
            visual.([axis,'lim']) = [lim(1),val]; 
        end
        
        % lose focus
        obj.Enable = 'off';
        drawnow;
        obj.Enable = 'on';
        updateAxii();
    end

    function updateAxii()
        % set axii
        if ~isMO(visual.xlim)
            xlim(handles.axes,visual.xlim);
        end
        if ~isMO(visual.ylim)
            ylim(handles.axes,visual.ylim);
        end
        if ~isMO(visual.zlim)
            zlim(handles.axes,visual.zlim);
        end
        for l=1:length(axii)
            name = axii{l};
            axis = name(1);
            lim = handles.axes.([upper(axis),'Lim']);
            handles.([name,'_min']).String = lim(1);
            handles.([name,'_max']).String = lim(2);
        end
    end

    %update();

	function openHandler(obj,~,~)
		[filename,path] = uigetfile('*.mat','Select .mat file','/home/debreceni/Projects/MScOnlab/Adam/Data/Matlab/');
		if filename == 0
			return
		end
		handles = guidata(obj);
		if isempty(regexp(filename,'^zscore_','match'))
			% NOT zscore file was selected
			handles.rawdata = load([path filename]);
			feature_list = handles.rawdata.featureNames;
			try
				handles.zscoredata = load([path 'zscore_' filename]);
			catch
				handles.zscoredata = -1;
			end
		else
			handles.zscoredata = load([path filename]);
			feature_list = handles.zscoredata.featureNames;
			try
				handles.rawdata = load([path filename(8:end)]);
			catch
				handles.rawdata = -1;
			end
		end
		if isMO(handles.rawdata)
			handles.values_radio.Enable = 'off';
			handles.values_radio.Value = 0;
		else
			handles.values_radio.Enable = 'on';
			handles.values_radio.Value = 1;
			handles.zscores_radio.Value = 0;
		end
		if isMO(handles.zscoredata)
			handles.zscores_radio.Enable = 'off';
			handles.zscores_radio.Value = 0;
		else
			handles.zscores_radio.Enable = 'on';
			handles.values_radio.Value = 0;
			handles.zscores_radio.Value = 1;
		end
		
		if isempty(feature_list)
			return
		end
		
		handles.x_popup.String = feature_list;
		handles.y_popup.String = feature_list;
		handles.z_popup.String = feature_list;
		
		handles.x_popup.Value = 1;
		handles.y_popup.Value = 1;
		handles.z_popup.Value = 1;
		
		selected_features.x = 1;
		selected_features.y = 1;
		selected_features.z = 1;
		
		guidata(obj,handles);
		
		update();
	end

	function valuesetChangeListener(obj,~,~)
		handles = guidata(obj);
		handles.zscores_radio.Value = 0;
	end

	function zscoresetChangeListener(obj,~,~)
		handles = guidata(obj);
		handles.values_radio.Value = 0;
	end

	function update(~,~,~)
		handles = guidata(fig);
		[az,el] = view(handles.axes);
		cla(handles.axes);
		if handles.values_radio.Value == 1
			% display values
			scatter3(handles.axes,handles.rawdata.X(:, handles.x_popup.Value),...
				handles.rawdata.X(:, handles.y_popup.Value),handles.rawdata.X(:, handles.z_popup.Value))
		elseif handles.zscores_radio.Value == 1
			% display values
			scatter3(handles.axes,handles.zscoredata.Z(:, handles.x_popup.Value),...
				handles.zscoredata.Z(:, handles.y_popup.Value),handles.zscoredata.Z(:, handles.z_popup.Value))
		end
		xlabel(handles.axes, ['(x) ', feature_list{handles.x_popup.Value}]);
		ylabel(handles.axes, ['(y) ', feature_list{handles.y_popup.Value}]);
		zlabel(handles.axes, ['(z) ', feature_list{handles.z_popup.Value}]);
		updateAxii();
		view(handles.axes, [az,el]);
	end

end

