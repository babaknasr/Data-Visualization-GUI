function newtable = settable(list,refine)

 newtable = {};
% for i=1:size(tableget,1)
%     newtable{i,1} = tableget{i,1};
%     if (strcmp(tableget{i,2},list{i,1}) == 1)
%         newtable{i,2} = list{i,1};
%         newtable{i,3} = list{i,2};
%         newtable{i,4} = list{i,3};
%         temp = '';
%         j = 0;
%         if (isempty(list{i,4}) == 0)
%             for k=1:length(list{i,4})
%                 temp = [temp '; ' list{i,4}{k}];
%             end %k
%         end %if
%         newtable{i,5} = temp;
%     end %if
% end %i

switch refine
    case 0
    for i=1:size(list,1)
        newtable{i,1} = list{i,1};
        newtable{i,2} = list{i,2};
        newtable{i,3} = list{i,3};
        newtable{i,4} = list{i,4};
        newtable{i,5} = list{i,5};
        temp = '';
        for k=1:size(list{i,9},1)
            paropen = '';
            parclose = '';
            if (list{i,9}{k,1} == true)
                paropen = '(';
                parclose = ')';
            end %if
            temp = [temp, ';', paropen, list{i,9}{k,2}, parclose];
        end %k
        newtable{i,6} = temp;
    end %i
    case 1
    for i=1:size(list,1)
        newtable{i,1} = list{i,1};
        newtable{i,2} = list{i,2};
        newtable{i,3} = list{i,3};
        newtable{i,4} = list{i,4};
        newtable{i,5} = list{i,5};
        newtable{i,6} = list{i,6};
        newtable{i,7} = list{i,7};
        newtable{i,8} = list{i,8};
        temp = '';
        for k=1:size(list{i,9},1)
            paropen = '';
            parclose = '';
            if (list{i,9}{k,1} == true)
                paropen = '(';
                parclose = ')';
            end %if
            temp = [temp, ';', paropen, list{i,9}{k,2}, parclose];
        end %k
        newtable{i,9} = temp;
    end %i
end %switch refine
