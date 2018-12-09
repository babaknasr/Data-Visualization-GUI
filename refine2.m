function [newx, newy, newll,newhll] = refine2(x,y,ll,hll,rowind,list)

newx = [];
newy = [];
% newl = l(1:2,:);
newll = ll(1:2,:);
newhll = hll(1,:);
% qty
% for i=1:size(ll,2)
% tr = find(strcmp(ll{1,i},list(:,2)), 1);
i = find(strcmp(ll(1,:),list{rowind,2}));
if ((isempty(i)) == 0)
    switch ll{2,i}
        case 'qty' % qty
            minc = str2double(list{rowind,6});
            maxc = str2double(list{rowind,7});
            incnan = list{rowind,8};
            j = 0;
            for k=1:length(ll(3:end,i))
                dat = str2double(ll{k+2,i});
                if ((dat >= minc) && (dat <= maxc)) || ((isnan(dat) == 1) && (incnan == true)) || ((isempty(dat) == 1) && (incnan == true)) % *****temporary change
                    j = j + 1;
                    newx(j) = x(k);
                    newy(j) = y(k);
%                     newl(j+2,:) = l(k+2,:);
                    newll(j+2,:) = ll(k+2,:);
                    newhll(j+1,:) = hll(k+1,:);
                end %if
            end %k
        case 'qly' % qly
            incnan = list{rowind,8};
            j = 0;
            for k=1:length(ll(3:end,i))
                index = find(strcmp(list{rowind,9}(:,2),ll{k+2,i}));
                if (isnan(index) == 0)
                     if (list{rowind,9}{index,1} == true)
                        j = j + 1;
                        newx(j) = x(k);
                        newy(j) = y(k);
%                        newl(j+2,:) = l(k+2,:);
                        newll(j+2,:) = ll(k+2,:);
                        newhll(j+1,:) = hll(k+1,:);
                     end %if
                else
                    if ((isempty(ll{k+2,i}) == 1) && (incnan == true))
                        j = j + 1;
                        newx(j) = x(k);
                        newy(j) = y(k);
%                        newl(j+2,:) = l(k+2,:);
                        newll(j+2,:) = ll(k+2,:);
                        newhll(j+1,:) = hll(k+1,:);
                    end %if
                end %if
            end %k
    end %switch
end %if
% end %i

