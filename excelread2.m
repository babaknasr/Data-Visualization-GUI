function [sdata, rdata, hdata] = excelread2(filename)
% clear all;clc;filename='\Converted Data\Ibrahim(2003).xlsx';

% idea 1
sdata = struct('author',[],'title',[],'parameter',[],'time',[],'xylabel',[],...
    'xdata',[],'ydata',[],'filename',[]);
sdata.filename=filename;
[~, ~, raw0] = xlsread(filename,'First');
raw = cellfun(@num2str, raw0, 'UniformOutput', false);
% sdata.author=[raw{2,2} ' (' num2str(data(3)) ')'];
sdata.author=[raw{2,2} ' (' raw{3,2} ')'];
% nsheets = data(1);
nsheets = int16(str2double(raw{1,2}));
maxl = [];
for i=1:nsheets
    sheet = ['sheet' num2str(i)];
    [~, ~, raw0] = xlsread(filename,sheet);
    raw = cellfun(@num2str, raw0, 'UniformOutput', false);
    sdata.title{i,1} = raw{1,1};
    sdata.title{i,2} = raw{1,2};
    sdata.parameter{i,1} = raw{2,1};
    sdata.xylabel{i,1} = raw{3,1};
    sdata.xylabel{i,2} = raw{3,2};
    k = 0;
    m = [];
    % k: number of sets in each sheet
    % m: location of begining of each set in every sheet
    % time: store of number of sets of each sheet for whole document
    % o: length of each dataset in the sheet (just numbers)
    % oo: start and end loacation of each dataset in the sheet (start from
    % x and y labels)
    for j=2:size(raw,1)
        if (strcmpi(raw{2,1},raw{j,1}) == 1)
            k = k + 1;
%             m(k) = j; %!!!!!!!!!!!
            m(k) = j + 1;
            sdata.parameter{i,k+1} = raw{j,2};           
        end %if
    end %j
    sdata.time(i,1) = k;
    o = [];
    oo = [];
    for j=1:length(m)-1
%         o(j) = m(j+1) - m(j);
%         o(j) = m(j+1) - m(j) - 2;
        oo(j,1) = m(j);
        oo(j,2) = m(j+1) - 2;
        o(j) = oo(j,2) - oo(j,1);
    end %j
    
    if (isempty(o) == 0)
%         maxl = max(o) - 2;
%         o(j+1) = size(raw,1) - m(j+1);
        oo(j+1,1) = m(j+1);
        oo(j+1,2) = size(raw,1);
        o(j+1) = oo(j+1,2) - oo(j+1,1);
    else
%         o(1) = size(raw,1) - m(1);
        oo(1,1) = m(1);
        oo(1,2) = size(raw,1);
        o(1) = oo(1,2) - oo(1,1);
%         maxl = size(raw,1) - 2;
%         maxl = size(raw,1) - 3;
    end %if
    maxl(i) = max(o);
    for j=1:size(oo,1)
        sdata.xdata(1:o(j),j,i) = cellfun(@str2double,raw(oo(j,1)+1:oo(j,2),1));
        sdata.xdata(o(j)+1:maxl(i),j,i) = NaN;
        sdata.ydata(1:o(j),j,i) = cellfun(@str2double,raw(oo(j,1)+1:oo(j,2),2));
        sdata.ydata(o(j)+1:maxl(i),j,i) = NaN;
    end %j
    
%     j = 0;
%     k = 0;
%     l = 1;
%     while j<size(data,1)
%         j = j + 1;
%         if (isnan(data(j,1)) == 1)
%             sdata.xdata(k+1:maxl,l,i) = NaN;
%             sdata.ydata(k+1:maxl,l,i) = NaN;
%             j = j + 2;
%             l = l + 1;
%             k = 0;
%         end %if
%         k = k + 1;
%         sdata.xdata(k,l,i) = data(j,1);
%         sdata.ydata(k,l,i) = data(j,2);         
%     end %j
%     sdata.xdata(k+1:maxl,l,i) = NaN;
%     sdata.ydata(k+1:maxl,l,i) = NaN;
end %i
mmaxl = max(maxl);
for i=1:nsheets
    sdata.xdata(maxl(i)+1:mmaxl,:,i) = NaN;
    sdata.ydata(maxl(i)+1:mmaxl,:,i) = NaN;
end %i
%sdata
% save('C:\Users\nasrb\Desktop\tempvar.mat','-mat')

% *****************************************
[~, ~, firstraw] = xlsread(filename,'First');
firstraw = cellfun(@num2str, firstraw, 'UniformOutput', false);
nsheets = int16(str2double(firstraw{1,2}));
source = [firstraw{2,2} ' (' firstraw{3,2} ')'];
[indsource, ~] = detect('Reference');
indhsn = detecthp('setnumber');
indhsi = detecthp('setidentification');
indht = detecthp('title');
indhd = detecthp('description');
indhc = detecthp('comment');
% indhv = detecthp('free2shear');
% indmod = detecthp('modified');
% indmodby = detecthp('modified by');
[rdata, ~, ~] = property();
hdata = hiddenprop();
gi = 1;
for i=1:nsheets
    sheet = ['sheet' num2str(i)];
    [~, ~, raw0] = xlsread(filename,sheet);
    raw = cellfun(@num2str, raw0, 'UniformOutput', false);
    ff = find(strcmp(raw,'NaN') == 1);
    for aa=1:length(ff)
        raw{ff(aa)} = [];
    end %aa
    k = 0;
    index = [];
    ident = {};
    titl = raw{1,1};
    dscr = raw{1,2};
    for j=2:size(raw,1)
        if (strcmpi(raw{2,1},raw{j,1}) == 1)
            k = k + 1;
            index(k) = j;
            ident{k} = raw{j,2};
        end % if
    end %j
    index(k+1)=j+1;
    for k=1:length(index)-1
        for c=1:size(raw,2)
            [ind, ~] = detect(raw{index(k)+1,c});
            indhp = detecthp(raw{index(k)+1,c});
            if (ind ~= 0)
                rdata(gi+1:gi+((index(k+1)-1)-(index(k)+2))+1,ind) = raw(index(k)+2:index(k+1)-1,c);
                rdata(gi+1:gi+((index(k+1)-1)-(index(k)+2))+1,indsource) = {source};
                hdata(gi+1:gi+((index(k+1)-1)-(index(k)+2))+1,indhsn) = {[i, k]};    % set number
                hdata(gi+1:gi+((index(k+1)-1)-(index(k)+2))+1,indhsi) = {{raw{2,1}, raw{index(k),2}}};   % set identification
                hdata(gi+1:gi+((index(k+1)-1)-(index(k)+2))+1,indht) = {titl};   % title
                hdata(gi+1:gi+((index(k+1)-1)-(index(k)+2))+1,indhd) = {dscr};   % description
            end %if
%             elseif (strcmpi(raw{index(k)+1,c},'comment') == 1)
            if (indhp ~= 0)
                switch raw{index(k)+1,c}
                    case 'comment'
                        hdata(gi+1:gi+((index(k+1)-1)-(index(k)+2))+1,indhc) = raw(index(k)+2:index(k+1)-1,c);   % comment
                end %switch
            end %if
        end %c
        gi = gi + ((index(k+1)-1)-(index(k)+2)) + 1;
    end %k
end %i
% read constant sheet
[~, ~, raw0] = xlsread(filename,'Constants');
raw = cellfun(@num2str, raw0, 'UniformOutput', false);

for i=2:size(raw,1)
    [ind, ~] = detect(raw{i,1});
    indhp = detecthp(raw{i,1});
    if (ind ~= 0)
        rdata(2:end,ind) = raw(i,2);
    end %if
%     else %if (strcmpi(raw{i,1},'free2shear') == 1)
    if (indhp ~=0)
        switch raw{i,1}
            case {'setnumber', 'setidentification', 'title', 'description'}
                % do nothing
            case 'free2shear'   
                cpar = [];
                if (size(raw,2) > 2)
                    cpar = str2num(raw{i,3});
                end %if
                hdata(2:end,indhp) = {{raw{i,2},cpar}};
            otherwise
                hdata(2:end,indhp) = strcat(raw{i,2},'; ',hdata(2:end,indhp));
        end %switch
    end %if
end %i

% 
% f2sind = find(strcmpi(raw(:,1),'free2shear') == 1,1);
% if (isempty(f2sind) == 0)
%     cpar = [];
%     if (size(raw,2) > 2)
%         cpar = str2num(raw{i,3});
%     end %if
%     for i=1:size(rdata,1)
%         
%     end %i
% end %if

