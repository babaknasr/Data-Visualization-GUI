% [mt, mtn] = marker_type(leg, j)
% marker type determaine the appropriate marker type of each value for
% qualitative parameters
% leg (cell) : the list of unique values for the specific parameter
% j : the jth item of leg, if j=0 the default type gets back, and j=-1
% means that no value for that point
% mt : marker type symbol which is used in plot command in matlab
% mtn : the name of that marker type (mt) which is shown in legend list in
% GUI
function [mt, mtn] = marker_type(leg, j)
global gsettings

marker = {'o','d','v','s','>','p','^','<','*','hexagram','+','.','x'};
markername = {'Circle', 'Diamond', 'Downward triangle', 'Square', 'Right triangle',...
    'Pentagram','Upward triangle', 'Left triangle', 'Asterisk', 'Hexagram', 'Plus', 'Point',...
    'Cross'};
if (j == -1)    % novalue markertype
    mtn = gsettings.novalue_marker_type;
    mt = marker{find(strcmp(mtn,markername),1)};
    return
end %if
if (j == 0)     % default markertype
    mtn = gsettings.default_marker_type;
    mt = marker{find(strcmp(mtn,markername),1)};
    return
end %if

if (isempty(gsettings.marker_type) == 0)
    for i=1:size(gsettings.marker_type,1)
        if (strcmp(gsettings.marker_type{i,1},leg{j}) == 1)
            index = find(strcmp(markername,gsettings.marker_type{i,2}),1);
            mt = marker{index};
            mtn = markername{index};
            return
        end %if
    end %i
end %if

if (j > length(marker))
    k = rem(j, length(marker));
    if (k == 0)
        k = length(marker);
    end %if
else
    k = j;
end %if
mt = marker{k};
mtn = markername{k};


