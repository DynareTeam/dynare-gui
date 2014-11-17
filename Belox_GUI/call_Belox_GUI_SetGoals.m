function varargout = call_Belox_GUI_SetGoals(varargin)
%CALL_BELOX_GUI_SETGOALS M-file for call_Belox_GUI_SetGoals.fig
%      CALL_BELOX_GUI_SETGOALS is the GUI screen for seting up macroeconomic goals in Belox_GUI model interactive simulator.
%
%      CALL_BELOX_GUI_SETGOALS, by itself, creates a new CALL_BELOX_GUI_SETGOALS or raises the existing
%      singleton.
%
%      H = CALL_BELOX_GUI_SETGOALS returns the handle to a new CALL_BELOX_GUI_SETGOALS or the handle to
%      the existing singleton.
%
%      CALL_BELOX_GUI_SETGOALS('Property','Value',...) creates a new CALL_BELOX_GUI_SETGOALS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to call_Belox_GUI_SetGoals_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton.
%
%      CALL_BELOX_GUI_SETGOALS('CALLBACK') and CALL_BELOX_GUI_SETGOALS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CALL_BELOX_GUI_SETGOALS.M with the given input
%      arguments.
%
% Copyright (C) 2013 Belox Advisory Services
%
% This file is part of Belox DSGE model interactive simulator written in Dynare and Matlab.


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @call_Belox_GUI_SetGoals_OpeningFcn, ...
    'gui_OutputFcn',  @call_Belox_GUI_SetGoals_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before call_Belox_GUI_SetGoals is made visible.
function call_Belox_GUI_SetGoals_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for call_Belox_GUI_SetGoals
movegui(hObject,'center');
handles.output = hObject;
handles.setGoals = 0;
set(handles.figureGoals,'name','Belox DSGE Model Simulator - Set Goals');

if(handles.setupNum ~=3)
     set(handles.radiobuttonAlternative, 'Visible','Off');
     set(handles.radiobuttonNew,  'position',[27.6 24 24.8 1.769]);
   
end
 

% Update handles structure
guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = call_Belox_GUI_SetGoals_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pussbuttonSetGoals.
function pussbuttonSetGoals_Callback(hObject, eventdata, handles)
% hObject    handle to pussbuttonSetGoals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model_name = char(getappdata(0,'model_name'));
button = questdlg('Long term goals definition (steady state parameters) might change the model'' steady state, in which case a new mode file should be computed. Here, we use already computed mode file with settings defined under ''Default setup'' option. Do you still want to proceed?',...
    model_name, 'Yes', 'No', 'No') 



if(strcmp(button,'Yes')==0)
    return;
end

h = waitbar(0,'I am solving the model ... Please wait ...', 'Name',char(getappdata(0,'model_name')) );%, 'WindowStyle','modal', 'CloseRequestFcn','');

steps = 1500;
for step = 1:steps
    if step == 200
        
        selection =  get(handles.uipanelGoals, 'SelectedObject');
        
        file_core = fopen(sprintf('%s_SteadyStateParameters_core.dyn',model_name ), 'rt');
        A= fread(file_core);
        fclose(file_core);
        
        file_new = fopen(sprintf('%s_SteadyStateParameters.dyn',model_name ), 'wt');
        %         fwrite(file_new,A);
        
        fprintf(file_new, '\n\n');
        if(selection == handles.radiobuttonDefault)
            column_index = 1;
        elseif(selection == handles.radiobuttonAlternative)
            column_index = 2;
        elseif (selection == handles.radiobuttonNew)
            column_index = 3;
        end
        
        
        for raw_index=1:handles.parNum
            fprintf(file_new, sprintf('%s      =   %s; \n', handles.parNames{raw_index},get(handles.parValues(raw_index,column_index), 'String')));
        end
        fwrite(file_new,A);
        fclose(file_new);
        
    end
    
    if step == 400
        file_core = fopen(sprintf('%s_core.mod',model_name), 'rt');
        A= fread(file_core);
        fclose(file_core);
        
        file_new = fopen(sprintf('%s.mod',model_name), 'wt');
        fwrite(file_new,A);
        fprintf(file_new, '@#include "list_variables.dyn"\n');
        fprintf(file_new, sprintf('@#include "%s_Estimation_MH.dyn"\n',model_name));
        fclose(file_new);
    end
    if step == 600
        try
            eval(sprintf('dynare %s',model_name));
            handles.setGoals = 1;
            msgbox('You have successfully changed long term goals definition! ',model_name); 
        catch
            errordlg(sprintf('%s DSGE model cannot find the steady state for defined long-term macroeconomic goals. Please consider different setup.',...
                model_name),sprintf('%s error', model_name),'modal');
            uicontrol(hObject);
        end
    end
    if step == 1200
        Belox_GUI_oo = evalin('base','oo_');
        save('Belox_GUI.mat','Belox_GUI_oo');
        
        Belox_GUI_model = evalin('base','M_');
        save('Belox_GUI.mat','Belox_GUI_model','-append');
        
    end
    waitbar(step / steps)
end
delete(h);
% if(handles.setGoals)
%     set(handles.pushbuttonClose, 'Enable', 'On');
% end





guidata(hObject, handles);

% --- Executes on button press in pushbuttonClose.
function pushbuttonClose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'GoalsAreSet',handles.setGoals);
close;

% --- Executes when selected object is changed in uipanelGoals.
function uipanelGoals_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanelGoals
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
selection =  get(handles.uipanelGoals, 'SelectedObject');

for ii=1: handles.parNum
    if(selection == handles.radiobuttonDefault)
        set(handles.parValues(ii,1), 'Enable','On');
         if(handles.setupNum ==3)
        set(handles.parValues(ii,2), 'Enable','Off');
         end
        set(handles.parValues(ii,3), 'Enable','Off');
        set(handles.parcentageControl(ii,1), 'Enable','Off');
        set(handles.parcentageControl(ii,2), 'Enable','Off');
        set(handles.parcentageControl(ii,3), 'Enable','Off');
        set(handles.parcentageControl(ii,4), 'Enable','Off');
    elseif(selection == handles.radiobuttonAlternative && handles.setupNum==3)
        set(handles.parValues(ii,1), 'Enable','Off');
        set(handles.parValues(ii,2), 'Enable','On');
        set(handles.parValues(ii,3), 'Enable','Off');
        set(handles.parcentageControl(ii,1), 'Enable','Off');
        set(handles.parcentageControl(ii,2), 'Enable','Off');
        set(handles.parcentageControl(ii,3), 'Enable','Off');
        set(handles.parcentageControl(ii,4), 'Enable','Off');
    elseif (selection == handles.radiobuttonNew)
        set(handles.parValues(ii,1), 'Enable','Off');
        if(handles.setupNum ==3)
        set(handles.parValues(ii,2), 'Enable','Off');
        end
        set(handles.parValues(ii,3), 'Enable','On');
        set(handles.parcentageControl(ii,1), 'Enable','On');
        set(handles.parcentageControl(ii,2), 'Enable','On');
        set(handles.parcentageControl(ii,3), 'Enable','On');
        set(handles.parcentageControl(ii,4), 'Enable','On');
    end
end
refresh();


% --- Executes during object creation, after setting all properties.
function uipanelGoals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelGoals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes during object creation, after setting all properties.
function uipanelGoalsDefinitions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelGoalsDefinitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes during object creation, after setting all properties.
function uipanelWhite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelWhite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


h = waitbar(0,'Initializing... Please wait ...', 'Name',char(getappdata(0,'model_name')));

steps = 1500;
for step = 1:steps
    
    if (step == 800)
        
        [num,txt,raw] = xlsread('Belox_GUI_modelinfo.xls','SetUpParameters','','basic');
        numParameters = size(txt,1)-1;
        txt= txt(2:end,:);
        handles.parNames =  txt(:,2);
        handles.parNum = numParameters;
        handles.setupNum = size(num,2);
        ii=1;
        position = 15;
        h_position=1;
        h_width_1 = 78;
        h_width_2 = 20;
        if( handles.setupNum ==3) 
            h_width_3 = 20;
        else
            h_width_3 = 0;
        end
        h_width_4 = 20;
        
        textPars = uicontrol('Parent', hObject, 'style','text',...
            'clipping','on',...
            'String', sprintf('Parameter:'),...
            'HorizontalAlignment','left',...
            'FontWeight', 'Bold',...
            'FontSize',8,...
            'unit','characters',...
            'position',[h_position position 15 3],...
            'BackgroundColor', 'white');
        textBelox = uicontrol('Parent', hObject, 'style','text',...
            'clipping','on',...
            'String', sprintf('Default:'),...
            'FontWeight', 'Bold',...
            'HorizontalAlignment','left',...
            'unit','characters',...
            'position',[h_position + h_width_1 position 20 3],...
            'BackgroundColor', 'white');
        
        if( handles.setupNum ==3) 
        textQuest = uicontrol('Parent', hObject, 'style','text',...
            'clipping','on',...
            'String', sprintf('Alternative:'),...
            'HorizontalAlignment','left',...
            'FontWeight', 'Bold',...
            'unit','characters',...
            'position',[h_position + h_width_1+h_width_2 position 20 3],...
            'BackgroundColor', 'white');
        end
        textNew = uicontrol('Parent', hObject, 'style','text',...
            'clipping','on',...
            'String', sprintf('New setup:'),...
            'FontWeight', 'Bold',...
            'HorizontalAlignment','left',...
            'unit','characters',...
            'position',[h_position + h_width_1+ h_width_2+h_width_3 position 20 3],...
            'BackgroundColor', 'white');
        
        textChange = uicontrol('Parent', hObject, 'style','text',...
            'clipping','on',...
            'String', 'Change (%):',...
            'FontWeight', 'Bold',...
            'HorizontalAlignment','left',...
            'unit','characters',...
            'position',[h_position+h_width_1+ h_width_2+h_width_3+h_width_4  position 15 3],...
            'BackgroundColor', 'white');
        position = position + 2;
        
        while ii <= numParameters
            
            paramName(ii) = uicontrol('Parent', hObject, 'style','text',...
                'clipping','on',...
                'String', sprintf('%s', txt{ii,1}) ,...
                'HorizontalAlignment','left',...
                'unit','characters',...
                'position',[h_position position-(3*ii) 80 1.5],...
                'BackgroundColor', 'white');
            
            serbianValue(ii) = uicontrol('Parent', hObject, 'style','text',...
                'clipping','on',...
                'String', sprintf('%g', num(ii,1)) ,...
                'ForegroundColor', 'Black',...
                'HorizontalAlignment','left',...
                'Enable', 'On',...
                'unit','characters',...
                'position',[h_position+h_width_1 position-(3*ii) 15 1.5],...
                'BackgroundColor', 'white');
            
             if( handles.setupNum ==3) 
            questValue(ii) = uicontrol('Parent', hObject, 'style','text',...
                'clipping','on',...
                'String', sprintf('%g', num(ii,2)) ,...
                'HorizontalAlignment','left',...
                'Enable', 'Off',...
                'BorderType', 'etchedin',...
                'BorderWidth', '1',...
                'unit','characters',...
                'position',[h_position+h_width_1+h_width_2 position-(3*ii) 15 1.5],...
                'BackgroundColor', 'white');
             end
            newValue(ii) = uicontrol('Parent', hObject, 'style','edit',...
                'clipping','on',...
                'String', sprintf('%g', num(ii,handles.setupNum)) ,...
                'Enable', 'Off',...
                'HorizontalAlignment','left',...
                'unit','characters',...
                'position',[h_position++h_width_1+h_width_2+h_width_3 position-(3*ii) 15 1.5],...
                'BackgroundColor', 'white');
            
            
            textValue(ii) = uicontrol('Parent', hObject, 'style','text',...
                'clipping','on',...
                'String', '0',...
                'HorizontalAlignment','left',...
                'Enable', 'Off',...
                'unit','characters',...
                'position',[h_position+h_width_1+h_width_2+h_width_3 + h_width_4+7 position-(3*ii) 6 1.5],...
                'BackgroundColor', 'white');
            
            textPercent(ii) = uicontrol('Parent', hObject, 'style','text',...
                'clipping','on',...
                'String', '%',...
                'HorizontalAlignment','left',...
                'Enable', 'Off',...
                'unit','characters',...
                'position',[h_position+h_width_1+h_width_2+h_width_3 + h_width_4+13 position-(3*ii) 2 1.5],...
                'BackgroundColor', 'white');
            
            
            incVal(ii) = uicontrol('Parent', hObject, 'style','pushbutton',...
                'clipping','on',...
                'String', '+',...
                'Enable', 'Off',...
                'unit','characters',...
                'position',[h_position+h_width_1+h_width_2+h_width_3 + h_width_4 position-(3*ii) 3 1.5],...
                'Callback', {@incVal_Callback,serbianValue(ii),newValue(ii),textValue(ii)});
            
            decVal(ii) = uicontrol('Parent', hObject, 'style','pushbutton',...
                'clipping','on',...
                'String', '-',...
                'unit','characters',...
                'Enable', 'Off',...
                'position',[h_position+h_width_1+h_width_2+h_width_3+h_width_4+3 position-(3*ii) 3 1.5],...
                'Callback', {@decVal_Callback,serbianValue(ii),newValue(ii),textValue(ii)});
            
            set(newValue(ii), 'Callback', {@computePercentageVal_Callback,serbianValue(ii),textValue(ii)});
            
            %set(pars(ii), 'Callback', {@selectParameter_Callback,ii});
            
            handles.parValues(ii,1) = serbianValue(ii);
             if( handles.setupNum ==3) 
            handles.parValues(ii,2) = questValue(ii);
             end
            handles.parValues(ii,3) = newValue(ii);
            handles.parcentageControl(ii,1) = incVal(ii);
            handles.parcentageControl(ii,2) = decVal(ii);
            handles.parcentageControl(ii,3) = textValue(ii);
            handles.parcentageControl(ii,4) = textPercent(ii);
            
            position = position + 1;
            ii = ii+1;
        end
        
    end
    if (step == 1300)
        
        guidata(hObject,handles);  % Add the new handles structure to the figure
        
        
        refresh();
    end
    waitbar(step / steps)
end
delete(h);

function computePercentageVal_Callback(hObject,eventdata, source, change)
data = guidata(gcbo);
data.policyChange = 1;
guidata(gcbo,data);

source_value=str2double(get(source, 'String'));
alternative_value = str2double(get(hObject, 'String'));
old_value = str2double(get(change, 'String'))*source_value;

change_value= round(alternative_value/source_value *100 -100);
if(change_value > 99999)
    errordlg(sprintf('New value %g is too big.Please consider different value.',alternative_value) ,...
        sprintf('%s error', char(getappdata(0,'model_name'))),'modal');
    uicontrol(hObject);
    %set(hObject, 'String', sprintf('%g',old_value));
end
set(change, 'String', sprintf('%d',round(change_value)));


function incVal_Callback(hObject,eventdata, source, destination, change)
source_value=str2double(get(source, 'String'));
change_value=str2double(get(change, 'String'));
change_value=change_value+1;

new_Value= source_value * (1 + change_value/100);
%new_Value= source_value +  source_value*change_value/100;

set(destination, 'String', sprintf('%f',new_Value));
set(change, 'String', sprintf('%d',change_value));


function decVal_Callback(hObject,eventdata, source, destination, change)
source_value=str2double(get(source, 'String'));
change_value=str2double(get(change, 'String'));
change_value=change_value-1;

new_Value= source_value * (1 + change_value/100);
%new_Value= source_value +  source_value*change_value/100;

set(destination, 'String', sprintf('%f',new_Value));
set(change, 'String', sprintf('%d',change_value));


% --- Executes on button press in pushbuttonReset.
function pushbuttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for ii=1: handles.parNum
    set(handles.parValues(ii,3), 'String', get(handles.parValues(ii,1), 'String'));
    set(handles.parcentageControl(ii,3), 'String','0');
    
end
refresh();
