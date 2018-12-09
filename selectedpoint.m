function output_txt = selectedpoint(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
global newx newy newll newhll
pos = get(event_obj,'Position');

xind = find(newx == pos(1));
yind = find(newy == pos(2));
sensor = 0;
if ((length(xind) > 1) && (length(yind) > 1))
    for i=1:length(xind)
        for j=1:length(yind)
            if (yind(j) == xind(i))
                ind = yind(j);
                sensor = 1;
                break
            end %if
        end %j
        if (sensor == 1)
            break
        end %if
    end %i
end %if
if ((length(xind) > 1) && (length(yind) == 1))
    ind = yind;
end %if
if ((length(xind) == 1) && ((length(yind) > 1) || (length(yind) == 1)))
    ind = xind;
end %if

txt = {['X: ',num2str(pos(1))],['Y: ',num2str(pos(2))]};
j = 0;
for i=1:size(newll,2)
    [~, qty] = detect(newll{1,i});
    if (qty == 1)
       utext = [' (' punit(newll{1,i}) ')'];
    else
        utext = '';
    end %if
    if (isempty(newll{ind+2,i}) == 0)
%     if (strcmp(char(ll{ind+2,i}),'') == 0)
        j = j + 1;
        txt{1,j+2} = [char(newll{1,i}), ': ', char(newll{ind+2,i}) utext];
    end %if
end %i
it = detecthp('title');
id = detecthp('description');
ic = detecthp('comment');
ii = detecthp('setidentification');
% txt{1,end+1} = ['Title: ' newhll{ind+1,it} ' - ' newhll{ind+1,id}];
txt{1,end+1} = ['Title: ' newhll{ind+1,it}];
%%%%%% Added new line for legend 
txt{1,end+1} = ['Legend: ' newhll{ind+1,ii}{1,1} '; ' newhll{ind+1,ii}{1,2}];
if (isempty(newhll{ind+1,ic}) == 0)
    txt{1,end+1} = ['Comment: ' newhll{ind+1,ic}];
end %if

output_txt = txt;

% If there is a Z-coordinate in the position, display it as well
% if length(pos) > 2
%     output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
% end
