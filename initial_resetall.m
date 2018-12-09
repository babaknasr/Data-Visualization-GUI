% Reset to initial condition befor starting GUI

function initial_resetall(handles)
global gsettings

%clear axes1
colormap('default')
axes(handles.axes1);
cla(handles.axes1);
set(handles.axes1,'Visible','off','XScale','Linear','YScale','Linear')
set(handles.xlog,'State','off','Enable','off')
set(handles.ylog,'State','off','Enable','off')
set(handles.xaxislog_m,'Checked','off')
set(handles.yaxislog_m,'Checked','off')

%initiate grid
set(handles.axes1,'Xgrid','off','Ygrid','off','Zgrid','off')
set(handles.grid_m,'Checked','off')

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

% set(handles.axes1,'XScale','linear','YScale','linear')
% % % off the log option
% set(handles.xlog,'Value',0,'Visible','on')
% set(handles.ylog,'Value',0,'Visible','on')

% off the marker type legend
set(handles.legendpanel,'Visible','off')
%set(handles.legendtable,'Visible','off')

% off the marker color legend
set(handles.legendpanel2,'Visible','off')
%set(handles.legendtable2,'Visible','off')

% off the marker size legend
set(handles.legendpanel3,'Visible','off')
%set(handles.mintext2,'Visible','off')
%set(handles.maxtext2,'Visible','off')
%set(handles.minedit2,'Visible','off')
%set(handles.maxedit2,'Visible','off')
%set(handles.legendtext2,'Visible','off')

% off the colorbar range legend
set(handles.rangepanel,'Visible','off')
%set(handles.mintext,'Visible','off')
%set(handles.maxtext,'Visible','off')
%set(handles.minedit,'Visible','off')
%set(handles.maxedit,'Visible','off')

% off refine button
% set(handles.refinebutton,'Visible','off')

% off the plot button
set(handles.plotbutton,'Visible','off')

% off the axis panel
set(handles.uipanel3,'Visible','off')


% off original plot panel
set(handles.uipanel1,'Visible','off')


% off the apply changed button
% set(handles.applychangebutton,'Visible','off')

% off the tracer cursor
set(handles.selectpoint,'Enable','off','State','off')

% off table panel
set(handles.uipanel2,'Title','Parameters Included','Visible','off')

% set enable of uitable2
% set(handles.uitable2,'Enable','on')

% set refine checkbox and real-time refinement checkbox
% set(handles.checkboxrefine,'Value',0,'Enable','on')
% set(handles.realtimecheckbox,'Value',0,'Enable','off')

% off the choosepanel
set(handles.choosepanel,'Visible','off')

% off the tools menu
set(handles.tools_menu,'Enable','off')

% off the View Menu
set(handles.view,'Enable','off')

set(handles.axes2,'Visible','on')
axes(handles.axes2)
axis off
box off

% Read General settings
general_settings(0,handles)
% Check for update when the program start
[needupdate, local_ver, server_ver] = gui_checkupdate(gsettings);

addmsg = {['Version: ', local_ver]};
switch needupdate
    case 1
        addmsg = [addmsg; {' '; ['New Version Available: ', server_ver]}];
    case -1
       addmsg = [addmsg; {' '; 'Unable to check for update!'}];
end %switch (needupdate)

try
%     im = imread('http://www.clarkson.edu/identity/images/formats/engineering_green.jpg');
%     imshow(im,'Parent',handles.axes2)
    text(0,1000,[gsettings.initial_msg; addmsg])
catch err
    cla
    disp(err)
    set(handles.axes2,'Visible','off')
end %try
