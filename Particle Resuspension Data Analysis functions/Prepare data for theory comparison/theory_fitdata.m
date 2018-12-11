function [tdb, points, er] = theory_fitdata(tdb,velocity)
global fit_iserplot fit_isweibull fit_ask2choose

% fit_isweibull = 0;
if (isempty(fit_iserplot) == 1)
    erplot = 1; % Sensor to plot error
else
    erplot = fit_iserplot;
end %if
if (isempty(fit_isweibull) == 1)
    isweibull = 1;
else
    isweibull = fit_isweibull;
end %if
if (isempty(fit_ask2choose) == 1)
    ask2choose = 1;
else
    ask2choose = fit_ask2choose;
end %if


points = [];
er = [];
ilim = 0;
i = 0;
j = 0;
while (i < size(tdb,1))
    convert = 0;
    i = i + 1;
    indps = find(strcmpi(tdb{i,3}{1}(1,:),'Particle Size') == 1,1);
    dfind = find(strcmpi(tdb{i,2}(1,:),'Detachment Fraction') == 1,1);
    velind = find(strcmpi(tdb{i,2}(1,:),velocity) == 1,1);
    df = cell2mat(tdb{i,2}(2:end,dfind));
    vel = cell2mat(tdb{i,2}(2:end,velind));
    if ((strcmpi(velocity,'Shear Velocity') == 1) && (all(isnan(vel)) == 1))
        velind = find(strcmpi(tdb{i,2}(1,:),'Free stream Velocity') == 1,1);
        f2sind = find(strcmpi(tdb{i,2}(1,:),'free2shear') == 1,1);
        convert = 1;
        vel = cell2mat(tdb{i,2}(2:end,velind));
    end %if
    if ((length(df) > 2) && (range(vel) ~= 0))
        disp([num2str(i) ': ' tdb{i,1}]) %<<<<<<<<< DISP >>>>>>>>>>>>
        parametersg.x = vel;
        parametersg.y = df;
        
        parametersw.x = vel;
        parametersw.y = df;
        [parametersg.mulimit, parametersg.sigmalimit, parametersg.mustep, parametersg.sigmastep] = fit_limits('gauss',vel,df);
        sigma0 = (parametersg.sigmalimit(1) + parametersg.sigmalimit(2))/2;
        mu0 = (parametersg.mulimit(1) + parametersg.mulimit(2))/2;
%         parameters.mustep = .5;
%         parameters.sigmastep = .5;
        if (ilim == 1)
            if exist('parnorm','var') && ~isempty(parnorm)
                t1 = num2str(parnorm(1));
            else
                t1 = '';
            end %if
            if exist('pparg','var') && ~isempty(pparg)
                t2 = num2str((pparg.mulimit(2)-pparg.mulimit(1))/2);
                t3 = num2str(parnorm(2));
                t4 = num2str((pparg.sigmalimit(2)-pparg.sigmalimit(1))/2);
                t5 = num2str(int32((pparg.mulimit(2)-pparg.mulimit(1))/pparg.mustep));
                t6 = num2str(int32((pparg.sigmalimit(2)-pparg.sigmalimit(1))/pparg.sigmastep));
            else
                t1 = '';t2 = '';t3 = '';t4 = '';t5 = '';t6 = '';
            end %if
            inpg = inputdlg({'Gaussian:Enter estimated \mu :','\mu Range (Delta_\mu):','Estimated \sigma:','\sigma Range (Delta_\sigma):','\mu number of steps:','\sigma number of steps:'},...
                'Estimation parameters: Gaussian',1,...
                {t1,t2,t3,t4,t5,t6});
%             inpl = inputdlg({'Lognormal:Enter estimated \mu :','\mu Range (Delta_\mu):','Estimated \sigma:','\sigma Range (Delta_\sigma):','\mu number of steps:','\sigma number of steps:'},...
%                 'Estimation parameters: Lognormal',1,...
%                 {num2str(parlog(1)),num2str((pparl.mulimit(2)-pparl.mulimit(1))/2),num2str(parlog(2)),num2str((pparl.sigmalimit(2)-pparl.sigmalimit(1))/2),num2str(int32((pparl.mulimit(2)-pparl.mulimit(1))/pparl.mustep)),num2str(int32((pparl.sigmalimit(2)-pparl.sigmalimit(1))/pparl.sigmastep))});
            try
                delete(fit_hand0.figg);
                delete(fig_er_g);
                delete(fig_er_l);
                delete(fig_er_w);
            catch errr
                disp(errr)
                
            end %try
            if (isempty(inpg) == 0)
                inpg = cellfun(@str2double,inpg);
                sigma0 = inpg(3);
                mu0 = inpg(1);
                parametersg.sigmalimit(1) = inpg(3) - inpg(4);
                parametersg.sigmalimit(2) = inpg(3) + inpg(4);
                parametersg.mulimit(1) = inpg(1) - inpg(2);
                parametersg.mulimit(2) = inpg(1) + inpg(2);
                parametersg.mustep = (parametersg.mulimit(2) - parametersg.mulimit(1))/inpg(5);
                parametersg.sigmastep = (parametersg.sigmalimit(2) - parametersg.sigmalimit(1))/inpg(6);
            else
                ilim = 0;
                continue;
            end %if
        end %if
        xgrid = linspace(min(vel),max(vel),1000);
        % Gaussian
        try
            [parnorm, er_g] = fit_norm('gauss',parametersg);
            pparg = parametersg;
            tempmu = parametersg.mulimit(1):parametersg.mustep:parametersg.mulimit(2);
            i_mu = find(abs(tempmu-mu0) == min(abs(tempmu-mu0)),1);
            tempsigma = parametersg.sigmalimit(1):parametersg.sigmastep:parametersg.sigmalimit(2);
            i_sigma = find(abs(tempsigma-sigma0) == min(abs(tempsigma-sigma0)),1);
            fee = i_mu*length(tempsigma) + i_sigma;
            if (erplot == 1)
                fig_er_g = figure('name','Errors: Gaussian');
                hold on
                plot(er_g.norm2)
                plot(fee,er_g.norm2(fee),'or','MarkerFaceColor','m')
                plot(find(er_g.norm2 == min(er_g.norm2),1),min(er_g.norm2),'xg','MarkerSize',8,'LineWidth',2)
                hold off
                title({'Gaussian fit - L2 norm error';['Minimum error occurred in: \mu=' num2str(parnorm(1)) ' ,  \sigma=' num2str(parnorm(2))]})
                ylabel('L2 norm error')
            end %if
            pnorm = normcdf(xgrid,parnorm(1),parnorm(2));
        catch err
            disp('     ...Error: Gaussian fit is terminated');
            disp(err);
            assignin('base','err',err);
            parnorm = [];
            er_g.norm2 = NaN;
        end %try
        % Lognormal
        try
        [parlog, er_l] = fit_norm('log',parametersg);
        if (erplot == 1)
            fig_er_l = figure('name','Errors: Lognormal');
            plot(er_l.norm2)
            title({'Lognormal fit - L2 norm error';['Minimum error occurred in: \mu=' num2str(parlog(1)) ' ,  \sigma=' num2str(parlog(2))]})
            ylabel('L2 norm error')
        end %if
        plog = logncdf(xgrid,parlog(1),parlog(2));
        catch err
            disp('     ...Error: Lognormal fit is terminated');
            disp(err);
            assignin('base','err',err);
            parlog = [];
            er_l.norm2 = NaN;
        end %try
        % Weibull
        parwb = [];
        er_w.norm2 = [];
        if (isweibull == 1)
            try
            [parametersw.mulimit, parametersw.sigmalimit, parametersw.mustep, parametersw.sigmastep] = fit_limits('weibull',vel,df);
            [parwb, er_w] = fit_norm('weibull',parametersw);
            if (erplot == 1)
                fig_er_w = figure('name','Errors:Weibull');
                plot(er_w.norm2)
                title({'Weibull fit - L2 norm error';['Minimum error occurred in: a=' num2str(parwb(1)) ' ,  b=' num2str(parwb(2))]})
                ylabel('L2 norm error')
            end %if
            pwbl = wblcdf(xgrid,parwb(1),parwb(2));
            catch err
                disp('     ...Error: Weibull fit is terminated');
                disp(err);
                assignin('base','err',err);
                parwb = [];
                er_w.norm2 = NaN;
            end %try
        end %if
        
        if ((isempty(parnorm) == 1) && (isempty(parlog) == 1) && (isempty(parwb) == 1))
            continue;
        end %if
        
        fit_hand0.figg = figure('Name',tdb{i,1});
        pl = plot(vel,df,'ok');
        legend(pl,'Data');
        choice = {};
        tempfit = tdb(i,:);
        tempfit{1,4}(1,:) = {tdb{i,2}{1,velind},[], []};
        hold on
        if (isempty(parnorm) == 0)
            fitname = 'Gaussian';
            pl = plot(xgrid,pnorm,'--r');
            legend(pl,[fitname ': (\mu=' num2str(parnorm(1)) ', \sigma=' num2str(parnorm(2)) ')']);
            choice{end+1} = fitname;
            tempfit{1,4}(end+1,:) = {fitname, parnorm, min(er_g.norm2)};
        end %if
        if (isempty(parlog) == 0)
            fitname = 'Lognormal';
            pl = plot(xgrid,plog,'--b');
            legend(pl,[fitname ': (\mu=' num2str(parlog(1)) ', \sigma=' num2str(parlog(2)) ')']);
            choice{end+1} = fitname;
            tempfit{1,4}(end+1,:) = {fitname, parlog, min(er_l.norm2)};
        end %if
        if (isempty(parwb) == 0)
            fitname = 'Weibull';
            pl = plot(xgrid,pwbl,'--c');
            legend(pl,[fitname ': (a=' num2str(parwb(1)) ', b=' num2str(parwb(2)) ')']);
            choice{end+1} = fitname;
            tempfit{1,4}(end+1,:) = {fitname, parwb, min(er_w.norm2)};
        end %if
        hold off
        fit_hand0.checkbox1 = uicontrol('Style', 'Checkbox',...
            'String','Full Distribution','Value',0,...
            'Position', [400 399 100 20],...
            'Callback',{@fit0_checkbox1,tempfit});
        
        choice = [choice, {'[Refit manually]','[Ignore]'}];
        legend('Location','SouthEast');
        title({'','',tdb{i,1}})
        xlabel(tdb{i,2}{1,velind})
        ylabel(tdb{i,2}{1,dfind})
        ers = [min(er_g.norm2) min(er_l.norm2) min(er_w.norm2)];
        bestdi = find(ers == min(ers),1);
        switch bestdi
            case 1
                bestd = 'Gaussian';
            case 2
                bestd = 'Lognormal';
            case 3
                bestd = 'Weibull';
        end %switch
        fit_choice = find(strcmpi(choice,bestd),1);
        if (ask2choose == 1)
            fit_choice = menu({'Select the appropriate comulative distribution fit';['"' bestd '" Distribution has minimum error']},...
                choice);
        end %if
        if (erplot == 1)
            try
                delete(fig_er_g);
                delete(fig_er_l);
                delete(fig_er_w);
            catch err
                
            end %try
        end %if
        if (fit_choice ~= 0)
            choice_str = choice{fit_choice};
        else
            choice_str = '[Ignore]';
        end %if
        switch choice_str
            case 'Gaussian'
                fitname = choice_str;
                [uth,uthd,uthu] = fit_expvelpoint(fitname,parnorm);
            case 'Lognormal'
                fitname = choice_str;
                [uth,uthd,uthu] = fit_expvelpoint(fitname,parlog);
            case 'Weibull'
                fitname = choice_str;
                [uth,uthd,uthu] = fit_expvelpoint(fitname,parwb);
            case '[Refit manually]'
                ilim = 1;
                i = i - 1;
                continue;
            case '[Ignore]'
                ilim = 0;
                tdb(i,:) = [];
                i = i - 1;
                try
                    delete(fit_hand0.figg);
                catch err
                    
                end %try
                continue;
        end %if
        try
            delete(fit_hand0.figg);
        catch err
            
        end %try
        j = j + 1;
        tdb{i,4}(1,:) = {tdb{i,2}{1,velind}, [], []};
        tdb{i,4}(end+1,:) = {'Gaussian', parnorm, min(er_g.norm2)};
        tdb{i,4}(end+1,:) = {'Lognormal', parlog, min(er_l.norm2)};
        tdb{i,4}(end+1,:) = {'Weibull', parwb, min(er_w.norm2)};
        tdb{i,4}(end+1,:) = {'Best', fitname, []};
        psr = cellfun(@str2double,tdb{i,3}{1}(2:end,indps));
        ps = mean(psr);
        points(j,1) = ps;
        uth2 = uth;
        uthd2 = uthd;
        uthu2 = uthu;
        if (convert == 1)
            disp('converted')
            ref = tdb{i,2}{2,f2sind}{1};
            cpar = tdb{i,2}{2,f2sind}{2};
            uth2 = fit_free2shear(uth,ref,cpar);
            uthd2 = fit_free2shear(uthd,ref,cpar);
            uthu2 = fit_free2shear(uthu,ref,cpar);
        end %if
        points(j,2) = uth2;
        points(j,3) = i;
        er(j,1) = uth2 - uthd2;
        er(j,2) = uthu2 - uth2;
    end %if
    ilim = 0;
end %while i


% **********
function fit0_checkbox1(hObj,event,tdb)
switch get(hObj,'Value')
    case 0
        minmax = [];        
    case 1
        minmax = [1e-3,1-1e-3];
end %switch
row = 1;
dfind = find(strcmpi(tdb{row,2}(1,:),'Detachment Fraction') == 1,1);
velocity = tdb{row,4}{1,1};
velind = find(strcmpi(tdb{row,2}(1,:),velocity) == 1,1);
vel = cell2mat(tdb{row,2}(2:end,velind));
df = cell2mat(tdb{row,2}(2:end,dfind));
pl = plot(vel,df,'ok');
legend(pl,'Data')
hold on
for i=1:size(tdb{row,4},1)
    if (isempty(tdb{row,4}{i,2}) == 0)
        switch tdb{row,4}{i,1}
            case {'Gaussian','gaussian','Normal','normal'}
                mu = tdb{row,4}{i,2}(1);
                sigma = tdb{row,4}{i,2}(2);
                if (isempty(minmax) == 0)
                    minv = norminv(minmax(1),mu,sigma);
                    if (minv < 0)
                        minv = 0;
                    end %if
                    maxv = norminv(minmax(2),mu,sigma);
                else
                    minv = min(vel);
                    maxv = max(vel);
                end %if
                xgrid = linspace(minv,maxv,1000);
                distfit = normcdf(xgrid,mu,sigma);
                pl = plot(xgrid,distfit,'--r');
                legend(pl,['Gaussian: (\mu=' num2str(mu) ', \sigma=' num2str(sigma) ')'])
            case {'Lognormal','lognormal'}
                mu = tdb{row,4}{i,2}(1);
                sigma = tdb{row,4}{i,2}(2);
                if (isempty(minmax) == 0)
                    minv = logninv(minmax(1),mu,sigma);
                    if (minv < 0)
                        minv = 0;
                    end %if
                    maxv = logninv(minmax(2),mu,sigma);
                else
                    minv = min(vel);
                    maxv = max(vel);
                end %if
                xgrid = linspace(minv,maxv,1000);
                distfit = logncdf(xgrid,mu,sigma);
                pl = plot(xgrid,distfit,'--b');
                legend(pl,['Lognormal: (\mu=' num2str(mu) ', \sigma=' num2str(sigma) ')'])
            case {'Weibull','weibull'}
                a = tdb{row,4}{i,2}(1);
                b = tdb{row,4}{i,2}(2);
                if (isempty(minmax) == 0)
                    minv = wblinv(minmax(1),a,b);
                    if (minv < 0)
                        minv = 0;
                    end %if
                    maxv = wblinv(minmax(2),a,b);
                else
                    minv = min(vel);
                    maxv = max(vel);
                end %if
                xgrid = linspace(minv,maxv,1000);
                distfit = wblcdf(xgrid,a,b);
                pl = plot(xgrid,distfit,'--c');
                legend(pl,['Weibull: (a=' num2str(a) ', b=' num2str(b) ')'])      
        end %switch
    end %if
end %i
hold off
title({'';'';tdb{row,1}});
xlabel(tdb{row,2}{1,velind});
ylabel(tdb{row,2}{1,dfind});
legend('off');
legend('show');
legend('Location','SouthEast');

