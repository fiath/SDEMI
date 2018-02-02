answer = inputdlg({'Number of channels: '},'SDEMI',1,{'128'});
if isempty(answer)
	return;
end

num = parse(answer{1});

untitled(num);

function num = parse(str)
	regex = '^[ ]*(?<num>[1-9]+[0-9]*)[ ]*$';
	m = regexp(str,regex,'names');
	if isempty(m)
		error('Invalid number of channels')
	end
	num = str2num(m.num);
end