function theory_deletedb()
global materialdb
if (isempty(materialdb.pname) == 1)
    msgbox('No record has been found.','Database warning','warn','modal');
    return
end %if
for i=1:length(materialdb.pname)
    list{i} = [materialdb.pname{i} ' - ' materialdb.sname{i} ' (' materialdb.mname{i} ')'];
end %i
[s,ok] = listdlg('Name','Properties Database',...
    'PromptString',{'Please select to delete', ''},...
    'SelectionMode','multiple','ListString',list);
if (ok == 0)
    return
end %if
choice = questdlg(['Are you sure you want to delete ' num2str(length(s)) ' record(s)?'], ...
	'Database', ...
	'Yes','No','No');
cpath = getcurrentdir();
switch choice
    case 'Yes'
        materialdb.pname(s) = [];
        materialdb.sname(s) = [];
        materialdb.mname(s) = [];
        materialdb.mdb(s) = [];
        save([cpath '\matdb.dat'],'materialdb')
        msgbox([num2str(length(s)) ' record(s) was deleted.'],'Database','help','modal');
    case 'No'
        return
end %switch
