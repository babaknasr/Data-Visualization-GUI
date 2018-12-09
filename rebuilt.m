function [wd, whd] = rebuilt(wd, whd, par, criteria)
% par = 'Time';
[index, ~] = detect(par);
[indsource, ~] = detect('Reference');
indsn = detecthp('setnumber');
setsarray = [];
k = 0;
i = 0;
ind1 = i + 2;
while i <= size(wd(2:end,:),1)-1
    i = i + 1;
    sheetnumber = whd{i+1,indsn}(1,1);
    setnumber = whd{i+1,indsn}(1,2);
    source = wd{i+1,indsource};
    for j=i+1:size(wd(2:end,:),1)
        if (whd{j+1,indsn}(1,2) ~= setnumber) || ((whd{j+1,indsn}(1,2) == setnumber) && (whd{j+1,indsn}(1,1) ~= sheetnumber))...
                || ((whd{j+1,indsn}(1,2) == setnumber) && (whd{j+1,indsn}(1,1) == sheetnumber) && (strcmp(source,wd{j+1,indsource}) == 0))
            ind2 = j;
            k = k + 1;
            setsarray(k,:) = [ind1, ind2];
            i = j - 1;
            ind1 = i + 2;
            break;
        end %if
        
    end %j
    
end %i
ind2 = size(wd(2:end,:),1) + 1;
setsarray(k+1,:) = [ind1, ind2];
eliminateind = [];
k = 0;
for i=1:size(setsarray,1)
    temp = wd(setsarray(i,1):setsarray(i,2),index);
    temp = cellfun(@str2double,temp);
    switch criteria
        case 'Max'
            desire = max(temp);
        case 'Min'
            desire = min(temp);
        case 'Mean'
            [~,i0] = min(abs(temp - mean(temp)));
            desire = temp(i0);
%             desire = mean(temp);
        case 'Median'
            [~,i0] = min(abs(temp - median(temp)));
            desire = temp(i0);
    end %switch;
    if (all(isnan(temp) == 1) == 0)
        ind = find(temp == desire) + setsarray(i,1) - 1;
        for j=setsarray(i,1):setsarray(i,2)
            if (j ~= ind)
                k = k + 1;
                eliminateind(k) = j;
            end %if
        end %j
    end %if
end %if
wd(eliminateind,:) = [];
whd(eliminateind,:) = [];
