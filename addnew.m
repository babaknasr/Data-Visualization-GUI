function addnew(c,filename1,filepath1,hObject, eventdata, handles)
% c = 1 means open
% c = 2 means import
global rawdata wd whd
nf = int32(str2double(get(handles.text1,'string')));

if (nf == 0)
    wd = {};
    rawdata = struct('author',[],'title',[],'parameter',[],'time',[],'xylabel',[],...
    'xdata',[],'ydata',[],'filename',[]);
end %if

if (c == 1)
    stat = 'open';
else %(c == 2)
    stat = 'import';
end %if
waitfunc(1,stat, handles)
if (iscell(filename1) == 0)
    temp = {};
    temp{1} = filename1;
    filename1 = temp;
end %if
if (iscell(filename1) == 1)
    for i=1:length(filename1)
        filenamec=[filepath1 filename1{i}];
        if (c == 1)
            % Add later to control the error here
            load(filenamec,'-mat','rdata','sdata','hdata')
        end %if
        if (c == 2)
            [sdata, rdata, hdata] = excelread2(filenamec);
            [~, nam, ~] = fileparts(filename1{i});
            nam2 = [filepath1, nam, '.mat'];
            % Add later to check the existence of the file and ask to
            % overwrite 
            save(nam2,'sdata','rdata','hdata');
        end %if
        rawdata(nf+1) = sdata;
        if (nf == 0)
            [wd, ~, ~] = property();
            whd = hiddenprop();
%             wd = rdata;
%         else
            %tempdata = data2(2:end,:);
%             wd = [wd;rdata(2:end,:)];
        end %if
        tempdata = cell([(size(rdata,1)-1) size(wd,2)]);
        for j=1:size(rdata,2)
            [ind, ~] = detect(rdata{1,j});
            if (ind ~= 0)
                tempdata(:,ind) = rdata(2:end,j);
            end %if
        end %j
        wd = [wd;tempdata];
        whd = [whd;hdata(2:end,:)];
        nf = nf + 1;
    end %i
%     nf = nf + length(filename1);
% else
%     filenamec=[filepath1 filename1];
%     if (c == 1)
%         load(filenamec,'-mat','rdata','sdata','hdata')
%     end %if
%     if (c == 2)
%         [sdata, rdata, hdata] = excelread2(filenamec);
%         [~, nam, ~] = fileparts(filename1);
%         nam2 = [filepath1, nam, '.mat'];
%         save(nam2,'sdata','rdata','hdata');
%     end %if
%     rawdata(nf+1) = sdata;
%     
%     if (nf == 0)
%         [wd, ~, ~] = property();
%         whd = hiddenprop();
% %         [wd, ~, ~] = property()
% %         for 
% %         wd = rdata;
% %     else
% %         wd = [wd;rdata(2:end,:)];
%     end %if
%     tempdata = cell([(size(rdata,1)-1) size(wd,2)]);
%     for j=1:size(rdata,2)
%         [ind, ~] = detect(rdata{1,j});
%         if (ind ~= 0)
%             tempdata(:,ind) = rdata(2:end,j);
%         end %if
%     end %j
%     wd = [wd;tempdata];
%     whd = [whd;hdata(2:end,:)];
%     nf = nf + 1;
end %if

set(handles.text1,'string',num2str(nf))
adddata(handles)

alist = checkdata(wd);
adddata2(alist, hObject, eventdata, handles);
waitfunc(0,'import', handles)

assignin('base', 'whd', whd);
assignin('base', 'wd', wd);
