% Identify GUI version number
function [ver_no,ver_m] = gui_ver()
main_ver = '1';
y = '2018'; % year
m = '03'; % month
d = '04'; % day
ver_no = [main_ver, '.',d ,m , y]; % ver.ddmmyyyy
m0 = 'Particle Resuspension GUI';
m1 = 'Visualization & Analysis';
m2 = 'Developer: Babak Nasr';
m3 = ['Version: ', ver_no];
m4 = [char(169), ' ', y, ' DTRA & CU AIR Lab All Rights Reserved.'];
ver_m = {m0;m1;m2;m3};
