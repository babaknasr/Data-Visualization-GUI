function theory_considersave(handles)
global materialdb
pname = get(handles.pnameedit,'String');
sname = get(handles.snameedit,'String');
if (get(handles.mediumradiobutton1,'Value') == 1)
    mname = 'Air';
else
    mname = get(handles.mediumedit,'String');
end %if
er = 1;
err = {};
err{er} = 'Please consider the following warning(s):';
if (isempty(pname) == 1)
    er = er + 1;
    err{er} = '- Particle material name is empty.';
end %if
if (isempty(sname) == 1)
    er = er + 1;
    err{er} = '- Substrate material name is empty.';
end %if
if (isempty(mname) == 1)
    er = er + 1;
    err{er} = '- Medium material name is empty.';
end %if
if (isempty(materialdb.pname) == 0)
    for i=1:length(materialdb.pname)
        if ((strcmpi(materialdb.pname{i},pname) == 1) && (strcmpi(materialdb.sname{i},sname) == 1)...
                && (strcmpi(materialdb.mname{i},mname) == 1))
            er = er + 1;
            err{er} = '- There is a record with the same names in database already.';
            break
        end %if
    end %i
end %if
cpath = getcurrentdir();
if (er > 1)
    msgbox(err,'Database warning','warn','modal');
else
    dbget = get(handles.propuitable,'Data');
    materialdb.pname{end+1} = pname;
    materialdb.sname{end+1} = sname;
    materialdb.mname{end+1} = mname;
    materialdb.mdb{end+1} = dbget(:,2:end);
    save([cpath '\matdb.dat'],'materialdb')
    msgbox({'New record has been saved in Database:',[pname ' - ' sname ' (' mname ')']},'Database','help','modal');
end %if
