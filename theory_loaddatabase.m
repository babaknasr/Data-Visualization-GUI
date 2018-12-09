function er = theory_loaddatabase()
global materialdb
cpath = getcurrentdir();
try
    load([cpath '\matdb.dat'],'-mat','materialdb');
    er = 0;
catch
    er = 1;
    materialdb = struct('pname',[],'sname',[],'mname',[],'mdb',[]);
end %try