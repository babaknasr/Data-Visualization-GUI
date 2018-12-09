% w : 0 or somthing else
%  0 means initial condition

function general_settings(w,handles)
global gsettings
cpath = getcurrentdir();
if (w == 0)
    try
        load([cpath '\settings.dat'],'-mat','gsettings');
    catch
        gsettings.URL = 'http://web2.clarkson.edu/projects/airlab/software/resuspension_gui/index.html';
        gsettings.ver_URL = 'http://web2.clarkson.edu/projects/airlab/software/resuspension_gui/app_ver.txt';
        gsettings.initial_msg = {...
            'Particle Resuspension GUI';...
            'Visualization & Analysis';...
            'Developed by Clarkson University-AIR Lab';...
            'Defense Threat Reduction Agency (DTRA)';...
            'Grant#: HDTRA1-14-C-0009';...
            };
        
        gsettings.marker_type = {};
        gsettings.default_marker_type = 'Circle';
        gsettings.novalue_marker_type = 'Cross';
        gsettings.marker_color = {};
        gsettings.default_marker_color = 'Blue';
        gsettings.novalue_marker_color = 'Gray';
        gsettings.marker_sizerange = 6:.5:20;
        gsettings.novalue_marker_size = 4;
        gsettings.lwidth = 2;
        gsettings.novalue_lwidth = 1;
        gsettings.markerfill = 0;
        gsettings.qtyrl = 1;
        gsettings.qlyrl = 0;
        save([cpath '\settings.dat'],'gsettings')
    end %try
else
    save([cpath '\settings.dat'],'gsettings')
end %if

switch gsettings.markerfill
    case 1
        set(handles.filled,'Checked','on');
    case 0
        set(handles.filled,'Checked','off');
end %switch
switch gsettings.qtyrl
    case 1
        set(handles.qtylegrev,'Checked','on')
    case 0
        set(handles.qtylegrev,'Checked','off')
end %switch
switch gsettings.qlyrl
    case 1
        set(handles.qlylegrev,'Checked','on')
    case 0
        set(handles.qlylegrev,'Checked','off')
end %switch
