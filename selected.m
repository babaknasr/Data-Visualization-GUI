% evaluate the selected x and y
% and call back the available parameters
function alist=selected(xselect,yselect,wd)
alist={};
[xi, ~] = detect(xselect);
[yi, ~] = detect(yselect);

emptycells = cellfun(@isempty,wd(2:end,:));

xnonempty = find(emptycells(:,xi) == 0);
ynonempty = find(emptycells(:,yi) == 0);
nonempty = intersect(xnonempty, ynonempty);

if (isempty(nonempty) == 1)
    alist = {};
    return
end %if

for i=1:size(emptycells,2)
    if ((i ~= xi) && (i ~= yi))
        eliminate = 0;
        for j = nonempty
            if (emptycells(j,i) == 1)
                eliminate = 1;
                break
            end %if
        end %j
        if (eliminate == 0)
            alist = [alist,detect0(i)];
        end %if
    end %if
    
end %i