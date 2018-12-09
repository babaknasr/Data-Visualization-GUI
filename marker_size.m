function [sizerange, nodatasize] = marker_size()
global gsettings

% sizerange = 6:.5:20;
% nodatasize = 5;
sizerange = gsettings.marker_sizerange;
nodatasize = gsettings.novalue_marker_size;