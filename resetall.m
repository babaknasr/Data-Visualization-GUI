function resetall(handles)

% Clear plot
colormap('default')
axes(handles.axes1);
cla(handles.axes1);
axis auto
title('')
xlabel('')
ylabel('')
legend('off')
colorbar('hide')

% set(handles.axes1,'XScale','linear','YScale','linear')
% % off the log option
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

% on the plot button
set(handles.plotbutton,'Visible','on')

% off the apply changed button
set(handles.applychangebutton,'Visible','off')

% off the tracer cursor
set(handles.selectpoint,'Enable','on','State','off')

% reset table title and visibility
set(handles.uipanel2,'Title','Parameters Included','Visible','on')

% set enable of uitable2
set(handles.uitable2,'Enable','on')

% set refine checkbox and real-time refinement checkbox
% set(handles.checkboxrefine,'Value',0,'Enable','on')
% set(handles.realtimecheckbox,'Value',0,'Enable','off')

% off the choosepanel
set(handles.choosepanel,'Visible','off')
