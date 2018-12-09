function legendchanged(changed, handles)
switch changed
    case 1
        set(handles.applychangebutton,'Visible','on')
        set(handles.plotbutton,'Visible','off')
        set(handles.uipanel2,'Visible','off')
    case 0
        set(handles.applychangebutton,'Visible','off')
        set(handles.plotbutton,'Visible','on')
        set(handles.uipanel2,'Visible','on')
end %switch