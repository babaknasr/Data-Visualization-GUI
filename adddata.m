function adddata(handles)
global rawdata
nf = int32(str2double(get(handles.text1,'string')));
j = 0;
% l = 0;
data1 = {};
% data2 = {};
for n=1:nf
%     for i=1:size(rawdata(n).parameter,1)
    for i=1:size(rawdata(n).title,1)
        j = j + 1;
%         temp = [rawdata(n).xylabel{i,2} ' vs. ' rawdata(n).xylabel{i,1} ...
%             ' based on ' rawdata(n).parameter{i,1} ' [' rawdata(n).author ']'];
        temp = [rawdata(n).author ': ' rawdata(n).title{i,1} ' - ' rawdata(n).title{i,2}];
        data1{j} = temp;
    end %i
end % n
set(handles.listbox1,'string',data1);

