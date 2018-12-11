% Dp unit should be 'meter'
function [tdb,points,er] = fit_compare(Dp, velocity)
global fit_isplotallfits fit_ask2save fit_select fit_defaultpath ...
    fit_menuchoice
if (isempty(fit_isplotallfits) == 1)
    isplotallfits = 1;
else
    isplotallfits = fit_isplotallfits;
end %if
if isempty(fit_select)
    fitselect = 'Best';
else
    fitselect = fit_select;
end %if
if isempty(fit_defaultpath)
    defaultpath = '';
else
    defaultpath = fit_defaultpath;
end;
% Dp = compareexp.Dp;
% velocity = compareexp.velocity;
points = [];
er = [];
if isempty(fit_menuchoice)
    fmenu = menu('Select the option:',{'Find in current database','Load fitted data'});
else
    fmenu = fit_menuchoice;
end %if
switch fmenu
    case 0  % no selection
        tdb = -1;
        return;
    case 1  % Current Database
        if (isempty(fit_ask2save) == 1)
            ask2save = 1;
        else
            ask2save = fit_ask2save;
        end %if
%         Dp = compareexp.Dp;
%         velocity = compareexp.velocity;
        tdb = theory_findindatabase(Dp./1e-6,velocity);
        if (iscell(tdb) == 1)
            [tdb, points, er] = theory_fitdata(tdb,velocity);
            if (size(tdb,2) < 4)
                tdb = -2;
                return;
            end %if
            selection = 1:1:size(tdb,1);
%             j = 0;
%             for i=1:size(tdb,1)
%                 if (isempty(tdb{i,4}) == 0)
%                     j = j + 1;
%                     selection(j) = j;
%                 end %if
%             end %i
        else
            return;
        end %if
        if (ask2save == 1)
            choice = questdlg('Would you like a to save the data in a file?',...
                'Fitted data','Yes','No','No');
            switch choice
                case 'Yes'          
                    filepath = uigetdir(pwd,'Please select folder to save data');
                    globtdb = fit_separatedata(tdb);
                    fit_savefile(globtdb,filepath);
                     
%                     [file,path] = uiputfile('*.mat','Save fitted data');
%                     if (file ~= 0)
%                         file = [path,file];
%                         save(file,'tdb','-mat');
%                     end %if
                    
                case 'No'
                    filepath = [];
            end %switch
        end %if

    case 2  % Load database
        [filename,filepath] = uigetfile([defaultpath '*.mat'],...
            'Select the MATLAB .mat file','MultiSelect','on');        
        if ~strcmpi(class(filename),'double')
            filename = cellstr(filename);
            tdb = {};
            try
            for k=1:length(filename)
                file = [filepath,filename{k}];
                vars = whos('-file',file);
                if ismember('tdb',{vars.name})
                    temp = load(file,'-mat','tdb');
                    stind = size(tdb,1) + 1;
                    endind = size(temp.tdb,1) + stind - 1;
                    tdb(stind:endind,:) = temp.tdb;
                else
%                     error('file is not valid: %s',filename{k});
                    disp(['file is not valid: ',filename{k}]);
                end %if
%                 load(file,'-mat','tdb')
%                 if ((exist('tdb','var') == 0))
%                     mssg = msgbox('The selected file is not valid.',...
%                         'Wrong file','error','modal');
%                     waitfor(mssg);
%                     tdb = -2;
%                     return;
%                 end %if
            end %k
% Check the records in the Dp range
            if ~isempty(Dp)
                tdbtemp = {};
                j = 0;
                for i=1:size(tdb,1)
                    indps = find(strcmpi(tdb{i,3}{1}(1,:),'Particle Size'),1);
                    psr = cellfun(@str2double,tdb{i,3}{1}(2:end,indps));
                    ps = mean(psr)*1e-6;
                    if ((ps >= min(Dp)) && (ps <= max(Dp)))
                        j = j + 1;
                        tdbtemp(j,:) = tdb(i,:);
                    end %if
                end %i
                tdb = tdbtemp;
            end %if
                [selection,ok] = listdlg('Name','Database Materials',...
                    'PromptString',{'Please select matched materials from available data',...
                    'in selected particle size range', 'Particle - Substrate',...
                    'hold Ctrl for multiple choices'},'SelectionMode','multi',...
                    'ListString',tdb(:,1),'ListSize',[400 200]);
%                 [indps,~] = detect('Particle Size');
                j = 0;
                if (ok == 1)
                    if (size(tdb,2) < 4)
                        tdb = -2;
                        mssg = msgbox('No fitted data found','No data','warn','modal');
                        waitfor(mssg);
                        return;
                    end %if
                    for i=selection
                        convert = 0;
                        indps = find(strcmpi(tdb{i,3}{1}(1,:),'Particle Size') == 1,1);
                        if (isempty(tdb{i,4}) == 0)
                            if ((strcmpi(velocity,'Shear Velocity') == 1) &&...
                                    (strcmpi(tdb{i,4}{1,1},'Free stream Velocity') == 1))
                                f2sind = find(strcmpi(tdb{i,2}(1,:),'free2shear') == 1,1);
                                convert = 1;
                            end %if
                            % !!!!!!!!!!
                            
                            fitname = tdb{i,4}{find(strcmpi(tdb{i,4}(:,1),'Best') == 1,1),2};
                            if (isempty(fitname) == 0)
                                if ~strcmpi(fitselect,'Best')
                                    fitname = fitselect;
                                end %if
                                j = j + 1;
                                par = tdb{i,4}{find(strcmpi(tdb{i,4}(:,1),fitname) == 1,1),2};
                                [uth, uthd, uthu] = fit_expvelpoint(fitname,par);
                                psr = cellfun(@str2double,tdb{i,3}{1}(2:end,indps));
                                ps = mean(psr);
                                uth2 = uth;
                                uthd2 = uthd;
                                uthu2 = uthu;
                                if (convert == 1)
                                    ref = tdb{i,2}{2,f2sind}{1};
                                    cpar = tdb{i,2}{2,f2sind}{2};
                                    disp(['converted by:', ref, ...
                                        ', parameters:' num2str(cpar)]);
                                    uth2 = fit_free2shear(uth,ref,cpar);
                                    uthd2 = fit_free2shear(uthd,ref,cpar);
                                    uthu2 = fit_free2shear(uthu,ref,cpar);
                                end %if
                                points(j,1) = ps;
                                points(j,2) = uth2;
                                points(j,3) = i;
                                er(j,1) = uth2 - uthd2;
                                er(j,2) = uthu2 - uth2;
                            end %if
                        end %if
                    end %i
                else
                    tdb = -2;
                    return;
                end %if
            catch errr
                assignin('base','errr',errr);
                mssg = msgbox('The selected file is not valid or another error!',...
                    'Error','error','modal');
                disp(errr)
                
                waitfor(mssg);
                tdb = -2;
                return;
            end %try
        else
            tdb = -2;
            return;
        end %if
end %switch
assignin('base','tdb',tdb);
% what if selection is 0: I think it ignored before it reach here.
tdb2 = tdb(selection,:);

if (isplotallfits == 1)
    fit_hand.figg = figure('Name','Fits');
    fit_hand.popup1 = uicontrol('Style', 'popup',...
       'String', tdb2(:,1),...
       'Position', [5 7 150 20]);
    len = length(tdb2(:,1));
    if (len > 1)
        lenp = len - 1;
        fit_hand.slider1 = uicontrol('Style', 'slider',...
            'Min',1,'Max',len,'Value',1,...
            'SliderStep',[1/lenp 1/lenp],...
            'Position', [170 5 150 20]);
    end %if
    fit_hand.checkbox1 = uicontrol('Style', 'Checkbox',...
        'String','Full Distribution','Value',0,...
        'Position', [350 5 95 20]);
    if (isempty(filepath) == 0)
        fit_hand.exbutton = uicontrol('Style', 'pushbutton',...
            'String','Exclude',...
            'Position',[490,5,70,22]);
    end %if
    minmax = [];
    set(fit_hand.popup1,'Callback', {@fit_selectfit,fit_hand,tdb2,minmax});
    if (len > 1)
        set(fit_hand.slider1,'Callback', {@fit_slider1,fit_hand,tdb2});
    end %if
    set(fit_hand.checkbox1,'Callback',{@fit_checkbox1,fit_hand,tdb2})
    if (isempty(filepath) == 0)
        set(fit_hand.exbutton,'Visible','off',...
            'Callback',{@fit_excludebutton,fit_hand,tdb2,tdb,selection,filepath})
    end %if
    
    fit_selectfit([],[],fit_hand,tdb2,minmax)
end %if



% *******************
function fit_selectfit(hObj,event,fit_hand,tdb,minmax)
if (isempty(minmax) == 1)
    set(fit_hand.checkbox1,'Value',0);
end %if
glw = 1;
llw = 1;
wlw = 1;
row = get(fit_hand.popup1,'Value');
dfind = find(strcmpi(tdb{row,2}(1,:),'Detachment Fraction') == 1,1);
velocity = tdb{row,4}{1,1};
velind = find(strcmpi(tdb{row,2}(1,:),velocity) == 1,1);
vel = cell2mat(tdb{row,2}(2:end,velind));
df = cell2mat(tdb{row,2}(2:end,dfind));
pl = plot(vel,df,'ok','LineWidth',2);
legend(pl,'Data')
if (isfield(fit_hand,'exbutton') == 1)
    set(fit_hand.exbutton,'Visible','off');
end %if
if (isempty(tdb{row,4}) == 0)
    hold on
    best = find(strcmpi(tdb{row,4}(:,1),'Best') == 1,1);
    if (isempty(tdb{row,4}{best,2}) == 0)
        switch tdb{row,4}{best,2}
            case {'Gaussian','gaussian','Normal','normal'}
                glw = 2.5;
            case {'Lognormal','lognormal'}
                llw = 2.5;
            case {'Weibull','weibull'}
                wlw = 2.5;
        end %switch
    end %if
    if (isfield(fit_hand,'exbutton') == 1)
        if (isempty(tdb{row,4}{best,2}) == 0)
            set(fit_hand.exbutton,'Visible','on');
        else
            set(fit_hand.exbutton,'Visible','off');
        end %if
    end %if
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
                    pl = plot(xgrid,distfit,'--r','LineWidth',glw);
                    legend(pl,['Gaussian: (\mu=' num2str(mu) ...
                        ', \sigma=' num2str(sigma) ')'])
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
                    pl = plot(xgrid,distfit,'--b','LineWidth',llw);
                    legend(pl,['Lognormal: (\mu=' num2str(mu) ...
                        ', \sigma=' num2str(sigma) ')'])
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
                    pl = plot(xgrid,distfit,'--c','LineWidth',wlw);
                    legend(pl,['Weibull: (a=' num2str(a) ', b=' num2str(b) ')'])      
            end %switch
        end %if
    end %i
    hold off
end %if 
title({num2str(row);tdb{row,1}});
xlabel({tdb{row,2}{1,velind};'';''});
ylabel(tdb{row,2}{1,dfind});
legend('off');
legend('show');
legend('Location','SouthEast');
if (size(tdb,1) > 1)
    set(fit_hand.slider1,'Value',row);
end % if


%
function fit_slider1(hObj,event,fit_hand,tdb)
row = int32(get(hObj,'Value'));
set(fit_hand.popup1,'Value',row);
fit_selectfit([],[],fit_hand,tdb,[])

% 
function fit_checkbox1(hObj,event,fit_hand,tdb)
switch get(hObj,'Value')
    case 0
        minmax = [];        
    case 1
        minmax = [1e-3,1-1e-3];
end %switch
fit_selectfit([],[],fit_hand,tdb,minmax)

%
function fit_excludebutton(hObj,event,fit_hand,tdb2,tdb,selection,filepath)
row = get(fit_hand.popup1,'Value');
rowtdb = find(strcmp(tdb(:,1),tdb2{row,1}) == 1);
best = find(strcmpi(tdb{rowtdb,4}(:,1),'Best') == 1,1);
tdb2{row,4}{best,2} = [];
assignin('base','tdb2',tdb2)
tdb{rowtdb,4}{best,2} = [];

len = length(tdb2(:,1));
minmax = [];
set(fit_hand.popup1,'Callback', {@fit_selectfit,fit_hand,tdb2,minmax});
if (len > 1)
    set(fit_hand.slider1,'Callback', {@fit_slider1,fit_hand,tdb2});
end %if
set(fit_hand.checkbox1,'Callback',{@fit_checkbox1,fit_hand,tdb2})
set(fit_hand.exbutton,'Callback',...
    {@fit_excludebutton,fit_hand,tdb2,tdb,selection,filepath})
fit_selectfit([],[],fit_hand,tdb2,[])
globtdb = fit_separatedata(tdb);
fit_savefile(globtdb,filepath,1);
% save(file,'tdb','-mat');
disp({'The changes saved in the following folder:';filepath});


