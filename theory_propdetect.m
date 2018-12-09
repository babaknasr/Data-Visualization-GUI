function theory_propdetect(handles)
currentp = get(handles.propuitable,'Data');
if (get(handles.tplcheckbox,'Value') == 1)
    row = find(strcmpi(currentp(:,2),'[Contact] Hamaker Constant (J)'),1);
    currentp{row,1} = true;
    row = find(strcmpi(currentp(:,2),'[Contact] Minimum Separation Distance z0 (m)'),1);
    currentp{row,1} = true;
else
    row = find(strcmpi(currentp(:,2),'[Contact] Hamaker Constant (J)'),1);
    currentp{row,1} = false;
    row = find(strcmpi(currentp(:,2),'[Contact] Minimum Separation Distance z0 (m)'),1);
    currentp{row,1} = false;
end %if
if (get(handles.slidingcheckbox,'Value') == 1)
    row = find(strcmpi(currentp(:,2),'[Contact] Static Friction Coefficient'),1);
    currentp{row,1} = true;
else
    row = find(strcmpi(currentp(:,2),'[Contact] Static Friction Coefficient'),1);
    currentp{row,1} = false;
end %if
if (get(handles.mediumradiobutton2,'Value') == 1)
    row = find(strcmpi(currentp(:,2),'[Medium] Density {std. cond.} (kg/m3)'),1);
    currentp{row,1} = true;
    row = find(strcmpi(currentp(:,2),'[Medium] Dynamic Viscosity {std. cond.} (Pa.s)'),1);
    currentp{row,1} = true;
    row = find(strcmpi(currentp(:,2),'[Medium] Gas mean-free path {std. cond.} (m)'),1);
    currentp{row,1} = true;
else
    row = find(strcmpi(currentp(:,2),'[Medium] Density {std. cond.} (kg/m3)'),1);
    currentp{row,1} = false;
    currentp{row,3} = 1.225;
    row = find(strcmpi(currentp(:,2),'[Medium] Dynamic Viscosity {std. cond.} (Pa.s)'),1);
    currentp{row,1} = false;
    currentp{row,3} = 1.79e-5;
    row = find(strcmpi(currentp(:,2),'[Medium] Gas mean-free path {std. cond.} (m)'),1);
    currentp{row,1} = false;
    currentp{row,3} = .066e-6;
end %if
set(handles.propuitable,'ColumnFormat',{'logical','char','numeric'},...
    'ColumnWidth',{20,230,80},'ColumnName',{'','Property','Value'},...
    'ColumnEditable',[false,false,true],'Data',currentp)

