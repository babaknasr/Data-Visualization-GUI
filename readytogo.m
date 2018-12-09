% ready to go after opening soe data!
% enabling the objects
function readytogo(handles)
set(handles.axes2,'Visible','off')
cla(handles.axes2);

%clear axes1
axes(handles.axes1);
cla(handles.axes1);
set(handles.axes1,'XScale','Linear','YScale','Linear')
axis auto
legend('off')
xlabel('')
ylabel('')
title('')

set(handles.yminedit,'String','')
set(handles.ymaxedit,'String','')
set(handles.xminedit,'String','')
set(handles.xmaxedit,'String','')



% off theory panel
set(handles.theorypanel,'Visible','off')
set(handles.backpushbutton,'Visible','off')

% on the tools menu
set(handles.tools_menu,'Enable','on')

% on the View Menu
set(handles.view,'Enable','on')

% off legend toolbar
set(handles.legenduitoggletool,'Enable','off')

%initiate for linear plot
set(handles.xaxislog_m,'Checked','off','Enable','on')
set(handles.xlog,'State','off','Enable','on')
set(handles.yaxislog_m,'Checked','off','Enable','on')
set(handles.ylog,'State','off','Enable','on')
%initiate grid
set(handles.axes1,'Xgrid','off','Ygrid','off','Zgrid','off')
set(handles.grid_m,'Checked','off')

set(handles.axes1,'Visible','on')
% set(handles.uipanel1,'Visible','on')
set(handles.uipanel2,'Visible','on')
set(handles.checkboxrefine,'Value',0,'Enable','off')
set(handles.resetrefinebutton,'Enable','off')
set(handles.realtimecheckbox,'Value',0,'Enable','off')
set(handles.uipanel3,'Visible','on')
set(handles.plotbutton,'Visible','on')
set(handles.idea1_m,'Enable','on')
% clear the uitable2 content
set(handles.uitable2,'Data',{})
% on the rebuilt menu
set(handles.rebuild_menu,'Enable','on')
