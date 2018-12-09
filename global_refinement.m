function [list,newx,newy,newll,newhll] = global_refinement(x,y,ll,hll,istart,list)

[newx, newy, newll, newhll] = refine2(x,y,ll,hll,istart,list);
for i=1:size(list,1)
    if (i ~= istart)
        [newx, newy, newll, newhll] = refine2(newx,newy,newll,newhll,i,list);
    end %if
end %i
list2 = minmaxvalues(newll);
for i=1:size(list,1)
    list{i,6} = list2{i,4};
    list{i,7} = list2{i,5};
    if (isempty(list{i,9}) == 0)
        for j=1:size(list{i,9},1)
            list{i,9}{j,1} = false;
            for k=1:size(list2{i,9},1)
                if (strcmp(list{i,9}{j,2},list2{i,9}{k,2}) == 1)
                    list{i,9}{j,1} = true;
                    break
                end %if
            end %k
        end %j
    end %if
end %i
