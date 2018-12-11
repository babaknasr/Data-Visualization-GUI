% Calculate shear velocity and put in main database for each data-points
% to fit CDF distribution directly to Shear velocity
function wd = rawdata_free2shear(wd,whd)
usind = find(strcmpi(wd(1,:),'Shear Velocity'),1);
if isempty(usind)
    wd{1,end+1} = 'Shear Velocity';
end %if

ufind = find(strcmpi(wd(1,:),'Free Stream Velocity'),1);
f2sind = find(strcmpi(whd(1,:),'free2shear'),1);

refind = find(strcmpi(wd(1,:),'Reference'),1);
titleind = find(strcmpi(whd(1,:),'title'),1);
disp('Converting Free Stream velocity to Shear velocity...')
for i=2:size(wd,1)
    cus = str2double(wd{i,usind});
    uf = str2double(wd{i,ufind});
    if isnan(cus)
        if ~isempty(whd{i,f2sind})
            ref = whd{i,f2sind}{1};
            cpar = whd{i,f2sind}{2};
            us = fit_free2shear(uf,ref,cpar);
            wd{i,usind} = num2str(us);
        else
            disp('Warning: no conversion found for free to shear velocity')
            disp(['row=',num2str(i),', Reference: ', wd{i,refind}, ', Title: ', whd{i,titleind}])
        end %if
    end %if
end %i
