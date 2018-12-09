function varargout = Resuspension_GUI(varargin)

% Resuspension_GUI M-file for Resuspension_GUI.fig
%      Resuspension_GUI, by itself, creates a new Resuspension_GUI or raises the existing
%      singleton*.
%
%      H = Resuspension_GUI returns the handle to a new Resuspension_GUI or the handle to
%      the existing singleton*.
%
%      Resuspension_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Resuspension_GUI.M with the given input arguments.
%
%      Resuspension_GUI('Property','Value',...) creates a new Resuspension_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the Resuspension_GUI before Resuspension_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Resuspension_GUI_OpeningFcn via varargin.
%
%      *See Resuspension_GUI Options on GUIDE's Tools menu.  Choose "Resuspension_GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Resuspension_GUI

% Last Modified by GUIDE v2.5 09-Mar-2017 11:59:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Resuspension_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Resuspension_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Resuspension_GUI is made visible.
function Resuspension_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Resuspension_GUI (see VARARGIN)
clearvars -global
% Choose default command line output for Resuspension_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Resuspension_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

[~,~,~] = property();

cpath = getcurrentdir();
if isdeployed
    diary([cpath '\ErrorLog.log']);
end %if

set(handles.text1,'string','0')
initial_resetall(handles)
% Check for updates
checkupdate_Callback(hObject, eventdata, handles)


% --- Outputs from this function are returned to the command line.
function varargout = Resuspension_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function import_Callback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
defaultpath = getcurrentdir();
[filename1,filepath1]=uigetfile({'*.xls;*.xlsx','Excel Files'},...
  'Select Input Data Files to Import',defaultpath,'MultiSelect','on');
if (isa(filename1,'double'))
    return
end %if
addnew(2,filename1,filepath1,hObject, eventdata, handles)
if (iscell(filename1) == 1)
    txt = {[num2str(size(filename1,2)), ' files were imported, saved in MAT-files and added.'];...
        'You can find the saved files in the same folder'};
else
    txt = {'One file is imported, saved in MAT-file and added.';...
        'You can find the saved file in the same folder'};

end %if
readytogo(handles)
msgbox(txt,'Import','Help','modal');

% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
defaultpath = getcurrentdir();
[filename1,filepath1]=uigetfile({'*.mat','MAT Files'},...
  'Select Input Data Files to Open',defaultpath,'MultiSelect','on');
if (isa(filename1,'double'))
    return
end %if
addnew(1,filename1,filepath1,hObject, eventdata, handles)
if (iscell(filename1) == 1)
    txt = [num2str(size(filename1,2)), ' files were added'];
else
    txt = 'One file was added';
end %if
readytogo(handles)
msgbox(txt,'Open','Help','modal');

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fig2 = figure();
copyobj(handles.axes1, Fig2);
hgsave(Fig2, 'myFigure.fig');
saveas(Fig2, 'myFigure.png','png');
delete(Fig2);


% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(handles.figure1, eventdata, handles)

% --------------------------------------------------------------------
function view_Callback(hObject, eventdata, handles)
% hObject    handle to view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function filled_Callback(hObject, eventdata, handles)
% hObject    handle to filled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gsettings
if (strcmp(get(hObject,'Checked'),'on') == 1)
    gsettings.markerfill = 0;
%     set(hObject,'Checked','off')
else
    gsettings.markerfill = 1;
%     set(hObject,'Checked','on')
end%if
general_settings(1,handles)

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ver_no, ver_m] = gui_ver();
% temp = [char(169) ' 2014. All Rights Reserved.'];
% helpdlg({'Version: Beta'; 'Developer: Babak Nasr';'Prof. S. Dhaniyala Group';temp},'About')
helpdlg(ver_m,'About')

function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pplot
pplot = 0;
select = get(handles.listbox1,'Value');
resetall(handles)
plotit(select,handles)


% --- Executes on button press in plotbutton.
function plotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x y l ll hll parlist xselect yselect pplot newx newy newl newll newhll lbond
persistent pselectedl
if (isempty(pselectedl) == 1)
    pselectedl = '';
end %if
waitfunc(1,'retrieve', handles)
j = 0;
selectedl = {};
qty = [];
for i=1:size(parlist,1)
    if (parlist{i,1} == true)
        j = j + 1;
        selectedl{j} = parlist{i,2};
        [~, qty(j)] = detect(selectedl{j});
    end %if
end %i
% sum(qty) == 2 means that there are only two qty parameters when the
% number of parameters are 3
if (((j > 0) && (j < 3))) || ((j == 3) && (sum(qty) == 2))
    if (length(selectedl) == length(pselectedl))
        if (all(strcmp(selectedl,pselectedl)) == 0)
            pplot = 0;
        end %if
    else
        pplot = 0;
    end %if
    [parlist,newx,newy,newll,newhll] = global_refinement(x,y,ll,hll,1,parlist);
    newtable = settable(parlist,get(handles.checkboxrefine,'Value'));
    set(handles.uitable2,'Data',newtable);
%     [l, bond] = plotset(selectedl,l,parlist);
    [newl, lbond] = plotset(selectedl,newll,parlist);
    
%     assignin('base', 'x', x);
%     assignin('base', 'y', y);
%     assignin('base', 'newx', newx);
%     assignin('base', 'newy', newy);
%     assignin('base', 'l', l);
%     assignin('base', 'newl', newl);
%     assignin('base', 'll', ll);
%     assignin('base', 'newll', newll);
%     assignin('base', 'handles', handles);
    
    switch pplot
        case 0
            resetall(handles)
            legendset(newx,newy,newl,lbond,hObject, eventdata, handles)
%             legendsetrefine(newx,newy,newl,bond,hObject, eventdata, handles)
            xlabel([xselect ' (' punit(xselect) ')'],'fontWeight','bold')
            ylabel([yselect ' (' punit(yselect) ')'],'fontWeight','bold')
            ylim('auto')
            xlim('auto')
%             set(handles.refinebutton,'Visible','on')
            pplot = 1;
        case 1
%             disp(':D')
            xlimit = get(handles.axes1,'XLim');
            ylimit = get(handles.axes1,'YLim');
            legendset(newx,newy,newl,lbond,hObject, eventdata, handles)
%             legendsetrefine(newx,newy,newl,bond,hObject, eventdata, handles)
            set(handles.axes1,'XLim',xlimit,'YLim',ylimit)
    end %switch
    xrange = get(handles.axes1,'XLim');
    yrange = get(handles.axes1,'YLim');
    set(handles.yminedit,'String',yrange(1))
    set(handles.ymaxedit,'String',yrange(2))
    set(handles.xminedit,'String',xrange(1))
    set(handles.xmaxedit,'String',xrange(2))
    pselectedl = selectedl;
else
    if (j > 3)
        msgbox('Please Select at most three parameters', 'Too Many Arguments','Warn','modal')
    else
        if (j == 3)
            msgbox({'Please Select two quantitative and one qualitative parameters in triple selection.'}, 'Wrong Selection','Warn','modal')
        else
            msgbox('Please Select at least one parameter', 'Wrong Selection','Warn','modal')
        end %if
    end %if
end %if
waitfunc(0,'retrieve', handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

popupmenues(handles)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

popupmenues(handles)



% --- Executes on button press in ylog.
function ylog_Callback(hObject, eventdata, handles)
% hObject    handle to ylog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ylog



% --------------------------------------------------------------------
function selectpoint_OffCallback(hObject, eventdata, handles)
% hObject    handle to selectpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
datacursormode off

% --------------------------------------------------------------------
function selectpoint_OnCallback(hObject, eventdata, handles)
% hObject    handle to selectpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
dcm_obj = datacursormode;
set(dcm_obj,'DisplayStyle','window','SnapToDataVertex','on',...
    'UpdateFcn', @selectedpoint)
datacursormode on



function minedit_Callback(hObject, eventdata, handles)
% hObject    handle to minedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minedit as text
%        str2double(get(hObject,'String')) returns contents of minedit as a double
min1 = str2double(get(handles.minedit,'String'));
max1 = str2double(get(handles.maxedit,'String'));
if (min1 < max1)
    legendchanged(1,handles)
else
    msgbox('Wrong Input!','Error','Error','modal')
    return
end %if

% --- Executes during object creation, after setting all properties.
function minedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxedit_Callback(hObject, eventdata, handles)
% hObject    handle to maxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxedit as text
%        str2double(get(hObject,'String')) returns contents of maxedit as a double
min1 = str2double(get(handles.minedit,'String'));
max1 = str2double(get(handles.maxedit,'String'));
if (min1 < max1)
    legendchanged(1,handles)
else
    warndlg('Wrong Input!','Error','Error','modal')
    return
end %if

% --- Executes during object creation, after setting all properties.
function maxedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minedit2_Callback(hObject, eventdata, handles)
% hObject    handle to minedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minedit2 as text
%        str2double(get(hObject,'String')) returns contents of minedit2 as a double
min2 = str2double(get(handles.minedit2,'String'));
max2 = str2double(get(handles.maxedit2,'String'));
if (min2 < max2)
    legendchanged(1,handles)
else
    msg = msgbox('Wrong Input!','Error','Error','modal');
    return
end %if

% --- Executes during object creation, after setting all properties.
function minedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxedit2_Callback(hObject, eventdata, handles)
% hObject    handle to maxedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxedit2 as text
%        str2double(get(hObject,'String')) returns contents of maxedit2 as a double
min2 = str2double(get(handles.minedit2,'String'));
max2 = str2double(get(handles.maxedit2,'String'));
if (min2 < max2)
    legendchanged(1,handles)
else
    warndlg('Wrong Input!','Error','Error','modal')
    return
end %if

% --- Executes during object creation, after setting all properties.
function maxedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function qtylegrev_Callback(hObject, eventdata, handles)
% hObject    handle to qtylegrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gsettings
if (strcmp(get(hObject,'Checked'),'on') == 1)
    gsettings.qtyrl = 0;
%     set(hObject,'Checked','off')
else
    gsettings.qtyrl = 1;
%     set(hObject,'Checked','on')
end%if
general_settings(1,handles)

% --------------------------------------------------------------------
function qlylegrev_Callback(hObject, eventdata, handles)
% hObject    handle to qlylegrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gsettings
if (strcmp(get(hObject,'Checked'),'on') == 1)
    gsettings.qlyrl = 0;
%     set(hObject,'Checked','off')
else
    gsettings.qlyrl = 1;
%     set(hObject,'Checked','on')
end%if
general_settings(1,handles)

% --- Executes on button press in checkboxrefine.
function checkboxrefine_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxrefine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxrefine
global ll parlist resetg pplot
resetg = 1;
switch get(hObject,'Value')
    case 0
        set(handles.realtimecheckbox,'Enable','off')
        %reset refinments in parlist
        tableget = get(handles.uitable2,'Data');
        parlist = minmaxvalues(ll);
        for i=1:size(parlist,1)
            parlist{i,1} = tableget{i,1};
        end %i
        newtable = settable(parlist,0);
        set(handles.uitable2,'Data',newtable,'ColumnName',{'','Available Parameters','Unit','Min','Max','Qualitative Values'},...
            'ColumnFormat',{'logical','char','char','char','char','char'},'ColumnWidth',{20,'auto','auto','auto','auto','auto'},...
            'ColumnEditable',[true false false false false false])
        set(handles.resetrefinebutton,'Enable','off')
        pplot = 0;
    case 1
        set(handles.realtimecheckbox,'Enable','on')
        newtable = settable(parlist,1);
        set(handles.uitable2,'Data',newtable,'ColumnName',...
            {'','Available Parameters','Unit','Min','Max','Adj. Min','Adj. Max','NaN','Qualitative Values'},...
            'ColumnFormat',{'logical','char','char','char','char','char','char','logical','char'},...
            'ColumnWidth',{20,'auto','auto','auto','auto','auto','auto',30,'auto'},...
            'ColumnEditable',[true false false false false true true true false])
        set(handles.resetrefinebutton,'Enable','on')      
end %switch get(hObject,'Value')


% --- Executes when selected cell(s) is changed in uitable2.
function uitable2_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
global parlist

selection = eventdata.Indices;
if (size(selection,1) == 1)
    tableget = get(hObject,'Data');
    switch get(handles.checkboxrefine,'Value')
        case 1
            if (selection(2) == 9) && (isempty(tableget{selection(1),selection(2)}) == 0)
                set(handles.uitablechoose,'Data',parlist{selection(1),9},...
                    'ColumnName',{'','Value'},'ColumnFormat',{'logical' 'char'},...
                    'ColumnWidth',{20,120},'ColumnEditable',[true false],'Visible','on')
                set(handles.cancelchoose,'visible','on')
                set(handles.choosepanel,'Title',parlist{selection(1),2},'Visible','on')
                %Enable off
                setenable('off',hObject, eventdata, handles)
            end %if
        case 0
            if (selection(2) == 6) && (isempty(tableget{selection(1),selection(2)}) == 0)
                set(handles.uitablechoose,'Data',parlist{selection(1),9}(:,2),...
                    'ColumnName',{'Value'},'ColumnFormat',{'char'},...
                    'ColumnWidth',{120},'ColumnEditable',[false],'Visible','on')
                set(handles.cancelchoose,'visible','off')
                set(handles.choosepanel,'Title',parlist{selection(1),2},'Visible','on')
                %Enable off
                setenable('off',hObject, eventdata, handles)
                
%                 uistack(handles.uitable2,'bottom')
%                 uistack(handles.uitablechoose,'top')
%                 uistack(handles.okchoose,'top')
%                 uistack(handles.cancelchoose,'top')
%                 uistack(handles.choosepanel,'top')
            end %if
    end %switch
end %if


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global x y ll hll parlist
%persistent newx newy newl newll
% if (isempty(newll) == 1) || (resetg == 1)
%     newll = ll;
%     newl = l;
%     newy = y;
%     newx = x;
%     resetg = 0;
% end %if
er = [0, 0];
if (get(handles.checkboxrefine,'Value') == 1)
    tableget = get(hObject,'Data');
    [er, err] = checkrefine2(tableget,eventdata.Indices,eventdata.NewData);
    if (er(1) > 0) || (er(2) > 0)
        eventdata.NewData = eventdata.PreviousData;
        refreshtable = settable(parlist,1);
        set(hObject,'Data',refreshtable)
    end %if
end %if
parlist{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.NewData;
if (get(handles.realtimecheckbox,'Value') == 1)
    if ((er(1) == 0) && (er(2) == 0) && (eventdata.Indices(2) >= 6) && (xor((strcmpi(eventdata.NewData,'min') == 0),(strcmpi(eventdata.NewData,'max') == 0)) == 0))
        istart = eventdata.Indices(1);
        [parlist,~,~,~] = global_refinement(x,y,ll,hll,istart,parlist);
        
%         [newx, newy, newll] = refine2(x,y,ll,eventdata.Indices(1),parlist);
%         for i=1:size(parlist,1)
%             if (i ~= eventdata.Indices(1))
%                 [newx, newy, newll] = refine2(newx,newy,newll,i,parlist);
%             end %if
%         end %i
%         list2 = minmaxvalues(newll);
%         for i=1:size(parlist,1)
%             parlist{i,6} = list2{i,4};
%             parlist{i,7} = list2{i,5};
%             if (isempty(parlist{i,9}) == 0)
%                 for j=1:size(parlist{i,9},1)
%                     parlist{i,9}{j,1} = false;
%                     for k=1:size(list2{i,9},1)
%                         if (strcmp(parlist{i,9}{j,2},list2{i,9}{k,2}) == 1)
%                             parlist{i,9}{j,1} = true;
%                             break
%                         end %if
%                     end %k
%                 end %j
%             end %if
%         end %i
        
        newtable = settable(parlist,1);
        set(hObject,'Data',newtable);
    end %if
end %if
if (er(1) > 0)
    msgbox(err,'Input error','Error','modal')
end %if


% --- Executes on button press in realtimecheckbox.
function realtimecheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to realtimecheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of realtimecheckbox


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% diary('off') % ACTIVATE IT LATER
delete(hObject);


% --- Executes on button press in okchoose.
function okchoose_Callback(hObject, eventdata, handles)
% hObject    handle to okchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global parlist x y ll hll
switch get(handles.checkboxrefine,'Value')
    case 1
        valueget = get(handles.uitablechoose,'Data');
        j = 0;
        for i=1:size(valueget,1)
            if (valueget{i,1} == true)
                j = j + 1;
            end %if
        end %i
        if (j > 0)
            index = find(strcmp(parlist(:,2),get(handles.choosepanel,'Title')),1);
            parlist{index,9} = valueget;
            if (get(handles.realtimecheckbox,'Value') == 1)
                istart = index;
                [parlist,~,~,~] = global_refinement(x,y,ll,hll,istart,parlist);    
            end %if
            newtable = settable(parlist,1);
            set(handles.uitable2,'Data',newtable);
            set(handles.choosepanel,'Visible','off')
            setenable('on',hObject, eventdata, handles)
        else
            msgbox('Please select at least one value','Selection','Warn','modal')
        end %if
    case 0
        set(handles.choosepanel,'Visible','off')
        setenable('on',hObject, eventdata, handles)
end %switch
        

% --- Executes on button press in cancelchoose.
function cancelchoose_Callback(hObject, eventdata, handles)
% hObject    handle to cancelchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.choosepanel,'Visible','off')
setenable('on',hObject, eventdata, handles)


% --- Executes on button press in applychangebutton.
function applychangebutton_Callback(hObject, eventdata, handles)
% hObject    handle to applychangebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
applylegchanges(handles)

% --- Executes when entered data in editable cell(s) in legendtable.
function legendtable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to legendtable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
tableget = get(hObject,'Data');
j = 0;
for i=1:size(tableget,1)
    if (tableget{i,1} == true)
        j = j + 1;
    end %if
end %i
if (j == 0)
    tableget{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    set(hObject,'Data',tableget);
end %if
legendchanged(1,handles)

% --- Executes when entered data in editable cell(s) in legendtable2.
function legendtable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to legendtable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
tableget = get(hObject,'Data');
j = 0;
for i=1:size(tableget,1)
    if (tableget{i,1} == true)
        j = j + 1;
    end %if
end %i
if (j == 0)
    tableget{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    set(hObject,'Data',tableget);
end %if
legendchanged(1,handles)


% --------------------------------------------------------------------
function view2d_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to view2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
view(2)
set(handles.rotate3d,'State','off')


% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function rebuild_menu_Callback(hObject, eventdata, handles)
% hObject    handle to rebuild_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% creat new window and its object
description = 'Select parameter, then appropriate criteria to eliminate remain data-points.';
h2.fig = dialog('WindowStyle', 'modal', 'Name', 'Regenerate DataSet',...
    'Position',[520 650 299 159]);
h2.maintext = uicontrol('style','text','position',[10 115 276 37],...
    'string',description,'HorizontalAlignment','left');
h2.text1 = uicontrol('style','text','position',[10 83 148 15],...
    'string','Select Parameter:','HorizontalAlignment','left');
h2.text2 = uicontrol('style','text','position',[196 83 91 15],...
    'string','Select Criteria:','HorizontalAlignment','left');
h2.popup1 = uicontrol('style','popupmenu','position',[10 59 150 21],...
    'string',{'Select'},'BackgroundColor',[1 1 1]);
h2.popup2 = uicontrol('style','popupmenu','position',[196 59 93 21],...
    'string',{'Max','Mean','Median','Min'},'BackgroundColor',[1 1 1]);
h2.button1 = uicontrol('style','pushbutton','position',[62 9 80 26],...
    'string','OK','Callback',{@reduce_OK_Callback,h2,handles});
h2.button2 = uicontrol('style','pushbutton','position',[162 9 80 26],...
    'string','Cancel','Callback',{@reduce_Cancel_Callback,h2});
%*******
list = get(handles.popupmenu1,'string');
set(h2.popup1,'string',list);



function reduce_OK_Callback(hObject, eventdata, h2, handles)
global wd whd iwd iwhd
if ((isempty(iwd) == 1) && (isempty(iwhd) == 1))
    iwd = wd;
    iwhd = whd;
end %if
waitfunc(1,'rebuilt', handles)
list = get(h2.popup1,'String');
i = get(h2.popup1,'Value');
if iscell(list) == 1
    par = list{i};
else
    par = list;
end %if
olist = get(h2.popup2,'String');
j = get(h2.popup2,'Value');
[wd, whd] = rebuilt(wd,whd,par,olist{j});
alist = checkdata(wd);
adddata2(alist,hObject,eventdata,handles);
set(handles.initial_dataset,'Enable','on')
set(handles.alerttext,'Visible','on')
popupmenues(handles);
delete(h2.fig);
waitfunc(0,'rebuilt', handles)
assignin('base', 'whd', whd);
assignin('base', 'wd', wd);

function reduce_Cancel_Callback(hObject, eventdata, h2)

delete(h2.fig);


% --------------------------------------------------------------------
function initial_dataset_Callback(hObject, eventdata, handles)
% hObject    handle to initial_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global wd whd iwd iwhd parlist
wd = iwd;
whd = iwhd;
clear iwd iwhd
alist = checkdata(wd);
adddata2(alist,hObject,eventdata,handles);
set(handles.initial_dataset,'Enable','off')
set(handles.alerttext,'Visible','off')
popupmenues(handles);
msgbox('The initial DataSet has been set','Initialize','Help','modal')


% --------------------------------------------------------------------
function analysis_m_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function analysis_detach_Callback(hObject, eventdata, handles)
% hObject    handle to analysis_detach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theory_readytogo(handles)

% --- Executes on button press in sublayercheckbox.
function sublayercheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to sublayercheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sublayercheckbox


% --- Executes on button press in burstcheckbox.
function burstcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to burstcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of burstcheckbox


% --- Executes on button press in liftingcheckbox.
function liftingcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to liftingcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of liftingcheckbox


% --- Executes on button press in slidingcheckbox.
function slidingcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to slidingcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of slidingcheckbox
theory_propdetect(handles)

% --- Executes on button press in rollingcheckbox.
function rollingcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to rollingcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rollingcheckbox


% --- Executes on button press in jkrcheckbox.
function jkrcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to jkrcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of jkrcheckbox


% --- Executes on button press in dmtcheckbox.
function dmtcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to dmtcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dmtcheckbox


% --- Executes on button press in tplcheckbox.
function tplcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to tplcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tplcheckbox
theory_propdetect(handles)


function snameedit_Callback(hObject, eventdata, handles)
% hObject    handle to snameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of snameedit as text
%        str2double(get(hObject,'String')) returns contents of snameedit as a double


% --- Executes during object creation, after setting all properties.
function snameedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pnameedit_Callback(hObject, eventdata, handles)
% hObject    handle to pnameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pnameedit as text
%        str2double(get(hObject,'String')) returns contents of pnameedit as a double


% --- Executes during object creation, after setting all properties.
function pnameedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pnameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mediumedit_Callback(hObject, eventdata, handles)
% hObject    handle to mediumedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mediumedit as text
%        str2double(get(hObject,'String')) returns contents of mediumedit as a double


% --- Executes during object creation, after setting all properties.
function mediumedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mediumedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backbutton.
function backbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in mediumuipanel.
function mediumuipanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in mediumuipanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
s(1) = handles.mediumradiobutton1;
s(2) = handles.mediumradiobutton2;
switch eventdata.NewValue
    case s(1)
        set(handles.mediumedit,'Enable','off')
    case s(2)
        set(handles.mediumedit,'Enable','on')
end %switch
theory_propdetect(handles)



function minsizeedit_Callback(hObject, eventdata, handles)
% hObject    handle to minsizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minsizeedit as text
%        str2double(get(hObject,'String')) returns contents of minsizeedit as a double


% --- Executes during object creation, after setting all properties.
function minsizeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minsizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxsizeedit_Callback(hObject, eventdata, handles)
% hObject    handle to maxsizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxsizeedit as text
%        str2double(get(hObject,'String')) returns contents of maxsizeedit as a double


% --- Executes during object creation, after setting all properties.
function maxsizeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxsizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onesizeedit_Callback(hObject, eventdata, handles)
% hObject    handle to onesizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onesizeedit as text
%        str2double(get(hObject,'String')) returns contents of onesizeedit as a double


% --- Executes during object creation, after setting all properties.
function onesizeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onesizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in outuipanel.
function outuipanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in outuipanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
s(1) = handles.rangeradiobutton;
s(2) = handles.oneradiobutton;
switch eventdata.NewValue
    case s(1)
        set(handles.minsizeedit,'Enable','on')
        set(handles.maxsizeedit,'Enable','on')
        set(handles.onesizeedit,'Enable','off')
    case s(2)
        set(handles.onesizeedit,'Enable','on')
        set(handles.minsizeedit,'Enable','off')
        set(handles.maxsizeedit,'Enable','off')
end %switch


% --- Executes on button press in loaddpushbutton.
function loaddpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loaddpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theory_considerload(handles)


% --- Executes on button press in savedpushbutton.
function savedpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to savedpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theory_considersave(handles)


% --- Executes on button press in deletedpushbutton.
function deletedpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to deletedpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theory_deletedb()


% --- Executes on button press in trunpushbutton.
function trunpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to trunpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theory_checkrun(handles)



function hydraulicdedit_Callback(hObject, eventdata, handles)
% hObject    handle to hydraulicdedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hydraulicdedit as text
%        str2double(get(hObject,'String')) returns contents of hydraulicdedit as a double


% --- Executes during object creation, after setting all properties.
function hydraulicdedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hydraulicdedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in velocityuipanel.
function velocityuipanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in velocityuipanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
s = handles.velocityradiobutton3;
if (eventdata.NewValue == s)
    set(handles.hydraulicdedit,'Enable','on')
end %if
if (eventdata.OldValue == s)
    set(handles.hydraulicdedit,'Enable','off')
end %if


% --------------------------------------------------------------------
function axes_menu_Callback(hObject, eventdata, handles)
% hObject    handle to axes_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function xaxislog_m_Callback(hObject, eventdata, handles)
% hObject    handle to xaxislog_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (strcmp(get(hObject,'Checked'),'off') == 1)
    set(handles.axes1,'XScale','Log')
    set(hObject,'Checked','on')
    set(handles.xlog,'State','on')
else
    set(handles.axes1,'XScale','Linear')
    set(hObject,'Checked','off')
    set(handles.xlog,'State','off')
end %if


% --------------------------------------------------------------------
function yaxislog_m_Callback(hObject, eventdata, handles)
% hObject    handle to yaxislog_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (strcmp(get(hObject,'Checked'),'off') == 1)
    set(handles.axes1,'YScale','Log')
    set(hObject,'Checked','on')
    set(handles.ylog,'State','on')
else
    set(handles.axes1,'YScale','Linear')
    set(hObject,'Checked','off')
    set(handles.ylog,'State','off')
end %if

% --------------------------------------------------------------------
function axeslimits_m_Callback(hObject, eventdata, handles)
% hObject    handle to axeslimits_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xl = get(handles.axes1,'Xlim');
yl = get(handles.axes1,'Ylim');
def = {num2str(xl(1)), num2str(xl(2)), num2str(yl(1)), num2str(yl(2))};
prompt = {'X min:','X max:','Y min:','Y max:'};
dlg_title = 'Axes Limits';
num_lines = 1;
axeslimit = inputdlg(prompt,dlg_title,num_lines,def);
if (isempty(axeslimit) == 0)
    x1 = str2double(axeslimit{1});
    x2 = str2double(axeslimit{2});
    y1 = str2double(axeslimit{3});
    y2 = str2double(axeslimit{4});
    if ((isnan(x1) == 0) && (isnan(x2) == 0) && (isnan(y1) == 0) && (isnan(y2) == 0))
        if ((x1 < x2) && (y1 < y2))
            set(handles.axes1,'Xlim',[x1 x2],...
                'Ylim',[y1 y2])
        end %if
    end %if
end %if


% --- Executes on button press in smoothcheckbox.
function smoothcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to smoothcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smoothcheckbox


% --- Executes on button press in roughcheckbox.
function roughcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to roughcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roughcheckbox


% --- Executes on button press in roughppushbutton.
function roughppushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to roughppushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rough_par
if (isempty(rough_par) == 1)
    rough_par.betap = .02;
    rough_par.Deltac = 1;
    rough_par.Nbump = 20;
%     rough_par.n_b = 2;
    rough_par.Rb_Dp = .1;
    rough_par.n_u = 1;
    rough_par.alpha = pi/6;
end %if
def = {num2str(rough_par.betap), num2str(rough_par.Deltac), num2str(rough_par.Nbump), num2str(rough_par.Rb_Dp)};
prompt = {'beta/Dp (between 0 and 1):','Delta_c (between 0 and 1):','Number of Bumps:','Rb/Dp:'};
dlg_title = 'Roughness Parameters';
num_lines = 1;
roughp = inputdlg(prompt,dlg_title,num_lines,def);
if (isempty(roughp) == 0)
   betap = str2double(roughp{1});
   Deltac = str2double(roughp{2});
   Nbump = str2double(roughp{3});
%    n_b = str2double(roughp{4});
   Rb_Dp = str2double(roughp{4});
   if ((betap > 0) &&  (Deltac > 0) &&  (Nbump > 0) && ((Rb_Dp > 0) && (Rb_Dp <= 1)))
       rough_par.betap = betap;
       rough_par.Deltac = Deltac;
       rough_par.Nbump = Nbump;
%        rough_par.n_b = n_b;
       rough_par.Rb_Dp = Rb_Dp;
   else
       msgbox('Wrong Input','Roughness Parameters','warn','modal');
   end %if
end %if

    


% --------------------------------------------------------------------
function grid_m_Callback(hObject, eventdata, handles)
% hObject    handle to grid_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
if (strcmp(get(hObject,'Checked'),'off') == 1)
    grid on
    set(hObject,'Checked','on')
else
    grid off
    set(hObject,'Checked','off')
end %if


% --- Executes on button press in backpushbutton.
function backpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global wd
if (isempty(wd) == 0)
    readytogo(handles)
else
    set(handles.theorypanel,'Visible','off')
    set(handles.backpushbutton,'Visible','off')
    set(handles.tools_menu,'Enable','on')
    axes(handles.axes1);
    cla(handles.axes1);
    set(handles.axes1,'XScale','Linear','YScale','Linear')
    axis auto
    legend('off')
    xlabel('')
    ylabel('')
    title('')
    
end %if


% --- Executes on button press in tfuncpushbutton.
function tfuncpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tfuncpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global funcselection
if (isempty(funcselection) == 0)
    iv = funcselection;
else
    iv = 1;
end %if
list = {'Soltani, Ahmadi(1994&1995) Closed form expression','Numerical Approach'};
[s,ok] = listdlg('Name','Function',...
    'PromptString',{'Please select a function'},...
    'SelectionMode','single','ListString',list,'ListSize',[300 200],'InitialValue',iv);
if (ok == 1)
    funcselection = s;
end %if


% --------------------------------------------------------------------
function openplot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% f = findobj('Tag','figure1')
Fig2 = figure('Name','Plot');
copyobj(handles.axes1, Fig2);
% plotly1 = fig2plotly(Fig2);


% --- Executes on button press in tcomparepushbutton.
function tcomparepushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to tcomparepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% theory_plotexpoints(handles)
global compareexp
waitfunc(1,'fit', handles)
[tdb,points,er] = fit_compare(compareexp.Dp,compareexp.velocity);
theory_plotexpoints(handles,tdb,points,er)
waitfunc(0,'fit', handles)

% --------------------------------------------------------------------
function xlog_OffCallback(hObject, eventdata, handles)
% hObject    handle to xlog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1, 'XScale', 'linear')
set(handles.xaxislog_m,'Checked','off')

% --------------------------------------------------------------------
function xlog_OnCallback(hObject, eventdata, handles)
% hObject    handle to xlog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1, 'XScale', 'log')
set(handles.xaxislog_m,'Checked','on')


% --------------------------------------------------------------------
function ylog_OffCallback(hObject, eventdata, handles)
% hObject    handle to ylog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1, 'YScale', 'linear')
set(handles.yaxislog_m,'Checked','off')
    

% --------------------------------------------------------------------
function ylog_OnCallback(hObject, eventdata, handles)
% hObject    handle to ylog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1, 'YScale', 'log')
set(handles.yaxislog_m,'Checked','on')


% --------------------------------------------------------------------
function idea1_m_Callback(hObject, eventdata, handles)
% hObject    handle to idea1_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pplot
list = get(handles.listbox1,'String');
[s,ok] = listdlg('Name','Idea 1-single datasets',...
    'PromptString','Please select original dataset',...
    'SelectionMode','single','ListString',list,'ListSize',[400 200]);
if (ok == 1)
    pplot = 0;
    resetall(handles)
    plotit(s,handles)
end %if


% --- Executes on button press in resetrefinebutton.
function resetrefinebutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetrefinebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ll parlist resetg pplot
resetg = 1;
%reset refinments in parlist
tableget = get(handles.uitable2,'Data');
parlist = minmaxvalues(ll);
for i=1:size(parlist,1)
    parlist{i,1} = tableget{i,1};
end %i
newtable = settable(parlist,1);
set(handles.uitable2,'Data',newtable,'ColumnName',...
    {'','Available Parameters','Unit','Min','Max','Adj. Min','Adj. Max','NaN','Qualitative Values'},...
    'ColumnFormat',{'logical','char','char','char','char','char','char','logical','char'},...
    'ColumnWidth',{20,'auto','auto','auto','auto','auto','auto',30,'auto'},...
    'ColumnEditable',[true false false false false true true true false])
pplot = 0;



function xminedit_Callback(hObject, eventdata, handles)
% hObject    handle to xminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xminedit as text
%        str2double(get(hObject,'String')) returns contents of xminedit as a double
xmin = str2double(get(handles.xminedit,'String'));
xmax = str2double(get(handles.xmaxedit,'String'));
if (xmin < xmax)
    set(handles.axes1,'XLim',[xmin xmax])
end %if


% --- Executes during object creation, after setting all properties.
function xminedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmaxedit_Callback(hObject, eventdata, handles)
% hObject    handle to xmaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmaxedit as text
%        str2double(get(hObject,'String')) returns contents of xmaxedit as a double
xmin = str2double(get(handles.xminedit,'String'));
xmax = str2double(get(handles.xmaxedit,'String'));
if (xmin < xmax)
    set(handles.axes1,'XLim',[xmin xmax])
end %if


% --- Executes during object creation, after setting all properties.
function xmaxedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yminedit_Callback(hObject, eventdata, handles)
% hObject    handle to yminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yminedit as text
%        str2double(get(hObject,'String')) returns contents of yminedit as a double
ymin = str2double(get(handles.yminedit,'String'));
ymax = str2double(get(handles.ymaxedit,'String'));
if (ymin < ymax)
    set(handles.axes1,'YLim',[ymin ymax])
end %if


% --- Executes during object creation, after setting all properties.
function yminedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymaxedit_Callback(hObject, eventdata, handles)
% hObject    handle to ymaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymaxedit as text
%        str2double(get(hObject,'String')) returns contents of ymaxedit as a double
ymin = str2double(get(handles.yminedit,'String'));
ymax = str2double(get(handles.ymaxedit,'String'));
if (ymin < ymax)
    set(handles.axes1,'YLim',[ymin ymax])
end %if


% --- Executes during object creation, after setting all properties.
function ymaxedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bumpycheckbox.
function bumpycheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to bumpycheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bumpycheckbox


% --------------------------------------------------------------------
function Conversion_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Conversion_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function free2shear_menu_Callback(hObject, eventdata, handles)
% hObject    handle to free2shear_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global wd whd

if ~isempty(wd) && ~isempty(whd)
    wd = rawdata_free2shear(wd,whd);
end %if
alist = checkdata(wd);
adddata2(alist, hObject, eventdata, handles);

% --------------------------------------------------------------------
function shear2Re_menu_Callback(hObject, eventdata, handles)
% hObject    handle to shear2Re_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global wd whd

if ~isempty(wd) && ~isempty(whd)
    wd = rawdata_shear2Re(wd,whd);
end %if
alist = checkdata(wd);
adddata2(alist, hObject, eventdata, handles);


% --------------------------------------------------------------------
function checkupdate_Callback(hObject, eventdata, handles)
% hObject    handle to checkupdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gsettings
eventdata
% need gsettings.URL & gsettings.ver_URL
[needupdate, local_ver, server_ver] = gui_checkupdate(gsettings);
switch needupdate
    case 1
        update_feedback = questdlg({'New Version Available!';...
            ['Installed Version: ', local_ver];...
            ['Latest Version :   ', server_ver];...
            ' ';
            'Would you like to download the latest version?'},'Check for Update');
        switch update_feedback
            case 'Yes'
                try
                    web(gsettings.URL,'-browser');
                catch
                    errordlg({'Unable to open the following link in browser:';gsettings.URL},'Check for Update')
                end %try
            case {'No', 'Cancel'}

        end %switch (update_feedback)
    case 0 % It is the latest version
        if strcmpi(class(hObject),'matlab.ui.container.Menu')
            msgbox({'Latest version is currently installed';['Current Version: ', local_ver]},'Check for Update');
        end %if
    case -1 % Unable to check for update
        if strcmpi(class(hObject),'matlab.ui.container.Menu')
            errordlg({'Unable to check for update';'Please check from the link bellow:';gsettings.URL},'Check for Update')
        end %if
end %switch (needupdate)

    

