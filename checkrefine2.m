function [er, err] = checkrefine2(tableget,indices,newdata)

i = indices(1);
j = indices(2);
newd = newdata;
err = {};
e = 0;
e2 = 0;
switch j
    case 6 % Adj. Min
        if (isempty(tableget{i,4}) == 0) %Adj. Min for Qty
            if (str2double(newd) < str2double(tableget{i,4})) || (str2double(newd) > str2double(tableget{i,7}))
                e = e + 1;
                err{e} = [tableget{i,2} ': Adj. Min should be greater than original Min, and less than Adj. Max'];
            else
%                 if (xor((strcmpi(newd,'min') == 0),(strcmpi(newd,'max') == 0)) == 0) && (isnan(str2double(newd)) == 1)
                if (isnan(str2double(newd)) == 1)
                    e = e + 1;
                    err{e} = [tableget{i,2} ': Adj. Min should be a number'];
                end %if
            end %if
        else
            e2 = e2 + 1;
        end %if
    case 7  % Adj. Max
        if (isempty(tableget{i,5}) == 0) %Adj. Max for Qty
            if (str2double(newd) < str2double(tableget{i,6})) || (str2double(newd) > str2double(tableget{i,5}))
                e = e + 1;
                err{e} = [tableget{i,2} ': Adj. Max should be less than original Max, and greater than Adj. Min'];
            else
%                 if (xor((strcmpi(newd,'min') == 0),(strcmpi(newd,'max') == 0)) == 0) && (isnan(str2double(newd)) == 1)
                if (isnan(str2double(newd)) == 1)
                    e = e + 1;
                    err{e} = [tableget{i,2} ': Adj. Max should be a number'];
                end %if
            end %if
        else
            e2 = e2 + 1;
        end %if
%     case 8
%         if (isempty(tableget{i,9}) == 0)
%             e2 = e2 + 1;
%         end %if
end %switch
er = [e, e2];