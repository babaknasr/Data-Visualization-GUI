% evaluate the the set of data for available parameters (creat 'll'
% variabl from wd variable based on x axis and y axis parameters selection
% xselect : the parameters which is selected for x axis
% yselect : the parameters which is selected for y axis
% plist : the list of available parameters for those x and y slection,
% plist is the 'uitable2' object data actually
function  [x, y, ll, hll] = available_parameters_data(xselect, yselect ,plist)
global wd whd

x = [];
y = [];
[ix, ~] = detect(xselect);
[iy, ~] = detect(yselect);
hll = hiddenprop();
ll = {};    % all available properties (used when we click on tracking point)
            % all the parameters in uitable2 with values in the following
            % format:    'Parameter1 name'  ,  'Parameter2 name'
            %            ''qty' or 'qly''   ,  ''qty' or 'qly''
            %                 Value1        ,         Value1
            %                 Value2        ,         Value2
            %                    .          ,            .

% j = 0;
for i=1:length(plist)
    [isll(i), qty] = detect(plist{i});
    ll{1,i} = detect0(isll(i));
    if (qty == 1)
        ll{2,i} = 'qty';
    else
        ll{2,i} = 'qly';
    end %if
end %i
j = 2;
for i=2:size(wd,1)
    if (isempty(wd{i,ix}) == 0 && isempty(wd{i,iy}) == 0)
        j = j + 1;       
        x(j-2) = str2double(wd{i,ix});
        y(j-2) = str2double(wd{i,iy});
        for k=1:length(isll)
            ll{j,k} = wd{i,isll(k)};
        end %k
        hll(j-1,:) = whd(i,:);
    end %if
end %i
