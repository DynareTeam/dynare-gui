function varargout = Dynare_GUI(varargin)
% DYNARE_GUI MATLAB code for Dynare_GUI.fig
%      DYNARE_GUI, by itself, creates a new DYNARE_GUI or raises the existing
%      singleton*.
%
%      H = DYNARE_GUI returns the handle to a new DYNARE_GUI or the handle to
%      the existing singleton*.
%
%      DYNARE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYNARE_GUI.M with the given input arguments.
%
%      DYNARE_GUI('Property','Value',...) creates a new DYNARE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Dynare_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Dynare_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Dynare_GUI

% Last Modified by GUIDE v2.5 07-Jul-2015 18:58:54

% Modify Matlab's path here if required using the addpath command.
    addpath ./GUILayout-v1p14
    addpath ./GUILayout-v1p14/Patch
    addpath ./resources

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Dynare_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Dynare_GUI_OutputFcn, ...
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
addpath ./resources
addpath ./

% --- Executes just before Dynare_GUI is made visible.
function Dynare_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Dynare_GUI (see VARARGIN)

% Choose default command line output for Dynare_GUI
handles.output = hObject;
movegui(hObject,'center'); 
axes(handles.axes_logo);
I = imread('dynare.jpg');
image(I);

axis off; % Remove axis ticks and numbers
axis image; % Set aspect ratio to obtain square pixels  

setappdata(0, 'bg_color', 'default');
setappdata(0, 'special_color', 'white');
setappdata(0, 'main_figure', hObject);

fileName = 'dynare_gui.mat';

if ~exist(fileName, 'file')
    error = errordlg(sprintf('File %s is missing. The application will be terminated!',fileName) ,'DynareGUI Error','modal');
    waitfor(error);
    %main_figure = getappdata(0, 'main_figure');
    close(hObject);
    return;
end

global dynare_gui_;
global project_info;

load(fileName);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Dynare_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Dynare_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function project_Callback(hObject, eventdata, handles)
% hObject    handle to project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function project_new_Callback(hObject, eventdata, handles)
% hObject    handle to project_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'New project');
gui_new_project(tabId);

% --------------------------------------------------------------------
function project_open_Callback(hObject, eventdata, handles)
% hObject    handle to project_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_open_project(hObject);

% --------------------------------------------------------------------
function project_close_Callback(hObject, eventdata, handles)
% hObject    handle to project_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_close_project(hObject);

% --------------------------------------------------------------------
function project_save_Callback(hObject, eventdata, handles)
% hObject    handle to project_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_save_project(hObject, 'Save');

% --------------------------------------------------------------------
function project_save_as_Callback(hObject, eventdata, handles)
% hObject    handle to project_save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_save_project(hObject, 'Save As');

% --------------------------------------------------------------------
function project_exit_Callback(hObject, eventdata, handles)
% hObject    handle to project_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% TODO: Before quitting check if current project have been modified and ask 'Save changes to current project?'
answer = questdlg('Quit Dynare GUI?','DynareGUI','Yes','No','No')
if(strcmp(answer,'Yes'))
    close;
end



% Model!
% --------------------------------------------------------------------
function model_Callback(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function model_load_Callback(hObject, eventdata, handles)
% hObject    handle to model_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_load_mod_file(hObject);

% --------------------------------------------------------------------
function model_settings_Callback(hObject, eventdata, handles)
% hObject    handle to model_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Model settings');
gui_define_model_settings(tabId);



% --------------------------------------------------------------------
function model_save_snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to model_save_snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function model_load_snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to model_load_snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function model_export_Callback(hObject, eventdata, handles)
% hObject    handle to model_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function model_logfile_Callback(hObject, eventdata, handles)
% hObject    handle to model_logfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% % --------------------------------------------------------------------
% function model_solve_Callback(hObject, eventdata, handles)
% % hObject    handle to model_solve (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% tabId = addTab(hObject, 'Solve the model ', handles);


% Estimation!
% --------------------------------------------------------------------
function estimation_Callback(hObject, eventdata, handles)
% hObject    handle to estimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function estimation_observed_variables_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_observed_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Observed vars. ', handles);


% --------------------------------------------------------------------
function estimation_parameters_shocks_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_parameters_shocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Est. params & shocks ', handles);





% --------------------------------------------------------------------
function estimation_run_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Estimation ', handles);


% --------------------------------------------------------------------
function estimation_run_calibrated_smoother_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_run_calibrated_smoother (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Simulation!
% --------------------------------------------------------------------
function simulation_Callback(hObject, eventdata, handles)
% hObject    handle to simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function simulation_stochastic_Callback(hObject, eventdata, handles)
% hObject    handle to simulation_stochastic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Stoch simul. ', handles);
gui_stoch_simulation(tabId);

% --------------------------------------------------------------------
function simulation_deterministic_Callback(hObject, eventdata, handles)
% hObject    handle to simulation_deterministic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Shocks ', handles);




% --------------------------------------------------------------------
function output_Callback(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function output_shocks_decomposition_Callback(hObject, eventdata, handles)
% hObject    handle to output_shocks_decomposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Shocks decomp. ', handles);


% --------------------------------------------------------------------
function output_conditional_forecast_Callback(hObject, eventdata, handles)
% hObject    handle to output_conditional_forecast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addTab(hObject, 'Cond. forecast ', handles);



% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_product_help_Callback(hObject, eventdata, handles)
% hObject    handle to help_product_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%addTab(hObject, 'Product help ', handles);

% --------------------------------------------------------------------
function help_dynare_manual_Callback(hObject, eventdata, handles)
% hObject    handle to help_dynare_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('dynare.pdf');

% --------------------------------------------------------------------
function help_terms_of_use_Callback(hObject, eventdata, handles)
% hObject    handle to help_terms_of_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId =addTab(hObject, 'Terms of use ', handles);
gui_term_of_use(tabId);

% --------------------------------------------------------------------
function help_about_Callback(hObject, eventdata, handles)
% hObject    handle to help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'About DynareGUI ', handles);
gui_about(tabId);


function newTab = addTab(hObject, title, handles)
[newTab,created] = gui_tabs.add_tab(hObject, title);
