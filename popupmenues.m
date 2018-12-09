function popupmenues(handles)
global wd x y ll hll parlist xselect yselect pplot
pplot = 0;
resetall(handles)
set(handles.checkboxrefine,'Value',0,'Enable','off')
set(handles.resetrefinebutton,'Enable','off')
set(handles.realtimecheckbox,'Value',0,'Enable','off')
xstrings = get(handles.popupmenu1,'string');
ystrings = get(handles.popupmenu2,'string');
xsel = get(handles.popupmenu1,'value');
ysel = get(handles.popupmenu2,'value');
if iscell(xstrings)
    xselect = xstrings{xsel};
else
    xselect = xstrings;
end %if
if iscell(ystrings)
    yselect = ystrings{ysel};
else
    yselect = ystrings;
end %if
alist = selected(xselect,yselect,wd);
if (isempty(alist) == 1)
    set(handles.uitable2,'Data', {})
%     resetall(handles)
    msgbox('No Correlation!', 'Oops!','Warn','modal')
    return
end %if
[x, y, ll, hll] = available_parameters_data(xselect, yselect, alist);
parlist = minmaxvalues(ll);
tlist = settable(parlist,0);
set(handles.uitable2,'Data',tlist,'ColumnName',{'','Available Parameters','Unit','Min','Max','Qualitative Values'},...
    'ColumnFormat',{'logical','char','char','numeric','numeric','char'},'ColumnWidth',{20,'auto','auto','auto','auto','auto'},...
    'ColumnEditable',[true false false false false false])
set(handles.checkboxrefine,'Value',0,'Enable','on')
