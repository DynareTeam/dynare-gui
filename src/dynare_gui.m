function varargout = dynare_gui(varargin)
% This command runs DYNARE_GUI.
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
%      applied to the GUI before dynare_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dynare_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% Copyright (C) 2001-2015 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dynare_gui_OpeningFcn, ...
    'gui_OutputFcn',  @dynare_gui_OutputFcn, ...
    'gui_LayoutFcn',  @dynare_gui_LayoutFcn, ...
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


end

% --- Executes just before dynare_gui is made visible.
function dynare_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dynare_gui (see VARARGIN)



% Choose default command line output for dynare_gui
handles.output = hObject;
movegui(hObject,'center');
%axes(handles.axes_logo);
%I = imread('dynare.jpg');
%image(I);

%axis off; % Remove axis ticks and numbers
%axis image; % Set aspect ratio to obtain square pixels
global dynare_gui_root;
global dynareroot;

setappdata(0, 'bg_color', 'default');
setappdata(0, 'special_color', 'white');
setappdata(0, 'main_figure', hObject);

dynareroot = dynare_config;
%TODO check with Dynare team/Ratto!!!
% addpath([dynareroot '/missing/stats']);
% addpath([dynareroot '/missing/nanmean']);

warning_config();

evalin('base','clear dynare_gui_ project_info model_settings');
evalin('base','clear M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_');

evalin('base','global dynare_gui_ project_info model_settings');
evalin('base','global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_');

evalin('base','dynare_gui_root = which(''dynare_gui'');');

dynare_gui_root = dynare_gui_root(1: strfind(dynare_gui_root, 'dynare_gui.m')-1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dynare_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = dynare_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --------------------------------------------------------------------
function project_Callback(hObject, eventdata, handles)
% hObject    handle to project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function project_new_Callback(hObject, eventdata, handles)
% hObject    handle to project_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global project_info;

% Close existing project
if(isstruct(project_info) && ~isempty(fieldnames(project_info)) && isfield(project_info, 'project_name') && ~isempty(project_info.project_name))%if(exist('project_info', 'var') == 1) 
    
    try
        gui_close_project();
    catch
    end

end

tabId = addTab(hObject, 'New project');
gui_new_project(tabId);
end

% --------------------------------------------------------------------
function project_open_Callback(hObject, eventdata, handles)
% hObject    handle to project_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global project_info;

% Close existing project
if(isstruct(project_info) && ~isempty(fieldnames(project_info)) && isfield(project_info, 'project_name') && ~isempty(project_info.project_name))%if(exist('project_info', 'var') == 1) 
    try
       gui_close_project();
    catch
    end
end

gui_open_project(hObject);
end

% --------------------------------------------------------------------
function project_close_Callback(hObject, eventdata, handles)
% hObject    handle to project_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_close_project();
end

% --------------------------------------------------------------------
function project_save_Callback(hObject, eventdata, handles)
% hObject    handle to project_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_save_project(hObject, 'Save');
end

% --------------------------------------------------------------------
function project_save_as_Callback(hObject, eventdata, handles)
% hObject    handle to project_save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_save_project(hObject, 'Save As');
end

% --------------------------------------------------------------------
function project_exit_Callback(hObject, eventdata, handles)
% hObject    handle to project_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global project_info;

answer = questdlg('Quit Dynare GUI?','DynareGUI','Yes','No','No');
if(strcmp(answer,'Yes'))
    % Before quitting check if current project have been modified and ask 'Save changes to current project?'
    if(isstruct(project_info) && isfield(project_info, 'project_name') && ~isempty(project_info.project_name) && isfield(project_info, 'modified') && project_info.modified)
        answer = questdlg(sprintf('Do you want to save changes to project %s?', project_info.project_name),'DynareGUI','Yes','No','Cancel','Yes');
        if(strcmp(answer,'Yes'))
            gui_tools.save_project();
        elseif (strcmp(answer,'Cancel'))
            return;
        end
        
    end
    
    %evalin('base','diary off;');
    appdata = getappdata(0);
    fns = fieldnames(appdata);
    for ii = 1:numel(fns)
        rmappdata(0,fns{ii});
    end
    evalin('base','clear all;');
    close;
end
end



% Model!
% --------------------------------------------------------------------
function model_Callback(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function model_load_Callback(hObject, eventdata, handles)
% hObject    handle to model_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_load_mod_file(hObject);
end

% --------------------------------------------------------------------
function model_settings_Callback(hObject, eventdata, handles)
% hObject    handle to model_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%tabId = addTab(hObject, 'Model settings');
%gui_define_model_settings(tabId);
gui_define_model_settings(hObject);
end



% --------------------------------------------------------------------
function model_save_snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to model_save_snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_tools.save_model_snapshot();
end


% --------------------------------------------------------------------
function model_load_snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to model_load_snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_tools.load_model_snapshot();
end


% --------------------------------------------------------------------
function model_export_Callback(hObject, eventdata, handles)
% hObject    handle to model_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_tools.gui_export_to_mod_file();
end


% --------------------------------------------------------------------
function model_logfile_Callback(hObject, eventdata, handles)
% hObject    handle to model_logfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_log_file(hObject);
end



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
end


% --------------------------------------------------------------------
function estimation_observed_variables_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_observed_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Observed vars. ');
gui_observed_vars(tabId);
end


% --------------------------------------------------------------------
function estimation_parameters_shocks_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_parameters_shocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Est. params & shocks ');
gui_estim_params(tabId);
end





% --------------------------------------------------------------------
function estimation_run_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Estimation ', handles);
gui_estimation(tabId);
end

% --------------------------------------------------------------------
function estimation_run_calibrated_smoother_Callback(hObject, eventdata, handles)
% hObject    handle to estimation_run_calibrated_smoother (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Calib. smoother ', handles);
gui_calib_smoother(tabId);
end

% Simulation!
% --------------------------------------------------------------------
function simulation_Callback(hObject, eventdata, handles)
% hObject    handle to simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function simulation_stochastic_Callback(hObject, eventdata, handles)
% hObject    handle to simulation_stochastic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Stoch simul. ', handles);
gui_stoch_simulation(tabId);
end

% --------------------------------------------------------------------
function simulation_deterministic_Callback(hObject, eventdata, handles)
% hObject    handle to simulation_deterministic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Determ simul. ', handles);
gui_determ_simulation(tabId);
end



% --------------------------------------------------------------------
function output_Callback(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function output_shocks_decomposition_Callback(hObject, eventdata, handles)
% hObject    handle to output_shocks_decomposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Shock decomp. ', handles);
gui_shock_decomposition(tabId);
end


% --------------------------------------------------------------------
function output_conditional_forecast_Callback(hObject, eventdata, handles)
% hObject    handle to output_conditional_forecast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Cond. forecast ', handles);
gui_cond_forecast(tabId);
end

% --------------------------------------------------------------------
function output_forecast_Callback(hObject, eventdata, handles)
% hObject    handle to output_conditional_forecast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'Forecast ', handles);
gui_forecast(tabId);
end

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function help_product_help_Callback(hObject, eventdata, handles)
% hObject    handle to help_product_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%addTab(hObject, 'Product help ', handles);
end

% --------------------------------------------------------------------
function help_dynare_manual_Callback(hObject, eventdata, handles)
% hObject    handle to help_dynare_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dynareroot;
ind = strfind(dynareroot, [filesep,'matlab']);
open([dynareroot(1:ind), 'doc', filesep, 'dynare.html', filesep, 'index.html']);
end

% --------------------------------------------------------------------
function help_terms_of_use_Callback(hObject, eventdata, handles)
% hObject    handle to help_terms_of_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId =addTab(hObject, 'Terms of use ', handles);
gui_term_of_use(tabId);
end

% --------------------------------------------------------------------
function help_about_Callback(hObject, eventdata, handles)
% hObject    handle to help_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabId = addTab(hObject, 'About DynareGUI ', handles);
gui_about(tabId);
end


function newTab = addTab(hObject, title, handles)
[newTab,created] = gui_tabs.add_tab(hObject, title);


end


% --- Creates and returns a handle to the GUI figure. 
function h1 = dynare_gui_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'uitoolbar', 2, ...
    'uipushtool', 3, ...
    'uipanel', 4, ...
    'text', 5, ...
    'axes', 2), ...
    'override', 1, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', 'C:\Users\milica\Documents\GitHub\dynare-gui\dynare-gui\src\export\dynare_gui.m', ...
    'lastFilename', 'C:\Users\milica\Documents\GitHub\dynare-gui\dynare-gui\src\Dynare_GUI.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
    'PaperUnits','points',...
    'Units','characters',...
    'Position',[50 30 180 40],...
    'Renderer','painters',...
    'Visible','on',...
    'Color',get(0,'defaultfigureColor'),...
    'CurrentAxesMode','manual',...
    'IntegerHandle','off',...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'MenuBar','none',...
    'Name','Dynare_GUI',...
    'NumberTitle','off',...
    'Resize','on',...
    'PaperPosition',[18 180 576 432],...
    'PaperSize',[841.889736 595.275552],...
    'PaperType','A4',...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'PaperOrientation','landscape',...
    'ScreenPixelsPerInchMode','manual',...
    'HandleVisibility','callback',...
    'Tag','figure1',...
    'UserData',[],...
    'SizeChangedFcn',@resizeui,...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


appdata = [];
appdata.lastValidTag = 'uitoolbar1';

h2 = uitoolbar(...
    'Parent',h1,...
    'Visible','off',...
    'Tag','uitoolbar1',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'project';

h3 = uimenu(...
    'Parent',h1,...
    'Accelerator','M',...
    'Callback',@(hObject,eventdata)dynare_gui('project_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Project',...
    'Tag','project',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'project_new';

h4 = uimenu(...
    'Parent',h3,...
    'Callback',@(hObject,eventdata)dynare_gui('project_new_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','New Project ...',...
    'Tag','project_new',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'project_open';

h5 = uimenu(...
    'Parent',h3,...
    'Callback',@(hObject,eventdata)dynare_gui('project_open_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Open Project ...',...
    'Tag','project_open',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'project_close';

h6 = uimenu(...
    'Parent',h3,...
    'Enable','off',...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('project_close_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Close Project',...
    'Tag','project_close',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'project_save';

h7 = uimenu(...
    'Parent',h3,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('project_save_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Save Project',...
    'Tag','project_save',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'project_save_as';

h8 = uimenu(...
    'Parent',h3,...
    'Enable','off',...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('project_save_as_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Save Project As ...',...
    'Tag','project_save_as',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'project_exit';

h9 = uimenu(...
    'Parent',h3,...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('project_exit_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Exit',...
    'Tag','project_exit',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'model';

h10 = uimenu(...
    'Parent',h1,...
    'Callback',@(hObject,eventdata)dynare_gui('model_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Model',...
    'Tag','model',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'model_load';

h11 = uimenu(...
    'Parent',h10,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('model_load_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Load .mod file',...
    'Tag','model_load',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'model_settings';

h12 = uimenu(...
    'Parent',h10,...
    'Enable','off',...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('model_settings_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Model settings ...',...
    'Tag','model_settings',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'model_save_snapshot';

h13 = uimenu(...
    'Parent',h10,...
    'Enable','off',...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('model_save_snapshot_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Save model snapshot',...
    'Tag','model_save_snapshot',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'model_load_snapshot';

h14 = uimenu(...
    'Parent',h10,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('model_load_snapshot_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Load model snapshot',...
    'Tag','model_load_snapshot',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'model_export';

h15 = uimenu(...
    'Parent',h10,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('model_export_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Export to a .mod file',...
    'Tag','model_export',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'model_logfile';

h16 = uimenu(...
    'Parent',h10,...
    'Enable','off',...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('model_logfile_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Dynare_GUI log file ',...
    'Tag','model_logfile',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Untitled_7';

h17 = uicontextmenu(...
    'Parent',h1,...
    'Callback',@(hObject,eventdata)dynare_gui('Untitled_7_Callback',hObject,eventdata,guidata(hObject)),...
    'Tag','Untitled_7',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'estimation';

h18 = uimenu(...
    'Parent',h1,...
    'Callback',@(hObject,eventdata)dynare_gui('estimation_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Estimation',...
    'Tag','estimation',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'estimation_observed_variables';

h19 = uimenu(...
    'Parent',h18,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('estimation_observed_variables_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Observed variables & data file',...
    'Tag','estimation_observed_variables',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'estimation_parameters_shocks';

h20 = uimenu(...
    'Parent',h18,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('estimation_parameters_shocks_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Estimated parameters & shocks ...',...
    'Tag','estimation_parameters_shocks',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'estimation_run_calibrated_smoother';

h21 = uimenu(...
    'Parent',h18,...
    'Enable','off',...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('estimation_run_calibrated_smoother_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Run calibrated smoother !',...
    'Tag','estimation_run_calibrated_smoother',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'estimation_run';

h22 = uimenu(...
    'Parent',h18,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('estimation_run_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Run estimation !',...
    'Tag','estimation_run',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'simulation';

h23 = uimenu(...
    'Parent',h1,...
    'Callback',@(hObject,eventdata)dynare_gui('simulation_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Simulation',...
    'Tag','simulation',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'simulation_stochastic';

h24 = uimenu(...
    'Parent',h23,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('simulation_stochastic_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Stochastic simulation',...
    'Tag','simulation_stochastic',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'simulation_deterministic';

h25 = uimenu(...
    'Parent',h23,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('simulation_deterministic_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Deterministic simulation',...
    'Tag','simulation_deterministic',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel_welcome';

h26 = uipanel(...
    'Parent',h1,...
    'FontUnits',get(0,'defaultuipanelFontUnits'),...
    'Units','normalized',...
    'Title',blanks(0),...
    'Position',[0 0 1 1],...
    'BackgroundColor',[1 1 1],...
    'Clipping','off',...
    'Tag','uipanel_welcome',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


% 
% h26 = uipanel(...
%     'Parent',h1,...
%     'FontUnits',get(0,'defaultuipanelFontUnits'),...
%     'Units','characters',...
%     'Title',blanks(0),...
%     'Position',[3.57142857142857 0.823529411764706 172.857142857143 38.4117647058824],...
%     'BackgroundColor',[1 1 1],...
%     'Clipping','off',...
%     'Tag','uipanel_welcome',...
%     'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


h_test = uicontrol(...
    'Parent',h1,...
    'Units','normalized',...
    'String','X',...
    'Style','text',...
    'FontSize',28,...
    'FontName','Tahoma',...
    'FontAngle',get(0,'defaultuicontrolFontAngle'),...
    'FontWeight','bold');

default_char_size = get(h_test,'extent');
set(h_test, 'Visible', 'Off');

c_width = default_char_size(3); 
c_height = default_char_size(4);

appdata = [];
appdata.lastValidTag = 'text_dyna';

h27 = uicontrol(...
    'Parent',h26,...
    'FontUnits',get(0,'defaultuicontrolFontUnits'),...
    'Units','normalized',...
    'HorizontalAlignment',get(0,'defaultuicontrolHorizontalAlignment'),...
    'ListboxTop',get(0,'defaultuicontrolListboxTop'),...
    'Max',get(0,'defaultuicontrolMax'),...
    'Min',get(0,'defaultuicontrolMin'),...
    'SliderStep',get(0,'defaultuicontrolSliderStep'),...
    'String','DYNARE GUI',...
    'Style','text',...
    'Value',get(0,'defaultuicontrolValue'),...
    'Position',[0.5-c_width*5 0.6 c_width*10 c_height],... %'Position',[60 22.0117647058823 c_width*4 c_height],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ForegroundColor',get(0,'defaultuicontrolForegroundColor'),...
    'Enable',get(0,'defaultuicontrolEnable'),...
    'TooltipString',blanks(0),...
    'Visible',get(0,'defaultuicontrolVisible'),...
    'KeyPressFcn',blanks(0),...
    'KeyReleaseFcn',blanks(0),...
    'HandleVisibility',get(0,'defaultuicontrolHandleVisibility'),...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
    'DeleteFcn',blanks(0),...
    'ButtonDownFcn',blanks(0),...
    'Tag','text_dyna',...
    'UserData',[],...
    'FontSize',28,...
    'FontName','Tahoma',...
    'FontAngle',get(0,'defaultuicontrolFontAngle'),...
    'FontWeight','bold');

appdata = [];
appdata.lastValidTag = 'text_version';

h28 = uicontrol(...
    'Parent',h26,...
    'FontUnits',get(0,'defaultuicontrolFontUnits'),...
    'Units','normalized',...
    'HorizontalAlignment','center',...
    'ListboxTop',get(0,'defaultuicontrolListboxTop'),...
    'Max',get(0,'defaultuicontrolMax'),...
    'Min',get(0,'defaultuicontrolMin'),...
    'SliderStep',get(0,'defaultuicontrolSliderStep'),...
    'String','Prototype v.0.6.2',...
    'Style','text',...
    'Value',get(0,'defaultuicontrolValue'),...
    'Position',[0,0.4,1,.1],...
    'BackgroundColor',[1 1 1],...
    'Callback',blanks(0),...
    'Children',[],...
    'ForegroundColor',get(0,'defaultuicontrolForegroundColor'),...
    'Enable',get(0,'defaultuicontrolEnable'),...
    'TooltipString',blanks(0),...
    'Visible',get(0,'defaultuicontrolVisible'),...
    'KeyPressFcn',blanks(0),...
    'KeyReleaseFcn',blanks(0),...
    'HandleVisibility',get(0,'defaultuicontrolHandleVisibility'),...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
    'DeleteFcn',blanks(0),...
    'ButtonDownFcn',blanks(0),...
    'Tag','text_version',...
    'UserData',[],...
    'FontSize',12,...
    'FontName',get(0,'defaultuicontrolFontName'),...
    'FontAngle',get(0,'defaultuicontrolFontAngle'),...
    'FontWeight',get(0,'defaultuicontrolFontWeight'));

set(h28,'Units','normalized');

% appdata = [];
% appdata.lastValidTag = 'text_re';
% 
% h29 = uicontrol(...
%     'Parent',h26,...
%     'FontUnits',get(0,'defaultuicontrolFontUnits'),...
%     'Units','normalized',...
%     'String','RE',...
%     'Style','text',...
%     'Position',[0.5+c_width*4 0.5 c_width*2 c_height],...
%     'BackgroundColor',[1 1 1],...
%     'Children',[],...
%     'ForegroundColor',[0 0 1],...
%     'ParentMode','manual',...
%     'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
%     'DeleteFcn',blanks(0),...
%     'ButtonDownFcn',blanks(0),...
%     'Tag','text_re',...
%     'FontSize',28,...
%     'FontName','Tahoma',...
%     'FontWeight','bold');
% 
% appdata = [];
% appdata.lastValidTag = 'text_gui';
% 
% h30 = uicontrol(...
%     'Parent',h26,...
%     'FontUnits',get(0,'defaultuicontrolFontUnits'),...
%     'Units','normalized',...
%     'String',' GUI',...
%     'Style','text',...
%     'Position',[0.5+c_width*6 0.5 c_width*3 c_height],...
%     'BackgroundColor',[1 1 1],...
%     'Children',[],...
%     'ForegroundColor',get(0,'defaultuicontrolForegroundColor'),...
%     'ParentMode','manual',...
%     'CreateFcn', {@local_CreateFcn, blanks(0), appdata} ,...
%     'DeleteFcn',blanks(0),...
%     'ButtonDownFcn',blanks(0),...
%     'Tag','text_gui',...
%     'FontSize',28,...
%     'FontName','Tahoma',...
%     'FontWeight','bold');

appdata = [];
appdata.lastValidTag = 'output';

h31 = uimenu(...
    'Parent',h1,...
    'Callback',@(hObject,eventdata)dynare_gui('output_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Output',...
    'Tag','output',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'output_shocks_decomposition';

h32 = uimenu(...
    'Parent',h31,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('output_shocks_decomposition_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Shock decomposition',...
    'Tag','output_shocks_decomposition',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'output_conditional_forecast';

h33 = uimenu(...
    'Parent',h31,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('output_conditional_forecast_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Conditional forecast',...
    'Tag','output_conditional_forecast',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'output_forecast';

h331 = uimenu(...
    'Parent',h31,...
    'Enable','off',...
    'Callback',@(hObject,eventdata)dynare_gui('output_forecast_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Forecast',...
    'Tag','output_forecast',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


appdata = [];
appdata.lastValidTag = 'help';

h34 = uimenu(...
    'Parent',h1,...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('help_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Help',...
    'Tag','help',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'help_product_help';

h35 = uimenu(...
    'Parent',h34,...
    'Callback',@(hObject,eventdata)dynare_gui('help_product_help_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Dynare_GUI help',...
    'Tag','help_product_help',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'help_dynare_manual';

h36 = uimenu(...
    'Parent',h34,...
    'Callback',@(hObject,eventdata)dynare_gui('help_dynare_manual_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Dynare reference manual',...
    'Tag','help_dynare_manual',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'help_terms_of_use';

h37 = uimenu(...
    'Parent',h34,...
    'Callback',@(hObject,eventdata)dynare_gui('help_terms_of_use_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','Terms of use',...
    'Tag','help_terms_of_use',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'help_about';

h38 = uimenu(...
    'Parent',h34,...
    'Separator','on',...
    'Callback',@(hObject,eventdata)dynare_gui('help_about_Callback',hObject,eventdata,guidata(hObject)),...
    'Label','About Dynare_GUI',...
    'Tag','help_about',...
    'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

    function resizeui(hObject,callbackdata)
        try
            % Get figure width and height
            figwidth = hObject.Position(3);
            figheight = hObject.Position(4);
            
%             if(figwidth < 180 )
%                 hObject.Position(3) = 180;
%             end
%             
%             if(figheight < 40 )
%                 hObject.Position(4) = 40;
%             end
%             movegui(hObject,'center');

        catch
        end
    end
end

% --- Set application data first then calling the CreateFcn.
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
    names = fieldnames(appdata);
    for i=1:length(names)
        name = char(names(i));
        setappdata(hObject, name, getfield(appdata,name));
    end
end

if ~isempty(createfcn)
    if isa(createfcn,'function_handle')
        createfcn(hObject, eventdata);
    else
        eval(createfcn);
    end
end
end

% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % DYNARE_GUI
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % DYNARE_GUI(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % DYNARE_GUI('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % DYNARE_GUI(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || (isscalar(fig)&&isprop(fig,'GUIDEFigure'));
    end
    
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end
        
        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
        
        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')
        
        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);
    
    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end
        
        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end
    
    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end
        
        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end
    
    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure);
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end
        
        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end
        
        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    % Call version of openfig that accepts 'auto' option"
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton, visible);
    %     %workaround for CreateFcn not called to create ActiveX
    %     if feature('HGUsingMATLABClasses')
    %         peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');
    %         for i=1:length(peers)
    %             if isappdata(peers(i),'Control')
    %                 actxproxy(peers(i));
    %             end
    %         end
    %     end
end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
        && isequal(varargin{1},gcbo);
catch
    result = false;
end
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
        (ischar(varargin{1}) ...
        && isequal(ishghandle(varargin{2}), 1) ...
        && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
        ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end
end

