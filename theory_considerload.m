function theory_considerload(handles)
global materialdb
if (isempty(materialdb.pname) == 1)
    msgbox('No record has been found.','Database warning','warn','modal');
    return
end %if
list = {};
for i=1:length(materialdb.pname)
    list{i} = [materialdb.pname{i} ' - ' materialdb.sname{i} ' (' materialdb.mname{i} ')'];
end %i
[s,ok] = listdlg('Name','Properties Database',...
    'PromptString',{'Please select:', 'Particle - Substrate (Medium)'},...
    'SelectionMode','single','ListString',list);
if (ok == 0)
    return
end %if
set(handles.pnameedit,'String',materialdb.pname{s})
set(handles.snameedit,'String',materialdb.sname{s})
if (strcmpi(materialdb.mname{s},'Air') == 1)
    set(handles.mediumradiobutton1,'Value',1)
    set(handles.mediumedit,'Enable','off','String','')
else
    set(handles.mediumradiobutton2,'Value',1)
    set(handles.mediumedit,'Enable','on','String',materialdb.mname{s})
end %if
[pr, ~] = theory_property();
for i=1:size(materialdb.mdb{s},1)
    row = find(strcmpi(materialdb.mdb{s}{i,1},pr(:,2)),1);
    if (isempty(row) == 0)
        pr{row,3} = materialdb.mdb{s}{i,2};
    end %if
end %i
set(handles.propuitable,'ColumnFormat',{'logical','char','numeric'},...
    'ColumnWidth',{20,230,50},'ColumnName',{'','Property','Value'},...
    'ColumnEditable',[false,false,true],'Data',pr)
theory_propdetect(handles)
