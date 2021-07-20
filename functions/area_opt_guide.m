function varargout = area_opt_guide(varargin)
% AREA_OPT_GUIDE MATLAB code for area_opt_guide.fig
%      AREA_OPT_GUIDE, by itself, creates a new AREA_OPT_GUIDE or raises the existing
%      singleton*.
%
%      H = AREA_OPT_GUIDE returns the handle to a new AREA_OPT_GUIDE or the handle to
%      the existing singleton*.
%
%      AREA_OPT_GUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AREA_OPT_GUIDE.M with the given input arguments.
%
%      AREA_OPT_GUIDE('Property','Value',...) creates a new AREA_OPT_GUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before area_opt_guide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to area_opt_guide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help area_opt_guide

% Last Modified by GUIDE v2.5 09-Jul-2021 16:11:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @area_opt_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @area_opt_guide_OutputFcn, ...
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
global start_flag
start_flag = false;
start_flag = false;

% --- Executes just before area_opt_guide is made visible.
function area_opt_guide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to area_opt_guide (see VARARGIN)

% Choose default command line output for area_opt_guide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% set(handles.texttc,'String','$$T_c$$','interpreter','latex')

% UIWAIT makes area_opt_guide wait for user response (see UIRESUME)
uiwait(handles.figure_gui);


% --- Outputs from this function are returned to the command line.
function varargout = area_opt_guide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = get(handles.pushstart,'UserData');
varargout{2} = get(handles.listbox1,'Value');
add_const_vec = false(1,3);
add_const_vec(1) = boolean(get(handles.checkdistconst,'Value'));
add_const_vec(2) = boolean(get(handles.checkpinconst,'Value'));
add_const_vec(3) = boolean(get(handles.checkgravconst,'Value'));
varargout{3} = add_const_vec;
if get(handles.radiopbd1,'Value')==1
    varargout{4} = 0;
elseif get(handles.radiopbd2,'Value')==1
    varargout{4} = 1;
end
editmaxiter_st = get(handles.editmaxiter,'String');
editmaxiter_num = str2double(editmaxiter_st);
edittc_st = get(handles.edittc,'String');
edittc_num = str2double(edittc_st);

varargout{5} = editmaxiter_num;
varargout{6} = edittc_num;

delete(hObject);
% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in checkdistconst.
function checkdistconst_Callback(hObject, eventdata, handles)
% hObject    handle to checkdistconst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkdistconst


% --- Executes on button press in checkpinconst.
function checkpinconst_Callback(hObject, eventdata, handles)
% hObject    handle to checkpinconst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkpinconst


% --- Executes on button press in checkgravconst.
function checkgravconst_Callback(hObject, eventdata, handles)
% hObject    handle to checkgravconst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkgravconst



function editmaxiter_Callback(hObject, eventdata, handles)
% hObject    handle to editmaxiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editmaxiter as text
%        str2double(get(hObject,'String')) returns contents of editmaxiter as a double


% --- Executes during object creation, after setting all properties.
function editmaxiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editmaxiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in pushstart.
function pushstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    editmaxiter_st = get(handles.editmaxiter,'String');
    editmaxiter_num = str2double(editmaxiter_st);
    edittc_st = get(handles.edittc,'String');
    edittc_num = str2double(edittc_st);

    if isnan(editmaxiter_num) || isnan(edittc_num)
        warndlg('Please enter a valid number','Invalid Number');
    else
        if (floor(editmaxiter_num)==editmaxiter_num) && (edittc_num>0 && edittc_num<=1)
            set(hObject,'UserData',true);
            close(handles.figure_gui); 
        elseif floor(editmaxiter_num)~=editmaxiter_num
            warndlg('Please enter an integer for maximum number of iterations','Invalid Number');
        elseif edittc_num<=0 || edittc_num>=1 
            warndlg('Please enter a number between 0 and 1 for Tc','Invalid Number');
        end
    end



% --- Executes when user attempts to close figure_gui.
function figure_gui_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end



function edittc_Callback(hObject, eventdata, handles)
% hObject    handle to edittc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edittc as text
%        str2double(get(hObject,'String')) returns contents of edittc as a double


% --- Executes during object creation, after setting all properties.
function edittc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edittc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
