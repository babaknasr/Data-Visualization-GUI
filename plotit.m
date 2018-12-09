% for idea 1
% plot Original Figure dataset
function plotit(select,handles)
global rawdata
marker = {'+','o','*','.','x','s','d','^','v','>','<','p','h'''};
mcolor = {'r','g','b','c','m','y','k'};
nf = int32(str2double(get(handles.text1,'String')));
axes(handles.axes1);
%get(handles.axes1);
cla
for m=1:length(select)
    k = 0;
    gout = 0;
    for i=1:nf
        for j=1:size(rawdata(i).parameter,1)
            k = k + 1;
            if (k == select(m))
                par = j;
                n = i;
                gout = 1;
                break;
            end %if
        end %j
        if (gout == 1)
            break;
        end %if
    end %i
    for i=1:rawdata(n).time(par,1)
        hold on
%         p = scatter(handles.axes1,rawdata(n).xdata(:,i,par),rawdata(n).ydata(:,i,par),'LineWidth',1.5);
        p = plot(handles.axes1,rawdata(n).xdata(:,i,par),rawdata(n).ydata(:,i,par),':o','LineWidth',1.5);
        if (isnan(rawdata(n).parameter{par,i+1}) == 1)
            temp2 = '';
        else
            temp2 = rawdata(n).parameter{par,i+1};
        end %if
        temp = [rawdata(n).parameter{par,1} ': ' temp2]; 
        leg = legend(handles.axes1,p,temp);
    end %i
end %m
legend off
legend show
%gleg = get(leg,'Title');
%set(ax,'String','Legend Title');
title([rawdata(n).author ': ' rawdata(n).title{par,1} ' - ' rawdata(n).title{par,2}])
xlabel(rawdata(n).xylabel{par,1})
ylabel(rawdata(n).xylabel{par,2})
ylim('auto')
xlim('auto')

