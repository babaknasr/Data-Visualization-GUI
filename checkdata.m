function alist = checkdata(wd)
alist ={};
emptycells = cellfun(@isempty,wd(2:end,:));
for i=1:size(emptycells,2)
    temp = emptycells(:,i);
    if (find(temp == 0) > 0)
        name = detect0(i);
        [~, qty] = detect(name);
        if (qty == 1)
            alist = [alist,name];
        end %if
    end %if
end %i
