function changeFilterHandler(hObject,~,~)
%CHANGEFILTERHANDLER Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(hObject);
    freq = floor(handles.datafile.filter.frequency*handles.datafile.samplingRate/2);
    answer = inputdlg({'Order of filter:','Cut-off frequency:'},...
                            'Filter',1,{num2str(handles.datafile.filter.order),...
                            num2str(freq)});
    if isempty(answer)
        % user cancelled
        return;
    end
    num_format = '^[ ]*(?<value>[1-9][0-9]*)[ ]*$';
    new_order = regexp(answer{1},num_format,'names');
    if isempty(new_order)
        % couldn't match order
        return;
    end
    new_order = str2num(new_order.value);
    new_freq = regexp(answer{2},num_format,'names');
    if isempty(new_freq)
        % couldn't match frequency
        return;
    end
    new_freq = str2num(new_freq.value);

    if new_freq > handles.datafile.samplingRate/2
        % invalid frequency
        return;
    end
    Wn = new_freq*2/handles.datafile.samplingRate;
    [b,a] = butter(new_order,Wn,'high');
    handles.datafile.filter.B = b;
    handles.datafile.filter.A = a;
    
    handles.datafile.filter.frequency = Wn;
    handles.datafile.filter.order = new_order;
    
    set(handles.filterfrequencyview,'String',...
        ['Frequency: ',num2str(new_freq),' Hz']);
    set(handles.filterorderview,'String',['Order: ',num2str(new_order)]);
    
    guidata(hObject,handles);
    if handles.datafile.filter.on
        refreshDataView(handles.figure1);
    end;
    
end

