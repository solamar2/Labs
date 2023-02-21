function varargout = MechanicalProPerties_Gui(varargin)
% MECHANICALPROPERTIES_GUI MATLAB code for MechanicalProPerties_Gui.fig
%      MECHANICALPROPERTIES_GUI, by itself, creates a new MECHANICALPROPERTIES_GUI or raises the existing
%      singleton*.
%
%      H = MECHANICALPROPERTIES_GUI returns the handle to a new MECHANICALPROPERTIES_GUI or the handle to
%      the existing singleton*.
%
%      MECHANICALPROPERTIES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MECHANICALPROPERTIES_GUI.M with the given input arguments.
%
%      MECHANICALPROPERTIES_GUI('Property','Value',...) creates a new MECHANICALPROPERTIES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MechanicalProPerties_Gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MechanicalProPerties_Gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MechanicalProPerties_Gui

% Last Modified by GUIDE v2.5 04-Apr-2022 10:47:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MechanicalProPerties_Gui_OpeningFcn, ...
                   'gui_OutputFcn',  @MechanicalProPerties_Gui_OutputFcn, ...
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


% --- Executes just before MechanicalProPerties_Gui is made visible.
function MechanicalProPerties_Gui_OpeningFcn(hObject, ~, handles, varargin)
%% Loading the Data
handles.Skin.data = readtable('skin.txt');
handles.Tendon.data = readtable('tendon.txt');
handles.Rubber.Creep = readtable('Rubber.xlsx','sheet','Creep');
handles.Rubber.SSG = readtable('Rubber.xlsx','sheet','SSG');
handles.Rubber.Mul75 = readtable('Rubber.xlsx','sheet','Mul_75');
handles.Rubber.Mul125 = readtable('Rubber.xlsx','sheet','Mul_125');
handles.Rubber.Hys = readtable('Rubber.xlsx','sheet','Hys');
handles.Rubber.SR = readtable('Rubber.xlsx','sheet','SR');

Rubber_Surface = 9.66*2.04;
Skin_Surface = 0.7*14.5;
Tendon_Surface =0.2*1.8;


newnames = [{'Times'},{'Stress'},{'Mul_strain'},{'SSG_strain'}]; %%ranaming the titles 
handles.Skin.data.Properties.VariableNames = newnames;
handles.Tendon.data.Properties.VariableNames = newnames;

%% Calculation for translate Load -> Stress and Extention->Strain for each material


handles.Skin.data.Stress = handles.Skin.data.Stress/Skin_Surface *10^6 ; % cal the Stress Strain
handles.Skin.data.Mul_strain = handles.Skin.data.Mul_strain/64;
handles.Skin.data.SSG_strain = handles.Skin.data.SSG_strain/64;

handles.Tendon.data.Stress = handles.Tendon.data.Stress/Tendon_Surface *10^6; % cal the Stress Strain
handles.Tendon.data.Mul_strain = handles.Tendon.data.Mul_strain/40.2;
handles.Tendon.data.SSG_strain = handles.Tendon.data.SSG_strain/40.2;

handles.Rubber.Creep.Stress = handles.Rubber.Creep.Stress/Rubber_Surface*10^6;
handles.Rubber.Creep.Strain = handles.Rubber.Creep.Strain / 80;

handles.Rubber.SSG.Stress = handles.Rubber.SSG.Stress/Rubber_Surface*10^6;
handles.Rubber.SSG.Strain = handles.Rubber.SSG.Strain / 80;

handles.Rubber.Hys.Stress = (handles.Rubber.Hys.Stress/Rubber_Surface)*10^6;
handles.Rubber.Hys.Strain = handles.Rubber.Hys.Strain / 80;

handles.Rubber.Mul75.Stress = handles.Rubber.Mul75.Stress/Rubber_Surface*10^6;
handles.Rubber.Mul75.Strain = handles.Rubber.Mul75.Strain / 80;

handles.Rubber.Mul125.Stress = handles.Rubber.Mul125.Stress/Rubber_Surface*10^6;
handles.Rubber.Mul125.Strain = handles.Rubber.Mul125.Strain / 80;

handles.Rubber.SR.Stress = handles.Rubber.SR.Stress/Rubber_Surface*10^6;
handles.Rubber.SR.Strain = handles.Rubber.SR.Strain / 80;

handles.Y2 = 0;
handles.X2 = 0;

handles.Y = 0;
handles.X = 0;
handles.Data = '';
handles.Xlabel = '';
handles.Ylabel = '';
handles.Mul_flag = 0; %Flag for two graph of mul for rabber
% Choose default command line output for MechanicalProPerties_Gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MechanicalProPerties_Gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MechanicalProPerties_Gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SSG.
function SSG_Callback(hObject, eventdata, handles)
%% Make only one Button to be able each time
handles.Mul_flag = 0;
Value = get(handles.SSG,'value');

if Value
    set(handles.SSG_skin,'enable','on');
    set(handles.SSG_Rub,'enable','on');
    set(handles.SSG_ten,'enable','on');
    
    set(handles.Mul,'value',0);
    set(handles.Mul_skin,'enable','off','value',0);
    set(handles.Mul_Rub,'enable','off','value',0);
    set(handles.Mul_ten,'enable','off','value',0);
    
    set(handles.Creep,'value',0);
    set(handles.Creep_SLS,'enable','off','value',0);
    
    set(handles.SR,'value',0);
    set(handles.SR_SLS,'enable','off','value',0);
    
    set(handles.Hys,'value',0);
    set(handles.Hys_skin,'enable','off','value',0);
    set(handles.Hys_Rub,'enable','off','value',0);
    set(handles.Hys_ten,'enable','off','value',0);
else 
    set(handles.SSG_skin,'enable','off','value',0);
    set(handles.SSG_Rub,'enable','off','value',0);
    set(handles.SSG_ten,'enable','off','value',0);
    
end
guidata(hObject, handles);


% --- Executes on button press in SSG_skin.
function SSG_skin_Callback(hObject, eventdata, handles)
% hObject    handle to SSG_skin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SSG_skin
set(handles.SSG_ten,'value',0);
set(handles.SSG_Rub,'value',0);


handles.Y = handles.Skin.data.Stress(4:15);
handles.X = handles.Skin.data.SSG_strain(4:15);

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';
handles.Data = [num2str(handles.Skin.data.Stress(15)) '[Pa] is the Max Stress'];
guidata(hObject, handles);

% --- Executes on button press in SSG_Rub.
function SSG_Rub_Callback(hObject, eventdata, handles)
% hObject    handle to SSG_Rub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SSG_Rub
set(handles.SSG_skin,'value',0);
set(handles.SSG_ten,'value',0)

handles.Y = handles.Rubber.SSG.Stress(70:end);
handles.X = handles.Rubber.SSG.Strain(70:end);

handles.Data = [num2str(handles.Rubber.SSG.Stress(end)) '[Pa] is the Max Stress'];

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';


guidata(hObject, handles);
% --- Executes on button press in SSG_ten.
function SSG_ten_Callback(hObject, eventdata, handles)
% hObject    handle to SSG_ten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SSG_ten
set(handles.SSG_skin,'value',0);
set(handles.SSG_Rub,'value',0)

handles.Y = handles.Tendon.data.Stress(4:16);
handles.X = handles.Tendon.data.SSG_strain(4:16);

handles.Data = [num2str(handles.Tendon.data.Stress(16)) '[Pa] is the Max Stress'];

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';

guidata(hObject, handles);
% --- Executes on button press in Hys.
function Hys_Callback(hObject, eventdata, handles)
Value = get(handles.Hys,'value');
handles.Mul_flag = 0;

if Value
    set(handles.Hys_skin,'enable','on');
    set(handles.Hys_Rub,'enable','on');
    set(handles.Hys_ten,'enable','on');
    
    set(handles.Mul,'value',0);
    set(handles.Mul_skin,'enable','off','value',0);
    set(handles.Mul_Rub,'enable','off','value',0);
    set(handles.Mul_ten,'enable','off','value',0);
    
    set(handles.Creep,'value',0);
    set(handles.Creep_SLS,'enable','off','value',0);
    
    set(handles.SR,'value',0);
    set(handles.SR_SLS,'enable','off','value',0);
    
    set(handles.SSG,'value',0);
    set(handles.SSG_skin,'enable','off','value',0);
    set(handles.SSG_Rub,'enable','off','value',0);
    set(handles.SSG_ten,'enable','off','value',0);
else 
    set(handles.Hys_skin,'enable','off','value',0);
    set(handles.Hys_Rub,'enable','off','value',0);
    set(handles.Hys_ten,'enable','off','value',0);
end
guidata(hObject, handles);

function Hys_skin_Callback(hObject, eventdata, handles)
% hObject    handle to Hys_skin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Hys_skin
set(handles.Hys_ten,'value',0);
set(handles.Hys_Rub,'value',0);

handles.Y = handles.Skin.data.Stress(4:22);
handles.X = handles.Skin.data.SSG_strain(4:22);

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';
handles.Data = ['The amoung of energy is:' ...
    num2str(polyarea(handles.X,handles.Y)/1000) ' [KJ/m^3]'];
guidata(hObject, handles);

% --- Executes on button press in Hys_Rub.
function Hys_Rub_Callback(hObject, eventdata, handles)
% hObject    handle to Hys_Rub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Hys_Rub
set(handles.Hys_skin,'value',0);
set(handles.Hys_ten,'value',0);

handles.Y = handles.Rubber.Hys.Stress;
handles.X = handles.Rubber.Hys.Strain;

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';
handles.Data = ['The amoung of energy is:' ...
    num2str(polyarea(handles.X,handles.Y)/1000) ' [KJ/m^3]'];
guidata(hObject, handles);

% --- Executes on button press in Hys_ten.
function Hys_ten_Callback(hObject, eventdata, handles)
% hObject    handle to Hys_ten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Hys_ten
set(handles.Hys_skin,'value',0);
set(handles.Hys_Rub,'value',0);

handles.Y = handles.Tendon.data.Stress(4:25);
handles.X = handles.Tendon.data.SSG_strain(4:25);

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';
handles.Data = ['The amoung of energy is:' ...
    num2str(polyarea(handles.X,handles.Y)/1000) ' [KJ/m^3]'];
guidata(hObject, handles);

% --- Executes on button press in Mul.
function Mul_Callback(hObject, eventdata, handles)
Value = get(handles.Mul,'value');
handles.Mul_flag = 0;

if Value
    set(handles.Mul_skin,'enable','on');
    set(handles.Mul_Rub,'enable','on');
    set(handles.Mul_ten,'enable','on');
    
    set(handles.SSG,'value',0);
    set(handles.SSG_skin,'enable','off','value',0);
    set(handles.SSG_Rub,'enable','off','value',0);
    set(handles.SSG_ten,'enable','off','value',0);
    
    set(handles.Creep,'value',0);
    set(handles.Creep_SLS,'enable','off','value',0);
    
    set(handles.SR,'value',0);
    set(handles.SR_SLS,'enable','off','value',0);
    
    set(handles.Hys,'value',0);
    set(handles.Hys_skin,'enable','off','value',0);
    set(handles.Hys_Rub,'enable','off','value',0);
    set(handles.Hys_ten,'enable','off','value',0);
else 
    set(handles.Mul_skin,'enable','off','value',0);
    set(handles.Mul_Rub,'enable','off','value',0);
    set(handles.Mul_ten,'enable','off','value',0);
end
guidata(hObject, handles);

% --- Executes on button press in Mul_skin.
function Mul_skin_Callback(hObject, eventdata, handles)
% hObject    handle to Mul_skin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Mul_skin
set(handles.Mul_Rub,'value',0);
set(handles.Mul_ten,'value',0);

handles.Mul_flag = 0;

handles.Y = handles.Skin.data.Stress(4:end);
handles.X = handles.Skin.data.SSG_strain(4:end);

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';
handles.Data = [];
guidata(hObject, handles);

% --- Executes on button press in Mul_Rub.
function Mul_Rub_Callback(hObject, eventdata, handles)
% hObject    handle to Mul_Rub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Mul_Rub
set(handles.Mul_skin,'value',0);
set(handles.Mul_ten,'value',0);

handles.Y = handles.Rubber.Mul75.Stress;
handles.X = handles.Rubber.Mul75.Strain;

handles.Y2 = handles.Rubber.Mul125.Stress;
handles.X2 = handles.Rubber.Mul125.Strain;

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';

handles.Mul_flag = 1;
handles.Data = [];
guidata(hObject, handles);

% --- Executes on button press in Mul_ten.
function Mul_ten_Callback(hObject, eventdata, handles)
% hObject    handle to Mul_ten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Mul_ten
set(handles.Mul_Rub,'value',0);
set(handles.Mul_skin,'value',0);

handles.Mul_flag = 0;

handles.Y = handles.Tendon.data.Stress(4:end);
handles.X = handles.Tendon.data.SSG_strain(4:end);

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Strain';
handles.Data = [];
guidata(hObject, handles);

% --- Executes on button press in SR.
function SR_Callback(hObject, eventdata, handles)
% hObject    handle to SR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.SR,'value');
handles.Mul_flag = 0;

if Value
    set(handles.SR_SLS,'enable','on');
    
    set(handles.Mul,'value',0);
    set(handles.Mul_skin,'enable','off','value',0);
    set(handles.Mul_Rub,'enable','off','value',0);
    set(handles.Mul_ten,'enable','off','value',0);
    
    set(handles.Creep,'value',0);
    set(handles.Creep_SLS,'enable','off','value',0);
    
    set(handles.SSG,'value',0);
    set(handles.SSG_skin,'enable','off','value',0);
    set(handles.SSG_Rub,'enable','off','value',0);
    set(handles.SSG_ten,'enable','off','value',0);
    
    set(handles.Hys,'value',0);
    set(handles.Hys_skin,'enable','off','value',0);
    set(handles.Hys_Rub,'enable','off','value',0);
    set(handles.Hys_ten,'enable','off','value',0);
    
else 
    set(handles.SR_SLS,'enable','off','value',0);
    
end

% Hint: get(hObject,'Value') returns toggle state of SR
handles.Y = handles.Rubber.SR.Stress(16:99);
handles.X = handles.Rubber.SR.Time(16:99);

handles.Ylabel = 'Stress [Pa]';
handles.Xlabel = 'Time [s]';


guidata(hObject, handles);

% --- Executes on button press in Creep.
    function Creep_Callback(hObject, eventdata, handles)
% hObject    handle to Creep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Mul_flag = 0;

Value = get(handles.Creep,'value');

if Value
    set(handles.Creep_SLS,'enable','on');
    
    set(handles.Mul,'value',0);
    set(handles.Mul_skin,'enable','off','value',0);
    set(handles.Mul_Rub,'enable','off','value',0);
    set(handles.Mul_ten,'enable','off','value',0);
    
    set(handles.SR,'value',0);
    set(handles.SR_SLS,'enable','off','value',0);
    
    set(handles.SSG,'value',0);
    set(handles.SSG_skin,'enable','off','value',0);
    set(handles.SSG_Rub,'enable','off','value',0);
    set(handles.SSG_ten,'enable','off','value',0);
    
    set(handles.Hys,'value',0);
    set(handles.Hys_skin,'enable','off','value',0);
    set(handles.Hys_Rub,'enable','off','value',0);
    set(handles.Hys_ten,'enable','off','value',0);
    
else 
    set(handles.Creep_SLS,'enable','off','value',0);
    
end

% Hint: get(hObject,'Value') returns toggle state of Creep
handles.Y = handles.Rubber.Creep.Strain;
handles.X = handles.Rubber.Creep.Time;

handles.Ylabel = 'Strain';
handles.Xlabel = 'Time [s]';

guidata(hObject, handles);
% --- Executes on button press in SR_SLS.
function SR_SLS_Callback(hObject, eventdata, handles)
% hObject    handle to SR_SLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SR_SLS
handles.fit = fit(handles.X,handles.Y,'exp2');
handles.Data = evalc('handles.fit');
handles.Data = handles.Data(10:end);

guidata(hObject, handles);
% --- Executes on button press in Creep_SLS.
function Creep_SLS_Callback(hObject, eventdata, handles)
% hObject    handle to Creep_SLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Creep_SLS
handles.Y = handles.Rubber.Creep.Strain(12:end);
handles.X = handles.Rubber.Creep.Time(12:end);


handles.fit = fit(handles.X,handles.Y,'exp2');
handles.Data = evalc('handles.fit');
handles.Data = handles.Data(10:end);
guidata(hObject, handles);


% --- Executes on button press in Exp_Fig.
function Exp_Fig_Callback(hObject, eventdata, handles)
% hObject    handle to Exp_Fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = get(handles.Creep_SLS,'value') + get(handles.SR_SLS,'value');

figure;

if Value
    plot(handles.fit,handles.X,handles.Y)
else 
    plot(handles.X,handles.Y)
    if handles.Mul_flag == 1
        hold on
        plot(handles.X2,handles.Y2)
        legend('6 period of 75%','3 period of 125%');
        hold off
    end
end
xlabel(handles.Xlabel)
ylabel(handles.Ylabel)

% --- Executes on button press in Btn_plot.
function Btn_plot_Callback(hObject, eventdata, handles)
Value = get(handles.Creep_SLS,'value') + get(handles.SR_SLS,'value');

set(handles.axes,'visible','On');

if Value
    plot(handles.fit,handles.X,handles.Y)
else 
    plot(handles.X,handles.Y)
    if handles.Mul_flag == 1
        hold on
        plot(handles.X2,handles.Y2)
        legend('6 period of 75%','3 period of 125%');
        hold off
    end
end
xlabel(handles.Xlabel)
ylabel(handles.Ylabel)
set(handles.DataTxt,'string',handles.Data,'visible','on');


% --- Executes on button press in Start_Btn.
function Start_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Start_Btn,'Visible','off');
set(handles.Start_panel,'Visible','off');
