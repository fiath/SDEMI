function showAllChildren(obj)
%HIDEALLCHILDREN Summary of this function goes here
%   Detailed explanation goes here
    children = get(obj,'Children');
    for i=1:size(children,1)
        set(children(i),'Visible','on');
    end
    resizeHandler(obj);
end

