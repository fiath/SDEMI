function f = plotTraceAsFig(handles)
%PLOTTRACEASFIG Summary of this function goes here
%   Detailed explanation goes here

	datafile = handles.datafile;

	global_margin = [0.1, 0.1, 0.1, 0.1]; % top,right,bottom,left, perc of figure
    axes_size = [(1-global_margin(2)-global_margin(4)),(1-global_margin(1)-global_margin(3))];
    axes_margin = [0.05 0.05 0.05 0.05]; % perc of outer_width
    axes_inner_width = 1 -axes_margin(2)-axes_margin(4);
    axes_inner_height = 1 -axes_margin(1)-axes_margin(3);

    f = figure('Toolbar','None','Menubar','None','Units','pixels');
    fig_pos = get(f,'Position');
    ax_pos = get(handles.axes1,'Position');
    tr_pos = get(handles.figure1,'Position');
    set(f,'Position',[fig_pos(1:2),ax_pos(3:4).*tr_pos(3:4)./axes_size]);
	fig_pos = f.Position;
    ax = axes(f,'Position',[global_margin(4) global_margin(3),axes_size]);
    set(ax,'YLim',datafile.ylim);
    set(ax,'XLim',[datafile.dataWindow(1)/datafile.samplingRate,datafile.dataWindow(2)/datafile.samplingRate]);
    axis(ax,'off');
	
	% plot traces
	for i=1:datafile.numberOfChannels
		if ~datafile.activeChannels(i)
            continue;
		end
		line(ax,get(datafile.channelLines(i),'XData'),get(datafile.channelLines(i),'YData'));
	end
	
	% plot pivot lines
	% place whole lines at each second and dashed lines at each 200ms mark
	for i=1:length(datafile.dashedLines)
		line(ax,datafile.dashedLines(i).XData,datafile.dashedLines(i).YData,'Color',[0.2 0.2 0.2],'LineStyle','--');
	end
	for i=1:length(datafile.solidLines)
		line(ax,datafile.solidLines(i).XData,datafile.solidLines(i).YData,'Color',[0 0 0]);
	end      
	
	% plot channels ids
    labels = datafile.channelIds;
    for i=size(labels,1):-1:1
		if ~datafile.activeChannels(i)
            continue;
		end
		label = uicontrol(f,'Style','text','Units','pixels','String',labels(i).String,'BackgroundColor','white');
		pos = labels(i).Position;
		index = find(datafile.channelLines(i).XData > ax.XLim(1),1);
		bottom = (datafile.channelLines(i).YData(index)-ax.YLim(1))/(ax.YLim(2)-ax.YLim(1));
		bottom = (bottom*ax.Position(4) + ax.Position(2))*fig_pos(4);
		newPos = [global_margin(4)*fig_pos(3)-pos(3),bottom-pos(4)/2,pos(3:4)];
		label.Position = newPos;
	end
	
	scale = axes(f,'Color','none','YAxisLocation','right');
	width = 0.2;
	height = 0.2;
	scale.Position = [ax.Position(1)+ax.Position(3)-width,ax.Position(2),width,height];
	xscale = (ax.XLim(2)-ax.XLim(1))/ax.Position(3)*width;
	if xscale < 1
		xscale = xscale*1000;
		xlabel(scale,'ms');
	else
		xlabel(scale,'s');
	end
	scale.XLim = [0,xscale];
	yscale = (ax.YLim(2)-ax.YLim(1))/ax.Position(4)*height/datafile.amplitude;
	ylabel(scale,'uV');
	scale.YLim = [0,yscale];

end

