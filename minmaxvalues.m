% this function determine the lin and max values or qualitative values for
% available parameters (ll variable), and it get back a list
function tablevalue = minmaxvalues(ll)
tablevalue = {};
for i=1:size(ll,2)
    temp = [];
    temp2 = {};
    temp3 = {};
%     temp3 = {};
    switch ll{2,i}
        case 'qty'
            for j=1:length(ll(3:end,i))
                temp(j) = str2double(ll{j+2,i});
            end %j
            tablevalue{i,1} = false;
            tablevalue{i,2} = ll{1,i};
            tablevalue{i,3} = punit(ll{1,i}); % for dimension
            tablevalue{i,4} = num2str(min(temp));
            tablevalue{i,5} = num2str(max(temp));
            tablevalue{i,6} = num2str(min(temp));
            tablevalue{i,7} = num2str(max(temp));
            tablevalue{i,8} = true;
            tablevalue{i,9} = '';
        case 'qly'
            temp2 = ll(3:end,i);
            tempind = cellfun('isempty',temp2) == 0;
            temp2 = unique(temp2(tempind));
            for j=1:length(temp2)
                temp3{j,1} = true;
                temp3{j,2} = temp2{j};
            end %j
%             if (isempty(temp2) == 0)
%                 temp3 = temp2{1};
%                 for j=2:length(temp2)
%                     temp3 = [temp3,'; ',temp2{j}];
%                 end %j
%             else
%                 temp3 = '[NaN]';
%             end %if
            tablevalue{i,1} = false;
            tablevalue{i,2} = ll{1,i};
            tablevalue{i,3} = punit(ll{1,i});  % for dimension
            tablevalue{i,4} = '';
            tablevalue{i,5} = '';
            tablevalue{i,6} = '';
            tablevalue{i,7} = '';
            tablevalue{i,8} = true;
%             tablevalue{i,4} = temp3;
            tablevalue{i,9} = temp3;
    end %switch
        
end %i
% the format of list value:
% it has the same format of uitable2



