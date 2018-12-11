% change the velocity conversion formula for current tdb variable
% Example:
% tdb = fit_changevelconv(tdb,{'Dean(1978)', 3.5e-3})
function tdb = fit_changevelconv(tdb,conver)
for i=1:size(tdb,1)
   tdb{i,2}(2:end,strcmpi(tdb{i,2}(1,:),'free2shear')) = {conver};
   f2sind = find(strcmpi(tdb{i,3}{1,2}(1,:),'free2shear'),1);
   tdb{i,3}{1,2}(2:end,f2sind) = {conver};
end %i
