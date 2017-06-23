function hideAllChildren(obj)
%HIDEALLCHILDREN Summary of this function goes here
%   Detailed explanation goes here
    children = get(obj,'Children');
    for i=1:size(children,1)
        if ~strcmp(get(children(i),'Type'),'uimenu')
            set(children(i),'Visible','off');
        end
    end

end

