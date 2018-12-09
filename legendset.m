function legendset(x,y,l,lbond,hObject, eventdata, handles)
global gsettings
axes(handles.axes1);
cla
colorbar('hide')

colorrange = colormap('jet');
[msize, nodatamsize] = marker_size();
% gsettings = general_settings(hObject, eventdata, handles);
[novaluecolor, novaluecolorname] = marker_color({}, -1);
[defaultcolor, defaultcolorname] = marker_color({}, 0);
[novaluemarker, novaluemarkername] = marker_type({}, -1);
[defaulttype, defaulttypename] = marker_type({} ,0);
lwidth = gsettings.lwidth;
lwnovalue = gsettings.novalue_lwidth;
% lwnovalue = 1;  % Add it to general settings later
qtyrev = gsettings.qtyrl;
qlyrev = gsettings.qlyrl;
if (gsettings.markerfill == 1)
    fil = 1;
    novaluecolorfil = novaluecolor;
    defaultcolorfil = defaultcolor;
else
    fil = 0;
    novaluecolorfil = 'none';
    defaultcolorfil = 'none';
end %if
switch size(l,2)
%   1 parameter
    case 1
        i = 1;
%       * 1 qty 
        if (strcmp(l{2,i},'qty') == 1)
%             (colorbar)
            lrange = [];
            for k=1:length(l(3:end,i))
                lrange(k) = str2double(l{k+2,i});
            end %k
%           An error occured bellow when ther is nothing in l(3:end,i). It
%           means that there is no value in that parameter
%             lrangeu = lrange(~isnan(lrange));
%             lrangeu = unique(lrangeu);
            c = colorrange;
            cmin = str2double(lbond{i,4});
            cmax = str2double(lbond{i,5});
            if (cmin == cmax)
                cmin = cmin - 1;
                cmax = cmax + 1;
            end %if
            for j=1:length(lrange)
%                 if ((cmax-cmin) ~= 0)
                    ci = int32((size(c,1)-1)/(cmax-cmin)*...
                        (lrange(j)-cmin)+1);
                    if (ci < 1)
                        ci = 1;
                    end %if
                    if (ci > size(c,1))
                        ci = size(c,1);
                    end %if
%                 else
%                     ci = int32((size(c,1)-1)/(cmax-cmin+2)*...
%                         (lrange(j)-(cmin-1))+1);
%                     ci = 1; %******** its not good idea
%                 end %if
                hold on
                if (isnan(lrange(j)) == 0)
                    if (fil == 1)
                        cf = c(ci,:);
                    else
                        cf = 'none';
                    end %if
                    plot3(x(j),y(j),lrange(j),defaulttype,'MarkerFaceColor',cf,...
                        'MarkerEdgeColor',c(ci,:),...
                        'LineWidth',lwidth)
                else
                    plot(x(j),y(j),defaulttype,'MarkerFaceColor',novaluecolorfil,...
                        'MarkerEdgeColor',novaluecolor,...
                        'LineWidth',lwidth)
                end %if
            end %j
            view(2)
%             bar = colorbar('YTick',[min(lrangeu), max(lrangeu)],...
%                 'Ylim',[min(lrangeu), max(lrangeu)]);
            
%             bar = colorbar('YTick',[min(lrangeu), max(lrangeu)],...
%                 'Ylim',[min(lrangeu), max(lrangeu)]);

%              bar = colorbar('Ylim',[min(lrangeu), max(lrangeu)],...
%                  'YTickLabel',{min(lrangeu),max(lrangeu)})
%             if ((cmax-cmin) ~= 0)
                caxis(handles.axes1,[cmin, cmax]);
                bar = colorbar();
%                 bar = colorbar('CLim',[cmin, cmax]);
%             else
%                 caxis(handles.axes1,[cmin-1, cmax+1]);
%                 bar = colorbar('Clim',[cmin-1,cmax+1]);
%                 bar = colorbar('Clim',[cmin,inf]); %******** its not a good idea
%             end %if
            tmptxt = l(1,i);
            if (lbond{i,8} == true)
                tmptxt = [tmptxt;'(no data: ',novaluecolorname,')'];
            end %if
            title(bar,tmptxt)
            set(handles.minedit,'String',num2str(cmin),'Visible','on')
            set(handles.maxedit,'String',num2str(cmax),'Visible','on')
            set(handles.rangepanel,'Title',l{1,i},'Visible','on')
            
%       * 1 qly 
        else
%             (marker type)
            legmarker = {};
%             rleg = l(3:end,i);
%             nemp = cellfun('isempty',rleg) == 0;
%             leg = unique(rleg(nemp));
            for j=1:size(lbond{i,9},1)
                [markertype, markername] = marker_type(lbond{i,9}(:,2),j);
                legmarker{j,1} = lbond{i,9}{j,1};
                legmarker{j,2} = markername;
                legmarker{j,3} = lbond{i,9}{j,2};
                for k=3:size(l,1)
                    hold on
                    if (strcmpi(l{k,i},lbond{i,9}{j,2}) == 1)
                        plot(x(k-2),y(k-2),markertype,'MarkerFaceColor',defaultcolorfil,...
                            'MarkerEdgeColor',defaultcolor,...
                            'LineWidth',lwidth)
                    end %if
                    if ((isempty(l{k,i}) == 1) && (lbond{i,8} == true))
                        plot(x(k-2),y(k-2),novaluemarker,'MarkerFaceColor',defaultcolorfil,...
                            'MarkerEdgeColor',defaultcolor,...
                            'LineWidth',lwnovalue)
                    end %if
                end %k
            end %j
            set(handles.legendtable...
            ,'Data',legmarker,'ColumnFormat',{'logical',...
            {'Circle', 'Diamond', 'Downward triangle', 'Square', 'Right triangle',...
                'Pentagram','Upward triangle', 'Left triangle', 'Asterisk',...
                'Hexagram', 'Plus', 'Point','Cross'}...
            , 'char'},...
            'ColumnWidth',{20,50,135},'ColumnEditable',[false true false],...
            'ColumnName',{'', 'Marker', 'Value'},...
            'Visible','on');
            set(handles.legendpanel,'Title',l{1,i},'Visible','on')
            tmptxt = '';
            if (lbond{i,8} == true)
                tmptxt = ['no data marker type: (' novaluemarkername ')'];
            end %if
            set(handles.novaluetext1,'String',tmptxt,'Visible','on')
        end %if
%   2 parameter        
    case 2
%       ** 1 "qty" and 1 "qly" (colorbar & marker type)
        if ((strcmp(l{2,1},'qty') ==1) && (strcmp(l{2,2},'qly') ==1)) || ((strcmp(l{2,2},'qty') ==1) && (strcmp(l{2,1},'qly') ==1))
            if (strcmp(l{2,1},'qty') == 1)
                i = 1; % i for qty parameter
                ii = 2; % ii for qly parameter
            else
                i = 2;
                ii = 1;
            end %if
            lrange1 = [];
            for k=1:length(l(3:end,i))
                lrange1(k) = str2double(l{k+2,i});
            end %k
%            Error below if there is nothing in l(3:end,i)
%             lrange1u = lrange1(~isnan(lrange1));
%             lrange1u = unique(lrange1u);
            c = colorrange;
            cmin = str2double(lbond{i,4});
            cmax = str2double(lbond{i,5});
            if (cmin == cmax)
                cmin = cmin - 1;
                cmax = cmax + 1;
            end %if
            legmarker2 = {};
%             rleg = l(3:end,ii);
%             nemp = cellfun('isempty',rleg) == 0;
%             leg2 = unique(rleg(nemp));
            for j=1:size(lbond{ii,9},1)
                [markertype, markername] = marker_type(lbond{ii,9}(:,2),j);
                legmarker2{j,1} = lbond{ii,9}{j,1};
                legmarker2{j,2} = markername;
                legmarker2{j,3} = lbond{ii,9}{j,2};
                for k=3:size(l,1)
                    m = k - 2;
                    hold on
                    if (strcmpi(l{k,ii},lbond{ii,9}{j,2}) == 1)
%                         if ((cmax-cmin) ~= 0)
                            ci = int32((size(c,1)-1)/(cmax-cmin)*...
                                (lrange1(m)-cmin)+1);
                            if (ci < 1)
                                ci = 1;
                            end %if
                            if (ci > size(c,1))
                                ci = size(c,1);
                            end %if
%                         else
%                             ci = int32((size(c,1)-1)/(cmax-cmin+2)*...
%                                 (lrange1(m)-(cmin-1))+1);
% %                             ci = 1;
%                         end %if
                        if (isnan(lrange1(m)) == 0)
                            if (fil == 1)
                                cf = c(ci,:);
                            else
                                cf = 'none';
                            end %if
                            plot(x(m),y(m),markertype,...
                                'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                                'LineWidth',lwidth)
                        else
                            plot(x(m),y(m),markertype,...
                                'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',novaluecolor,...
                                'LineWidth',lwidth)
                        end %if  
                    end %if
                    if ((isempty(l{k,ii}) == 1) && (lbond{ii,8} == true))
%                         if ((cmax-cmin) ~= 0)
                            ci = int32((size(c,1)-1)/(cmax-cmin)*...
                                (lrange1(m)-cmin)+1);
                            if (ci < 1)
                                ci = 1;
                            end %if
                            if (ci > size(c,1))
                                ci = size(c,1);
                            end %if
%                         else
%                             ci = int32((size(c,1)-1)/(cmax-cmin+2)*...
%                                 (lrange1(m)-(cmin-1))+1);
% %                             ci = 1;
%                         end %if
                        if (isnan(lrange1(m)) == 0)
                            if (fil == 1)
                                cf = c(ci,:);
                            else
                                cf = 'none';
                            end %if
                            plot(x(m),y(m),novaluemarker,...
                                'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                                'LineWidth',lwnovalue)
                        else
                            plot(x(m),y(m),novaluemarker,...
                                'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',novaluecolor,...
                                'LineWidth',lwnovalue)
                        end %if
                    end %if
                end %k
            end %j
%             if ((cmax-cmin) ~= 0)
                caxis(handles.axes1,[cmin, cmax]);
                bar = colorbar();
%                 bar = colorbar('Clim',[cmin, cmax]); 
%             else
%                 bar = colorbar('Clim',[(cmin-1),(cmax+1)]);
% %                 bar = colorbar('Clim',[cmin,inf]);
%             end %if
            tmptxt = l(1,i);
            if (lbond{i,8} == true)
                tmptxt = [tmptxt;'(no data: ',novaluecolorname,')'];
            end %if
            title(bar,tmptxt)
            set(handles.minedit,'String',num2str(cmin),'Visible','on')
            set(handles.maxedit,'String',num2str(cmax),'Visible','on')
            set(handles.legendtable...
                ,'Data',legmarker2,'ColumnFormat',{'logical',...
                {'Circle', 'Diamond', 'Downward triangle', 'Square', 'Right triangle',...
                    'Pentagram','Upward triangle', 'Left triangle', 'Asterisk',...
                    'Hexagram', 'Plus', 'Point','Cross'}... 
                , 'char'},'ColumnWidth',{20,50,135},'ColumnEditable',[false true false],...
                'ColumnName',{'', 'Marker', 'Value'},...
                'Visible','on');
            set(handles.rangepanel,'Title',l{1,i},'Visible','on')
            set(handles.legendpanel,'Title',l{1,ii},'Visible','on')
            tmptxt = '';
            if (lbond{ii,8} == true)
                tmptxt = ['no data marker type: (' novaluemarkername ')'];
            end %if
            set(handles.novaluetext1,'String',tmptxt,'Visible','on')
        end %if
%       ** 2 qty (colorbar & marker size)
        if ((strcmp(l{2,1},'qty') == 1) && (strcmp(l{2,2},'qty') == 1))
% i is for colorbar
% ii is for markersize
            if (qtyrev == 1)
                i = 2; % 2 means colorbar
                ii = 1; % 1 means markersize
            else
                i = 1;
                ii = 2;
            end %if
            lrange1 = [];
            lrange2 = [];
            for k=1:length(l(3:end,1))
                lrange1(k) = str2double(l{k+2,i});
                lrange2(k) = str2double(l{k+2,ii});
            end %k
%           Error below when ther is nothing in l(3:end,1) or l(3:end,2)
%             lrange1u = lrange1(~isnan(lrange1));
%             lrange1u = unique(lrange1u);
%             lrange2u = lrange2(~isnan(lrange2));
%             lrange2u = unique(lrange2u);
            cmin = str2double(lbond{i,4});
            cmax = str2double(lbond{i,5});
            if (cmin == cmax)
                cmin = cmin - 1;
                cmax = cmax + 1;
            end %if
            smin = str2double(lbond{ii,4});
            smax = str2double(lbond{ii,5});
            if (smin == smax)
                smin = smin - 1;
                smax = smax + 1;
            end %if
            c = colorrange;
            s = msize;
            nos = nodatamsize;
            hold on
            for j=1:length(lrange1)
%                 if ((max(lrange1u)-min(lrange1u)) ~= 0)
                    ci = int32((size(c,1)-1)/(cmax-cmin)*...
                        (lrange1(j)-cmin)+1);
                    if (ci < 1)
                        ci = 1;
                    end %if
                    if (ci > size(c,1))
                        ci = size(c,1);
                    end %if
%                 else
%                     ci = 1;
%                 end %if
%                 if ((max(lrange2u)-min(lrange2u)) ~= 0)
                    si = int32((length(s)-1)/(smax-smin)*...
                        (lrange2(j)-smin)+1);
                    if (si < 1)
                        si = 1;
                    end %if
                    if (si > length(s))
                        si = length(s);
                    end %if
%                 else
%                     si = s(1);
%                 end %if
                if ((isnan(lrange1(j)) == 0) && (isnan(lrange2(j)) == 0))
                    if (fil == 1)
                        cf = c(ci,:);
                    else
                        cf = 'none';
                    end %if
                    plot(x(j),y(j),defaulttype,...
                        'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                        'MarkerSize',s(si),...
                        'LineWidth',lwidth)
                end %if
                if ((isnan(lrange1(j)) == 1) && (isnan(lrange2(j)) == 1))
                    plot(x(j),y(j),novaluemarker,...
                        'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',...
                        novaluecolor,'MarkerSize',nos,'LineWidth',lwidth)
                end %if
                if ((isnan(lrange1(j)) == 1) && (isnan(lrange2(j)) == 0))
                    plot(x(j),y(j),defaulttype,...
                        'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',novaluecolor,...
                        'MarkerSize',s(si),...
                        'LineWidth',lwidth)
                end %if
                if ((isnan(lrange1(j)) == 0) && (isnan(lrange2(j)) == 1))
                    if (fil == 1)
                        cf = c(ci,:);
                    else
                        cf = 'none';
                    end %if
                    plot(x(j),y(j),novaluemarker,...
                        'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                        'MarkerSize',nos,...
                        'LineWidth',lwidth)
                end %if
            end %j
%             if ((max(lrange1u)-min(lrange1u)) ~= 0)
                caxis(handles.axes1,[cmin, cmax]);
                bar = colorbar();
%                 bar = colorbar('Clim',[cmin, cmax]); 
%             else
%                 bar = colorbar('Clim',[min(lrange1u),inf]);
%             end %if
            txt1 = ['Min: ( Marker Size: ' num2str(s(1)) ' )'];
            txt2 = ['Max: ( Marker Size: ' num2str(s(end)) ' )'];
            txt3 = '';
            if (lbond{ii,8} == true)
                txt3 = ['(Marker (', novaluemarkername, ') means no data)'];
            end %if
            txt = {txt1,txt2,txt3};
            tmptxt = l(1,i);
            if (lbond{i,8} == true)
                tmptxt = [tmptxt;'(no data: ',novaluecolorname,')'];
            end %if
            title(bar,tmptxt)
            set(handles.minedit,'String',num2str(cmin),'Visible','on')
            set(handles.maxedit,'String',num2str(cmax),'Visible','on')
            set(handles.minedit2,'String',num2str(smin),'Visible','on')
            set(handles.maxedit2,'String',num2str(smax),'Visible','on')
            set(handles.legendtext2,'String',txt,'Visible','on')
            set(handles.rangepanel,'Title',l{1,i},'Visible','on')
            set(handles.legendpanel3,'Title',l{1,ii},'Visible','on')
        end %if

%       ** 2 qly (marker type and marker color)
% an error occured when the number of values for second qualitative
% parameter exceed the number of colors (7) (FIXED)
        if ((strcmp(l{2,1},'qly') ==1) && (strcmp(l{2,2},'qly') ==1))
            if (qlyrev == 1)
                i = 2;
                ii = 1;                
            else
                i = 1;  % i is for markertype
                ii = 2; % ii is for markercolor
            end %if
            legmarker1 = {};
%             rleg = l(3:end,i);
%             nemp = cellfun('isempty',rleg) == 0;
%             leg1 = unique(rleg(nemp));
            legcolor2 = {};
%             rleg = l(3:end,ii);
%             nemp = cellfun('isempty',rleg) == 0;
%             leg2 = unique(rleg(nemp));
            for j=1:size(lbond{i,9},1)
                [markertype, markername] = marker_type(lbond{i,9}(:,2),j);
                legmarker1{j,1} = lbond{i,9}{j,1};
                legmarker1{j,2} = markername;
                legmarker1{j,3} = lbond{i,9}{j,2};
                for m=1:size(lbond{ii,9},1)
                    [markercolor, markercolorname] = marker_color(lbond{ii,9}(:,2),m);
                    legcolor2{m,1} = lbond{ii,9}{m,1};
                    legcolor2{m,2} = markercolorname;
                    legcolor2{m,3} = lbond{ii,9}{m,2};
                    for k=3:size(l,1)
                        hold on
                        if (strcmpi(l{k,i},lbond{i,9}{j,2}) == 1)
                            if (strcmpi(l{k,ii},lbond{ii,9}{m,2}) == 1)
                                if (fil == 1)
                                    cf = markercolor;
                                else
                                    cf = 'none';
                                end %if 
                                plot(x(k-2),y(k-2),markertype,...
                                    'MarkerFaceColor',cf,'MarkerEdgeColor',markercolor,...
                                    'LineWidth',lwidth)
                            end %if
                            if ((isempty(l{k,ii}) == 1) && (lbond{ii,8} == true))
                                if (fil == 1)
                                    cf = novaluecolor;
                                else
                                    cf = 'none';
                                end %if 
                                plot(x(k-2),y(k-2),markertype,...
                                    'MarkerFaceColor',cf,'MarkerEdgeColor',novaluecolor,...
                                    'LineWidth',lwidth)
                            end %if
                        end %if
                        if ((isempty(l{k,i}) == 1) && lbond{i,8} == true)
                            if (strcmpi(l{k,ii},lbond{ii,9}{m,2}) == 1)
                                if (fil == 1)
                                    cf = markercolor;
                                else
                                    cf = 'none';
                                end %if 
                                plot(x(k-2),y(k-2),novaluemarker,...
                                    'MarkerFaceColor',cf,'MarkerEdgeColor',markercolor,...
                                    'LineWidth',lwnovalue)
                            end %if
                            if ((isempty(l{k,ii}) == 1) && (lbond{ii,8} == true))
                                if (fil == 1)
                                    cf = novaluecolor;
                                else
                                    cf = 'none';
                                end %if 
                                plot(x(k-2),y(k-2),novaluemarker,...
                                    'MarkerFaceColor',cf,'MarkerEdgeColor',novaluecolor,...
                                    'LineWidth',lwnovalue)
                            end %if
                        end %if
                    end %k
                end %m
            end %j
            set(handles.legendtable...
            ,'Data',legmarker1,'ColumnFormat',{'logical',...
            {'Circle', 'Diamond', 'Downward triangle', 'Square', 'Right triangle',...
                    'Pentagram','Upward triangle', 'Left triangle', 'Asterisk',...
                    'Hexagram', 'Plus', 'Point','Cross'}... 
            , 'char'},'ColumnWidth',{20,50,135},'ColumnEditable',[false true false],...
            'ColumnName',{'', 'Marker', 'Value'},...
            'Visible','on');
            set(handles.legendtable2...
            ,'Data',legcolor2,'ColumnFormat',{'logical',...
            {'Red','Green','Blue','Cyan','Magenta','Yellow','Black'}...
            , 'char'},'ColumnWidth',{20,50,135},'ColumnEditable',[false true false],...
            'ColumnName',{'', 'Color', 'Value'},...
            'Visible','on');
            set(handles.legendpanel,'Title',l{1,i},'Visible','on')
            set(handles.legendpanel2,'Title',l{1,ii},'Visible','on')
            tmptxt = '';
            if (lbond{i,8} == true)
                tmptxt = ['no data marker type: (' novaluemarkername ')'];
            end %if
            set(handles.novaluetext1,'String',tmptxt,'Visible','on')
            tmptxt = '';
            if (lbond{ii,8} == true)
                tmptxt = ['no data marker color: (' novaluecolorname ')'];
            end %if
            set(handles.novaluetext2,'String',tmptxt,'Visible','on')
        end %if
        
%   3 parameter
    case 3
        if (((strcmp(l{2,1},'qty') == 1) && (strcmp(l{2,2},'qty') == 1) && (strcmp(l{2,3},'qly') == 1))...
                || ((strcmp(l{2,1},'qty') == 1) && (strcmp(l{2,2},'qly') == 1) && (strcmp(l{2,3},'qty') == 1))...
                || ((strcmp(l{2,1},'qly') == 1) && (strcmp(l{2,2},'qty') == 1) && (strcmp(l{2,3},'qty') == 1)))
% i for colorbar (qty)
% ii for markersize (qty)
% iii for marker type (qly)
            if ((strcmp(l{2,1},'qty') == 1) && (strcmp(l{2,2},'qty') == 1) && (strcmp(l{2,3},'qly') == 1))
                if (qtyrev == 1)
                    i = 2;
                    ii = 1;
                    iii = 3;
                else
                    i = 1;
                    ii = 2;
                    iii = 3;
                end %if
            end %if
            if ((strcmp(l{2,1},'qty') == 1) && (strcmp(l{2,2},'qly') == 1) && (strcmp(l{2,3},'qty') == 1))
                if (qtyrev == 1)
                    i = 3;
                    ii = 1;
                    iii = 2;
                else
                    i = 1;
                    ii = 3;
                    iii = 2;
                end %if
            end %if
            if ((strcmp(l{2,1},'qly') == 1) && (strcmp(l{2,2},'qty') == 1) && (strcmp(l{2,3},'qty') == 1))
                if (qtyrev == 1)
                    i = 3;
                    ii = 2;
                    iii = 1;
                else
                    i = 2;
                    ii = 3;
                    iii = 1;
                end %if
            end %if
            lrange1 = [];
            lrange2 = [];
            for k=1:length(l(3:end,1))
                lrange1(k) = str2double(l{k+2,i});
                lrange2(k) = str2double(l{k+2,ii});
            end %k
%           Error below when ther is nothing in l(3:end,1) or l(3:end,2)
%             lrange1u = lrange1(~isnan(lrange1));
%             lrange1u = unique(lrange1u);
%             lrange2u = lrange2(~isnan(lrange2));
%             lrange2u = unique(lrange2u);
            cmin = str2double(lbond{i,4});
            cmax = str2double(lbond{i,5});
            if (cmin == cmax)
                cmin = cmin - 1;
                cmax = cmax + 1;
            end %if
            smin = str2double(lbond{ii,4});
            smax = str2double(lbond{ii,5});
            if (smin == smax)
                smin = smin - 1;
                smax = smax + 1;
            end %if
            c = colorrange;
            s = msize;
            nos = nodatamsize;
            legmarker3 = {};
%             rleg = l(3:end,iii);
%             nemp = cellfun('isempty',rleg) == 0;
%             leg3 = unique(rleg(nemp));
            for jj=1:size(lbond{iii,9},1)
                [markertype, markername] = marker_type(lbond{iii,9}(:,2),jj);
                legmarker3{jj,1} = lbond{iii,9}{jj,1};
                legmarker3{jj,2} = markername;
                legmarker3{jj,3} = lbond{iii,9}{jj,2};
                for k=3:size(l,1)
                    j = k - 2;
                    hold on
                    if (strcmpi(l{k,iii},lbond{iii,9}{jj,2}) == 1)
%                         if ((max(lrange1u)-min(lrange1u)) ~= 0)
                            ci = int32((size(c,1)-1)/(cmax-cmin)*...
                                (lrange1(j)-cmin)+1);
                            if (ci < 1)
                                ci = 1;
                            end %if
                            if (ci > size(c,1))
                                ci = size(c,1);
                            end %if
%                         else
%                             ci = 1;
%                         end %if
%                         if ((max(lrange2u)-min(lrange2u)) ~= 0)
                            si = int32((length(s)-1)/(smax-smin)*...
                                (lrange2(j)-smin)+1);
                            if (si < 1)
                                si = 1;
                            end %if
                            if (si > length(s))
                                si = length(s);
                            end %if
%                         else
%                             si = s(1);
%                         end %if
                        if ((isnan(lrange1(j)) == 0) && (isnan(lrange2(j)) == 0))
                            if (fil == 1)
                                cf = c(ci,:);
                            else
                                cf = 'none';
                            end %if
                            plot(x(j),y(j),markertype,...
                                'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                                'MarkerSize',s(si),...
                                'LineWidth',lwidth)
                        end %if
                        if ((isnan(lrange1(j)) == 1) && (isnan(lrange2(j)) == 1))
                            plot(x(j),y(j),markertype,...
                                'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',...
                                novaluecolor,'MarkerSize',nos,'LineWidth',lwidth)
                        end %if
                        if ((isnan(lrange1(j)) == 1) && (isnan(lrange2(j)) == 0))
                            plot(x(j),y(j),markertype,...
                                'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',novaluecolor,...
                                'MarkerSize',s(si),...
                                'LineWidth',lwidth)
                        end %if
                        if ((isnan(lrange1(j)) == 0) && (isnan(lrange2(j)) == 1))
                            if (fil == 1)
                                cf = c(ci,:);
                            else
                                cf = 'none';
                            end %if
                            plot(x(j),y(j),markertype,...
                                'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                                'MarkerSize',nos,...
                                'LineWidth',lwidth)
                        end %if
                    end %if
                    if ((isempty(l{k,iii}) == 1) && (lbond{iii,8} == true))
 %                         if ((max(lrange1u)-min(lrange1u)) ~= 0)
                            ci = int32((size(c,1)-1)/(cmax-cmin)*...
                                (lrange1(j)-cmin)+1);
                            if (ci < 1)
                                ci = 1;
                            end %if
                            if (ci > size(c,1))
                                ci = size(c,1);
                            end %if
%                         else
%                             ci = 1;
%                         end %if
%                         if ((max(lrange2u)-min(lrange2u)) ~= 0)
                            si = int32((length(s)-1)/(smax-smin)*...
                                (lrange2(j)-smin)+1);
                            if (si < 1)
                                si = 1;
                            end %if
                            if (si > length(s))
                                si = length(s);
                            end %if
%                         else
%                             si = s(1);
%                         end %if
                        if ((isnan(lrange1(j)) == 0) && (isnan(lrange2(j)) == 0))
                            if (fil == 1)
                                cf = c(ci,:);
                            else
                                cf = 'none';
                            end %if
                            plot(x(j),y(j),novaluemarker,...
                                'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                                'MarkerSize',s(si),...
                                'LineWidth',lwnovalue)
                        end %if
                        if ((isnan(lrange1(j)) == 1) && (isnan(lrange2(j)) == 1))
                            plot(x(j),y(j),novaluemarker,...
                                'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',...
                                novaluecolor,'MarkerSize',nos,'LineWidth',lwidth)
                        end %if
                        if ((isnan(lrange1(j)) == 1) && (isnan(lrange2(j)) == 0))
                            plot(x(j),y(j),novaluemarker,...
                                'MarkerFaceColor',novaluecolorfil,'MarkerEdgeColor',novaluecolor,...
                                'MarkerSize',s(si),...
                                'LineWidth',lwnovalue)
                        end %if
                        if ((isnan(lrange1(j)) == 0) && (isnan(lrange2(j)) == 1))
                            if (fil == 1)
                                cf = c(ci,:);
                            else
                                cf = 'none';
                            end %if
                            plot(x(j),y(j),novaluemarker,...
                                'MarkerFaceColor',cf,'MarkerEdgeColor',c(ci,:),...
                                'MarkerSize',nos,...
                                'LineWidth',lwnovalue)
                        end %if
                    end %if
                end %k
            end %jj
%             if ((max(lrange1u)-min(lrange1u)) ~= 0)
                caxis(handles.axes1,[cmin, cmax]);
                bar = colorbar();
%                 bar = colorbar('Clim',[cmin, cmax]); 
%             else
%                 bar = colorbar('Clim',[min(lrange1u),inf]);
%             end %if
            txt1 = ['Min: ( Marker Size: ' num2str(s(1)) ' )'];
            txt2 = ['Max: ( Marker Size: ' num2str(s(end)) ' )'];
            txt3 = '';
            if (lbond{ii,8} == true)
                txt3 = ['(Marker size (', num2str(nos), ') means no data)'];
            end %if
            txt = {txt1,txt2,txt3};
            tmptxt = l(1,i);
            if (lbond{i,8} == true)
                tmptxt = [tmptxt;'(no data: ',novaluecolorname,')'];
            end %if
            title(bar,tmptxt)
            set(handles.minedit,'String',num2str(cmin),'Visible','on')
            set(handles.maxedit,'String',num2str(cmax),'Visible','on')
            set(handles.minedit2,'String',num2str(smin),'Visible','on')
            set(handles.maxedit2,'String',num2str(smax),'Visible','on')
            set(handles.legendtext2,'String',txt,'Visible','on')
            set(handles.rangepanel,'Title',l{1,i},'Visible','on')
            set(handles.legendpanel3,'Title',l{1,ii},'Visible','on')
            set(handles.legendtable...
                ,'Data',legmarker3,'ColumnFormat',{'logical',...
                {'Circle', 'Diamond', 'Downward triangle', 'Square', 'Right triangle',...
                    'Pentagram','Upward triangle', 'Left triangle', 'Asterisk',...
                    'Hexagram', 'Plus', 'Point','Cross'}... 
                , 'char'},'ColumnWidth',{20,50,135},'ColumnEditable',[false true false],...
                'ColumnName',{'', 'Marker', 'Value'},...
                'Visible','on');
            set(handles.legendpanel,'Title',l{1,iii},'Visible','on')
            tmptxt = '';
            if (lbond{iii,8} == true)
                tmptxt = ['no data marker type: (' novaluemarkername ')'];
            end %if
            set(handles.novaluetext1,'String',tmptxt,'Visible','on')
        end %if
        
end %switch

