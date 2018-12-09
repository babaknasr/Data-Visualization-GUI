function waitfunc(on,reason, handles)

switch on
    case 1
        txt = 'Please wait...';
        switch reason
            case 'import'
                txt = {'Importing data from Excel';'Please wait...'};
            case 'open'
                txt = {'Opening data file';'Please wait...'};
            case 'retrieve'
                txt = {'Retrieving data';'Please wait...'};
            case 'theory calc'
                txt = {'[Theory] Calculating';'Please wait...'};
            case 'rebuilt'
                txt = {'Rebuilding database';'Please wait...'};
            case 'fit'
                txt = {'Fitting cureve';'Please wait...'};
        end %switch
        set(handles.waittext,'String',txt,'Visible','on')
    case 0
        set(handles.waittext,'Visible','off')
end %switch
pause(.001)
