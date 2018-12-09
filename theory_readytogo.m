function theory_readytogo(handles)

% off axes2
cla(handles.axes2);
set(handles.axes2,'Visible','off')
% Clear axes1
set(handles.axes1,'Visible','on')
cla(handles.axes1)
axes(handles.axes1)
axis auto
legend('off')
xlabel('')
ylabel('')
title('')

% off the data analyzer part
% set(handles.uipanel1,'Visible','off')
set(handles.idea1_m,'Enable','off')
set(handles.uipanel2,'Visible','off')
set(handles.uipanel3,'Visible','off')
set(handles.rangepanel,'Visible','off')
set(handles.legendpanel,'Visible','off')
set(handles.legendpanel2,'Visible','off')
set(handles.legendpanel3,'Visible','off')
set(handles.plotbutton,'Visible','off')
set(handles.applychangebutton,'Visible','off')
set(handles.selectpoint,'Enable','off')
% off the tools menu
set(handles.tools_menu,'Enable','off')

% on the View Menu
set(handles.view,'Enable','on')

% opn the view menu

%initiate for log plot
set(handles.xaxislog_m,'Checked','on')
set(handles.xlog,'State','on','Enable','on')
set(handles.yaxislog_m,'Checked','on')
set(handles.ylog,'State','on','Enable','on')
set(handles.axes1,'XScale','Log','YScale','Log')
%initiate grid
set(handles.axes1,'Xgrid','off','Ygrid','off','Zgrid','off')
set(handles.grid_m,'Checked','off')
%Disable compare button
set(handles.tcomparepushbutton,'Enable','off')
% on legend toolbar
set(handles.legenduitoggletool,'Enable','on')
% to be continue...

% on the theory part
set(handles.theorypanel,'Visible','on')
set(handles.backpushbutton,'Visible','on')
% Clear text boxes
set(handles.pnameedit,'String','')
set(handles.snameedit,'String','')
set(handles.mediumedit,'String','')

% set the property table
[pr, ~] = theory_property();
set(handles.propuitable,'ColumnFormat',{'logical','char','numeric'},...
    'ColumnWidth',{20,230,50},'ColumnName',{'','Property','Value'},...
    'ColumnEditable',[false,false,true],'Data',pr)
theory_propdetect(handles)

%load database
erload = theory_loaddatabase();
