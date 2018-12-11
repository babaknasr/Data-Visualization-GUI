% Calculate Particle Reynolds number from shear velocity and put in main database for each data-points
% Re = gamma/2 * (u*dp/nu)^2
function wd = rawdata_shear2Re(wd,whd)
gamma = 1;
nu = 1.5e-5;
Reind = find(strcmpi(wd(1,:),'Particle Reynolds'),1);
if isempty(Reind)
    wd{1,end+1} = 'Particle Reynolds';
end %if
usind = find(strcmpi(wd(1,:),'Shear Velocity'),1);
psind = find(strcmpi(wd(1,:),'Particle Size'),1);

refind = find(strcmpi(wd(1,:),'Reference'),1);
titleind = find(strcmpi(whd(1,:),'title'),1);
disp('Converting Shear velocity to Particle Reynolds Number...')
for i=2:size(wd,1)
    us = str2double(wd{i,usind});
    ps = str2double(wd{i,psind});
    if ~isnan(us)
        Re = gamma/2*(ps*1e-6*us/nu)^2;
        wd{i,Reind} = num2str(Re);
    else
        disp('Warning: no shear velocity to convert to Re')
        disp(['row=',num2str(i),', Reference: ', wd{i,refind}, ', Title: ', whd{i,titleind}])
    end %if
end %i
