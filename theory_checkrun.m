function theory_checkrun(handles)
global rough_par gsettings funcselection compareexp
if (isempty(funcselection) == 1)
    funcselection = 1;
end %if
if (isempty(rough_par) == 1)
    rough_par.betap = .02;
    rough_par.Deltac = 1;
    rough_par.Nbump = 20;
%     rough_par.n_b = 2;
    rough_par.Rb_Dp = .1;
    rough_par.n_u = 1;
    rough_par.alpha = pi/6;
end %if
lw = gsettings.lwidth;
dmc = gsettings.default_marker_color;
mcolor = {'k','b','r','g','c','m','y',...
    '--k','--b','--r','--g','--c','--m','--y'};
theory.smooth = get(handles.smoothcheckbox,'Value');
theory.rough = get(handles.roughcheckbox,'Value');
theory.rough_bumpy = get(handles.bumpycheckbox,'Value');
theory.sublayer = get(handles.sublayercheckbox,'Value');
theory.burst = get(handles.burstcheckbox,'Value');
theory.jkr = get(handles.jkrcheckbox,'Value');
theory.dmt = get(handles.dmtcheckbox,'Value');
theory.tpl = get(handles.tplcheckbox,'Value');
theory.roll = get(handles.rollingcheckbox,'Value');
theory.slide = get(handles.slidingcheckbox,'Value');
theory.lift = get(handles.liftingcheckbox,'Value');
theory.freevelocity = get(get(handles.velocityuipanel,'SelectedObject'),'String');
theory.Dh = str2double(get(handles.hydraulicdedit,'String'));
theory.roughness.betap = rough_par.betap;
theory.roughness.Deltac = rough_par.Deltac;
theory.roughness.Nbump = rough_par.Nbump;
% theory.roughness.n_b = rough_par.n_b;
theory.roughness.Rb_Dp = rough_par.Rb_Dp;
theory.roughness.n_u = rough_par.n_u;
theory.roughness.alpha = rough_par.alpha;
theory.function = funcselection;
er = 1;
err = {};
err{er} = 'Please consider the following warning(s):';
if ((theory.smooth == 0) && (theory.rough == 0) && (theory.rough_bumpy == 0))
    er = er + 1;
    err{er} = '-Select at least one Surface Type';
end %if
if ((theory.sublayer == 0) && (theory.burst == 0))
    er = er + 1;
    err{er} = '- Select at least one Flow Condition';
end %if
if ((theory.jkr == 0) && (theory.dmt == 0) && (theory.tpl == 0))
    er = er + 1;
    err{er} = '- Select at least one Model';
end %if
if ((theory.roll == 0) && (theory.slide == 0) && (theory.lift == 0))
    er = er + 1;
    err{er} = '- Select at least one Assumption';
end %if
if (get(handles.rangeradiobutton,'Value') == 1)
    theory.minsize = str2double(get(handles.minsizeedit,'String')) * 1e-6;
    theory.maxsize = str2double(get(handles.maxsizeedit,'String')) * 1e-6;
    if (isnan(theory.minsize) == 1)
        er = er + 1;
        err{er} = '- Enter a number for lower limit of size range.';
    elseif (theory.minsize <= 0)
        er = er + 1;
        err{er} = '- Lower limit of size range must be greater than zero.';
    end %if
    if (isnan(theory.maxsize) == 1)
        er = er + 1;
        err{er} = '- Enter a number for upper limit of size range.';
    elseif (theory.maxsize <= 0)
        er = er + 1;
        err{er} = '- Upper limit of size range must be greater than zero.';
    end %if
    if (theory.minsize >= theory.maxsize)
        er = er + 1;
        err{er} = '- Upper limit of size range must be greater than lower limit.';
    end %if
elseif (get(handles.oneradiobutton,'Value') == 1)
    theory.minsize = str2double(get(handles.onesizeedit,'String')) * 1e-6;
    theory.maxsize = theory.minsize;
    if (isnan(theory.minsize) == 1)
        er = er + 1;
        err{er} = '- Enter a number for particle size.';
    elseif (theory.minsize <= 0)
        er = er + 1;
        err{er} = '- Particle size must be greater than zero.';
    end %if
end %if
if (strcmpi(get(handles.hydraulicdedit,'Enable'),'on') == 1)
    if (isnan(theory.Dh) == 1)
        er = er + 1;
        err{er} = '- Enter a number for Channel Hydraulic Diameter.';
    elseif (theory.Dh <= 0)
        er = er + 1;
        err{er} = '- Channel Hydraulic Diameter must be a positive number.';
    end %if
end %if
plist = get(handles.propuitable,'Data');
[pr, prvar] = theory_property();
er2 = 1;
err2 = {};
err2{er2} = 'The following properties are missing:';
for i=1:size(plist,1)
    row = find(strcmpi(pr(:,2),plist{i,2}),1);
    theory.const.(prvar{row}) = plist{i,3};
    if (plist{i,1} == true)
        if (isnan(plist{i,3}) == 1)
            er2 = er2 + 1;
            err2{er2} = ['- ' plist{i,2}];
        elseif (isempty(plist{i,3}) == 1)
            er2 = er2 + 1;
            err2{er2} = ['- ' plist{i,2}];
        else
        end %if
    end %if
end %i
if (er > 1) || (er2 > 1)
    if ((er > 1) && (er2 == 1))
        ertxt = err;
    end %if
    if ((er == 1) && (er2 > 1))
        ertxt = err2;
    end %if
     if ((er > 1) && (er2 > 1))
        ertxt = [err,err2];
    end %if
    msgbox(ertxt,'Warning','warn','modal');
else
    % Clear Axes
    axes(handles.axes1);
    cla(handles.axes1);
    axis auto
    legend('off')
    % Start to calculate
    waitfunc(1,'theory calc', handles)
    % %%%%% calculate K
    theory.const.K = comp_modulus(theory.const.E1,theory.const.nu1,theory.const.E2,theory.const.nu2);
    [Dp, theory_result,models,modes] = theory_calculation(theory);
    
    if (strcmp(theory.freevelocity,'Do not Convert') == 1)
        m2cm = 1e-2;
        yl = 'Critical Shear Velocity (cm/s)';
        velocity = 'Shear Velocity';
    else
        m2cm = 1;
        yl = 'Critical Free stream Velocity (m/s)';
        velocity = 'Free stream Velocity';
    end %if
    if (size(theory_result,2) > 1)
        for i=1:size(theory_result,1)
            hold on
            pl = plot (Dp./1e-6,theory_result(i,:)./m2cm,mcolor{i},'Linewidth',lw);
            if (isempty(strfind(models{i},'Rough')) == 0)
                roughd = [' (\Delta_c=' num2str(theory.roughness.Deltac) ', \beta=' num2str(theory.roughness.betap) 'D_p)'];
                if (isempty(strfind(models{i},'Bumpy')) == 0)
                    roughd = [roughd  ',(N_b=' num2str(theory.roughness.Nbump)...
                        ', R_b=' num2str(theory.roughness.Rb_Dp) 'D_p'...
                        ', n_b=' num2str(1/(theory.roughness.n_u*theory.roughness.Rb_Dp*sqrt(theory.roughness.Nbump))) ')'];
                end %if
            else
                roughd = '';
            end %if
            legend(pl,[models{i} roughd ',' modes{i}])
        end %i
        legend('off')
        if (strcmp(get(handles.xaxislog_m,'Checked'),'on') == 1)
            xscale = 'Log';
        else
            xscale = 'Linear';
        end %if
        if (strcmp(get(handles.yaxislog_m,'Checked'),'on') == 1)
            yscale = 'Log';
        else
            yscale = 'Linear';
        end %if
        set(handles.axes1,'XScale',xscale,'YScale',yscale)
        xlabel('Particle Diameter (\mum)','FontWeight','bold')
        ylabel(yl,'FontWeight','bold')
        legend('show')
        compareexp.Dp = Dp;
        compareexp.velocity = velocity;
        compareexp.m2cm = m2cm;
        set(handles.tcomparepushbutton,'Enable','on')
        waitfunc(0,'theory calc', handles)
        choice = '';
        choice = questdlg('Do you want to compare with experiments?','Database','Yes','No','Yes');
        if (strcmp(choice,'Yes') == 1)
            waitfunc(1,'retrieve', handles)
            [tdb,points,er] = fit_compare(Dp,velocity);
%             points
%             er
            theory_plotexpoints(handles,tdb,points,er)
            waitfunc(0,'retrieve', handles)
        end %if
    elseif (get(handles.oneradiobutton,'Value') == 1)
        waitfunc(0,'theory calc', handles)
        pd = get(handles.onesizeedit,'String');
        txt = {};
        txt{1} = ['For  Dp=' pd ' (' char(0181) 'm), Critical ' yl ' is:'];
        for i=1:length(theory_result)
            txt{i+1} = [models{i} '(' modes{i} ')= ' num2str(theory_result(i)./m2cm)];
        end %i
        msgbox(txt,'Theory Result','none','modal');
    end %if
end %if
waitfunc(0,'theory calc', handles)

