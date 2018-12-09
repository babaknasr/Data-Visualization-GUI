function applylegchanges(handles)
global newx newy newl lbond markertypeg markercolorg gsettings
waitfunc(1,'retrieve', handles)
err = {};
e = 0;
if (strcmp(get(handles.rangepanel,'Visible'),'on') == 1)
    min1 = str2double(get(handles.minedit,'String'));
    max1 = str2double(get(handles.maxedit,'String'));
    if (min1 < max1)
        pname = get(handles.rangepanel,'Title');
        for k=1:size(lbond,1)
            if (strcmp(pname,lbond{k,2}) == 1)
                lbond{k,4} = num2str(min1);
                lbond{k,5} = num2str(max1);
                break
            end %if
        end %k
    else
        e = e + 1;
        err{e} = 'Colorbar limits: Wrong range!';
    end %if
end %if
if (strcmp(get(handles.legendpanel3,'Visible'),'on') == 1)
    min2 = str2double(get(handles.minedit2,'String'));
    max2 = str2double(get(handles.maxedit2,'String'));
    if (min2 < max2)
        pname = get(handles.legendpanel3,'Title');
        for k=1:size(lbond,1)
            if (strcmp(pname,lbond{k,2}) == 1)
                lbond{k,4} = num2str(min2);
                lbond{k,5} = num2str(max2);
                break
            end %if
        end %k
    else
        e = e + 1;
        err{e} = 'Marker size limits: Wrong range!';
    end %if
end %if
if (strcmp(get(handles.legendpanel,'Visible'),'on') == 1)
    tableget = get(handles.legendtable,'Data');
    tableget(:,1) = [];
    if (isempty(gsettings.marker_type) == 0)
        for i=1:size(tableget,1)
            sm = size(gsettings.marker_type,1);
            index = find(strcmp(gsettings.marker_type(:,1),tableget{i,2}),1);
            if (isempty(index) == 0)
                gsettings.marker_type{index,1} = tableget{i,2};
                gsettings.marker_type{index,2} = tableget{i,1};
            else
                gsettings.marker_type{sm+1,1} = tableget{i,2};
                gsettings.marker_type{sm+1,2} = tableget{i,1};
            end %if
        end %i
    else
        gsettings.marker_type = {};
        gsettings.marker_type(:,1) = tableget(:,2);
        gsettings.marker_type(:,2) = tableget(:,1);
    end %if
%     gsettings.marker_type
    general_settings(1,handles)
end %if

if (strcmp(get(handles.legendpanel2,'Visible'),'on') == 1)
    tableget = get(handles.legendtable2,'Data');
    tableget(:,1) = [];
    if (isempty(gsettings.marker_color) == 0)
        for i=1:size(tableget,1)
            sm = size(gsettings.marker_color,1);
            index = find(strcmp(gsettings.marker_color(:,1),tableget{i,2}),1);
            if (isempty(index) == 0)
                gsettings.marker_color{index,1} = tableget{i,2};
                gsettings.marker_color{index,2} = tableget{i,1};
            else
                gsettings.marker_color{sm+1,1} = tableget{i,2};
                gsettings.marker_color{sm+1,2} = tableget{i,1};
            end %if
        end %i
    else
        gsettings.marker_color = {};
        gsettings.marker_color(:,1) = tableget(:,2);
        gsettings.marker_color(:,2) = tableget(:,1);
    end %if
%     gsettings.marker_color
    general_settings(1,handles)
end %if

if (e > 0)
   warndlg(err,'Error')
else
    xlimit = get(handles.axes1,'XLim');
    ylimit = get(handles.axes1,'YLim');
    legendset(newx,newy,newl,lbond,[], [], handles)
    set(handles.axes1,'XLim',xlimit,'YLim',ylimit)
    xrange = get(handles.axes1,'XLim');
    yrange = get(handles.axes1,'YLim');
    set(handles.yminedit,'String',yrange(1))
    set(handles.ymaxedit,'String',yrange(2))
    set(handles.xminedit,'String',xrange(1))
    set(handles.xmaxedit,'String',xrange(2))
    legendchanged(0,handles)
end %if
waitfunc(0,'retrieve', handles)
