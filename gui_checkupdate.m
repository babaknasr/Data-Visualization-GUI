% Chcekc if the GUI is the latest version
% needupdate = 
%              0 : It's the latest verion
%              1 : update is available
%             -1 : couldn't check for update

function [needupdate, local_ver_no, server_ver_no]  = gui_checkupdate(Source)
needupdate = 0;
server_ver_no = NaN;
URL = Source.URL;
ver_URL = Source.ver_URL;

% get local version
local_ver_no = gui_ver()
ver_string = strsplit(local_ver_no,'.');
main_ver = str2num(ver_string{1});
date_ver = datenum(ver_string{2},'ddmmyyyy');

% get server version (current version)
try 
    server_ver_no = webread(ver_URL)
    server_ver_no = strrep(server_ver_no,sprintf('\n'),'');
    ver_string_cur = strsplit(server_ver_no,'.');
    main_ver_cur = str2num(ver_string_cur{1});
    date_ver_cur = datenum(ver_string_cur{2},'ddmmyyyy');
    % check if update is required
    if (main_ver_cur > main_ver) || (date_ver_cur > date_ver)
        needupdate = 1;
    end %if
    
    
catch
    % if can not open the URL return -1
    needupdate = -1;
end %try
