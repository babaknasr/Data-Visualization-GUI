function globtdb = fit_separatedata(tdb)

reflist = {};
for i=1:size(tdb,1)
    reflist{i} = tdb{i,3}{1,1}{2,strcmpi(tdb{i,3}{1,1}(1,:),'Reference')};
end %i
reflistu = unique(reflist,'stable');
globtdb = {};
for i=1:length(reflistu)
    globtdb{i,1} = tdb(strcmpi(reflist,reflistu(i)),:);
    globtdb{i,2} = reflistu{i};
end %i

