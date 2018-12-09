% it creat 'l' variable that is like 'll' but the only parameters which is
% wanted to show as legend in plot
% selectedl: the selected parameterts for legend view
% ll : all avialable parameters for that x y selection
function [l, lbond] = plotset(selectedl,ll,list)

l = {};
for i=1:length(selectedl)
    for j=1:size(ll,2)
        if (strcmp(selectedl{i},ll{1,j}) == 1)
            l(:,i) = ll(:,j);
            break
        end %if
    end %j
end %i
lbond = {};
for i=1:length(selectedl)
    for j=1:size(list,1)
        if (strcmp(selectedl{i},list{j,2}) == 1)
            lbond(i,:) = list(j,:);
            break
        end %if
    end %j
end %i


% bond is not necessary anymore
bond = {};
for i=1:size(l,2)
    rowind = find(strcmp(list(:,2),l{1,i}),1);
    switch l{2,i}
        case 'qty'
            bond{i} = [];
            bond{i}(1) = str2double(list{rowind,6});
            bond{i}(2) = str2double(list{rowind,7});
            bond{i}(3) = list{rowind,8};
            
        case 'qly'
%             list
%             rowind
            bond{i} = {};
            temp = {};
            j = 0;
            for k=1:size(list{rowind,9},1)
                if (list{rowind,9}{k,1} == true)
                    j = j + 1;
                    temp{j} = list{rowind,9}{k,2};
                end %if
            end %i
            bond{i} = temp;
    end %switch
end %i
