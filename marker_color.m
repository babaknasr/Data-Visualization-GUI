% [mc, mcn] = marker_color(leg, j)
% marker_color determaine the appropriate marker color of each value for
% qualitative parameters
% leg (cell) : the list of unique values for the specific parameter
% j : the jth item of leg, if j=0 the default color gets back, and if j=-1
% the no value color (gray) gets back
% mc : marker color symbol which is used in plot command in matlab
% mcn : the name of that marker color (mc) which is shown in legend list in
% GUI
function [mc, mcn] = marker_color(leg, j)
global gsettings
mcolor = {'r','g','b','c','m','y','k', [.5 .5 .5]};
colorname = {'Red','Green','Blue','Cyan','Magenta','Yellow','Black','Gray'};
if (j == -1)    % nodata markercolor
    mcn = gsettings.novalue_marker_color;
    mc = mcolor{find(strcmp(mcn,colorname),1)};
    return
end %if
if (j == 0) % Default markercolor
    mcn = gsettings.default_marker_color;
    mc = mcolor{find(strcmp(mcn,colorname),1)};
    return
end %if

if (isempty(gsettings.marker_color) == 0)
    for i=1:size(gsettings.marker_color,1)
        if (strcmp(gsettings.marker_color{i,1},leg{j}) == 1)
            index = find(strcmp(colorname,gsettings.marker_color{i,2}),1);
            mc = mcolor{index};
            mcn = colorname{index};
            return
        end %if
    end %i
end %if

if (j > length(mcolor))
    k = rem(j, length(mcolor));

else
    k = j;
end %if
mc = mcolor{k};
mcn = colorname{k};
