% convert free stream to shear velocity right now!
function tdb = theory_findindatabase(Dp,velocity)
global wd whd find_convertfirst
if (isempty(wd) == 1)
    msgbox('The Database is empty!','Database Warning','warn','modal');
    tdb = -1;
    return
end %if
% [indv,~] = detect(velocity);
[indvf,~] = detect('Free stream Velocity');
[indvs,~] = detect('Shear Velocity');

[indps,~] = detect('Particle Size');
[indpm,~] = detect('Particle Material');
[indsm,~] = detect('Substrate Material');
[inddf,~] = detect('Detachment Fraction');
[inds,~] = detect('Reference');
[indrh,~] = detect('Relative Humidity');
indhi = detecthp('setidentification');
indhv = detecthp('free2shear');


er = 1;
err = {'The following warning(s):'};
if (indps == 0)
    er = er + 1;
    err{er} = '- There is no "Particle Size" in Database';
end %if
if (indpm == 0)
    er = er + 1;
    err{er} = '- There is no "Particle Material" in Database';
end %if
if (indsm == 0)
    er = er + 1;
    err{er} = '- There is no "Substrate Material" in Database';
end %if
if (inddf == 0)
    er = er + 1;
    err{er} = '- There is no "Detachment Fraction" in Database';
end %if
if (er > 1)
    msgbox(err,'Database Warning','warn','modal');
    tdb = -1;
    return
end %if
if ((indvf == 0) && (indvs == 0))
    er = er + 1;
    err{er} = '- There is no "Shear" or "Free-stream" Velocity in Database';
end %if
if ((indhi == 0) || (indhv == 0))
    er = er + 1;
    err{er} = '*** the database has not enough information (shear2free or indentification)';
end %if

j = 1;
nwd = wd(1,:);
nwhd = whd(1,:);
fullname = {};
fullname{1} = 'Full Name';
for i=2:size(wd,1)
    if ((isempty(wd{i,indpm}) == 0) && (isempty(wd{i,indsm}) == 0) &&...
            (isnan(str2double(wd{i,inddf})) == 0))
        go = 0;
        if ((strcmpi(velocity,'Free stream Velocity') == 1) && (isnan(str2double(wd{i,indvf})) == 0))
            go = 1;
        end %if
        if (strcmpi(velocity,'Shear Velocity') == 1)
            if (isnan(str2double(wd{i,indvs})) == 0)
                go = 1;
            elseif ((isnan(str2double(wd{i,indvf})) == 0) && (isempty(whd{i,indhv}) == 0))
                go = 1;
            end %if
        end %if
        if (go == 1)
            ps = str2double(wd{i,indps});
            if ((ps >= min(Dp)) && (ps <= max(Dp)))
                j = j + 1;
                nwd(j,:) = wd(i,:);
                nwhd(j,:) = whd(i,:);
                fullname{j} = [wd{i,indpm} '-' wd{i,indsm} ' (Dp=' wd{i,indps}  ')-(RH=' wd{i,indrh} ') [' wd{i,inds} '] & ' whd{i,indhi}{1} ':' whd{i,indhi}{2}];            
            end %if
        end %if
    end %if
end %i
if (isempty(nwd) == 1)
    msgbox('There is no matched data to show!','Database Warning','warn','modal');
    tdb = -1;
    return
end %if

% add it here <<<<<<<<<<<<<<<
if ~isempty(find_convertfirst)
    if (find_convertfirst == 1)
        nwd = rawdata_free2shear(nwd,nwhd);
    end %if
end %if
% >>>>>>>>>>>

tdb = unique(fullname(2:end))';
for j=1:size(tdb,1)
%     tdb{j,2} = {velocity,'Detachment Fraction'};
    tdb{j,2} = {'Free stream Velocity','Shear Velocity','Detachment Fraction','free2shear'};
    tdb{j,3}{1} = nwd(1,:);
    tdb{j,3}{2} = nwhd(1,:);
end %j

el = [];
for j=1:size(tdb,1)
    vfi = find(strcmpi(tdb{j,2},'Free stream Velocity') == 1,1);
    vsi = find(strcmpi(tdb{j,2},'Shear Velocity') == 1,1);
    dfi = find(strcmpi(tdb{j,2},'Detachment Fraction') == 1,1);
    f2si = find(strcmpi(tdb{j,2},'free2shear') == 1,1);
    k = 1;
    for i=2:size(nwd,1)
        if (strcmp(tdb{j,1},fullname{i}) == 1)
            k = k + 1;
            if (indvf ~= 0)
                tdb{j,2}{k,vfi} = str2double(nwd{i,indvf});
            end %if
            if (indvs ~= 0)
                tdb{j,2}{k,vsi} = str2double(nwd{i,indvs});
            end %if
            if (indhv ~= 0)
                tdb{j,2}{k,f2si} = nwhd{i,indhv};
            end %if
            tdb{j,2}{k,dfi} = str2double(nwd{i,inddf});
            tdb{j,3}{1}(k,:) = nwd(i,:);
            tdb{j,3}{2}(k,:) = nwhd(i,:);
        end %if
    end %i
    df = cell2mat(tdb{j,2}(2:end,dfi));
    velf = cell2mat(tdb{j,2}(2:end,vfi));
    vels = cell2mat(tdb{j,2}(2:end,vsi));
%     if (length(df) < 3) || ((all(isnan(velf)) == 0) && (all(velf) == 1))
    if (length(df) < 3)
        el(end+1) = j;
    end %if
end %j
% Eliminate not suitable sets
tdb(el,:) = [];
[s,ok] = listdlg('Name','Database Materials',...
    'PromptString',{'Please select matched materials from available data','in selected particle size range', 'Particle - Substrate','hold Ctrl for multiple choices'},...
    'SelectionMode','multi','ListString',tdb(:,1),'ListSize',[400 200]);
if (ok == 0)
    tdb = -1;
    return
end %if
tdb = tdb(s,:);


assignin('base','tdb',tdb);

