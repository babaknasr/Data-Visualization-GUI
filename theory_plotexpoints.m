function theory_plotexpoints(handles,tdb,points,er)
global gsettings compareexp
m2cm = compareexp.m2cm;
 lw = gsettings.lwidth;
% lw = 1;
dmc = gsettings.default_marker_color;
if (iscell(tdb) == 1)
    axes(handles.axes1)
    for i=1:size(points,1)
        hold on
        [mt, ~] = marker_type(tdb(:,1), i);
        pldp = errorbar(points(i,1),points(i,2)./m2cm,er(i,1)./m2cm,er(i,2)./m2cm,mt,'MarkerEdgeColor',dmc,'Linewidth',lw);
%        pldp = scatter(points(i,1),points(i,2)./m2cm,mt,'MarkerEdgeColor',dmc,'Linewidth',lw);
        legend(pldp,tdb{points(i,3),1})
    end %i
    legend('off')
    legend('show')
end %if
