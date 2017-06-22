function loadSTA(fig, filepath )
%LOADSTA Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(fig);
    stafig = matlab.hg.internal.openfigLegacy('sta', 'reuse', 'visible');
    handles.stafig = stafig;
    guidata(fig,handles);
    handles = struct('rawfig',fig);
    guidata(stafig,handles);
end

