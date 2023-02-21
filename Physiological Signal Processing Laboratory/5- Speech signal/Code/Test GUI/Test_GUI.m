function varargout = Test_GUI(varargin)
% TEST_GUI MATLAB code for Test_GUI.fig
%      TEST_GUI, by itself, creates a new TEST_GUI or raises the existing
%      singleton*.
%
%      H = TEST_GUI returns the handle to a new TEST_GUI or the handle to
%      the existing singleton*.
%
%      TEST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_GUI.M with the given input arguments.
%
%      TEST_GUI('Property','Value',...) creates a new TEST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Test_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Test_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Test_GUI

% Last Modified by GUIDE v2.5 28-Sep-2016 12:52:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Test_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Test_GUI_OutputFcn, ...
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


% --- Executes just before Test_GUI is made visible.
function Test_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Test_GUI (see VARARGIN)

% Choose default command line output for Test_GUI
handles.output = hObject;

% checks if exist a model named 'Model.mat'
cur_path=pwd;
handles.Train_PATH=fullfile(cur_path(1:end-9),'Train GUI and model');
addpath(handles.Train_PATH);
handles.Model_PATH=fullfile(handles.Train_PATH,'Model.mat');
if exist(handles.Model_PATH)
    M=load(handles.Model_PATH);
    M=M.Model;
    handles.modelFLAG=1;
    set(handles.SelectedModel_text,'String',['Selected model: Model.mat' char(10) 'Model consists of: '  num2str(M.countA) ' samples for speaker A and ' num2str(M.countB) ' samples for speaker B']);
else 
    handles.modelFLAG=0;
    msgbox(['There is no model named ''Model.mat.''.' char(10) 'Please select a model using the ''Select model'' button']);
end

% status flags
setappdata(0,'IsRunning',0);
setappdata(0,'IsRecorded',0);

%constants
handles.Fs=str2double(get(handles.Sampl_edit,'String'))*1000;
handles.PREPalpha=str2double(get(handles.Alpha_edit,'String')); 
handles.PREPwinLength=str2double(get(handles.PreproWinLength_edit,'String'))/1000; 
handles.PREPoverlap=str2double(get(handles.Overlap_edit,'String'));
handles.SEGwinLength=str2double(get(handles.WinLength_edit,'String'))/1000; 
handles.SEGeta=str2double(get(handles.Thresh_edit,'String'));
handles.SEGdt=str2double(get(handles.TimeAbvThrsh_edit,'String'))/1000;
handles.STFTwinLength=round(str2double(get(handles.STFTwinLength_edit,'String'))/1000*handles.Fs); 
handles.STFToverlap=round(str2double(get(handles.STFToverlap_edit,'String'))/100*handles.STFTwinLength); 
handles.STFTnfft=handles.STFTwinLength;
handles.STFTcmin=str2double(get(handles.STFTcmin_edit,'String'));
handles.STFTcmax=str2double(get(handles.STFTcmax_edit,'String'));

% prepare for recording
handles.nBits=16;
handles.nChannels=1;
handles.TimeToPres=3;
handles.SampToPresent=handles.TimeToPres*handles.Fs;
handles.a_obj_handle=audiorecorder(handles.Fs,handles.nBits,handles.nChannels);
%present hypothetic zero signal
handles.TIMESIG=zeros(handles.SampToPresent,1);
handles.ZerSig=handles.TIMESIG;
handles.WaveFormSig=handles.TIMESIG(end-handles.STFTwinLength+1:end);
handles.WFPLOT=plot(handles.Amp_axes,[1:length(handles.WaveFormSig)],handles.WaveFormSig,'color',[0;139;69]/256,'linewidth',2);
handles.XDataSig=[1:length(handles.WaveFormSig)];
set(handles.WFPLOT,'YDataSource','handles.WaveFormSig');
set(handles.WFPLOT,'XDataSource','handles.XDataSig');
set(handles.Amp_axes,'ylim',[-1 1]);
set(handles.Amp_axes,'XTickLabel',[],'YTickLabel',[]);
set(handles.Amp_axes,'Color',[0 0 0 ]);

[~,F,T,handles.P]=spectrogram(handles.TIMESIG,handles.STFTwinLength,handles.STFToverlap,handles.STFTnfft,handles.Fs,'yaxis');
handles.SPEC=10*log10(handles.P);
handles.zerSPEC=handles.SPEC;
handles.SPECPLOT=surf(handles.Spec_axes,T,F,handles.SPEC,'edgecolor','none');
set(handles.SPECPLOT,'ZDataSource','handles.SPEC');
colormap(handles.Spec_axes,jet);
view(handles.Spec_axes,[0,90]);
set(handles.Spec_axes,'fontsize',10);
set(handles.Spec_axes,'xtick',[],'xticklabel',{' '},'yticklabel',{' '},'ytick',[]);
XLABELHANDLE=get(handles.Spec_axes,'xlabel');
YLABELHANDLE=get(handles.Spec_axes,'ylabel');
set(XLABELHANDLE,'string','Time');
set(YLABELHANDLE,'string','Frequency');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Test_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Test_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Close_butt.
function Close_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Close_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all;


% --- Executes on button press in Rec_butt.
function Rec_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Rec_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(0,'IsRunning')==true %recording now and button was pressed to stop
    setappdata(0,'IsRunning',false);
    %disable recording button
    set(handles.Rec_butt,'visible','off');
    set(handles.Rec_butt,'String','Record');
    set(handles.Clear_butt,'visible','on');

else % start recording  
    
    handles.WaveFormSig=handles.ZerSig;
    refreshdata(handles.WFPLOT,'caller');
    drawnow;
    %start recording
    record(handles.a_obj_handle);
    set(handles.Rec_butt,'String','Stop');
    setappdata(0,'IsRunning',true);
    setappdata(0,'IsRecorded',true);
    set(handles.Clear_butt,'visible','off');

    pause(0.1);
    while getappdata(0,'IsRunning')
        %AMP
        handles.Signal=getaudiodata(handles.a_obj_handle);
        handles.TotSig=[handles.ZerSig;handles.Signal];
        handles.Sig2Pres=handles.TotSig(end-handles.SampToPresent+1:end);
        handles.WaveFormSig=handles.Sig2Pres(end-handles.STFTwinLength+1:end);
        handles.XDataSig=[1:length(handles.WaveFormSig)];
        refreshdata(handles.WFPLOT,'caller');
        set(handles.Amp_axes,'ylim',1.2*max(abs(handles.Sig2Pres))*[-1 1]);
        drawnow;
        %STFT
        [~,~,T,handles.P]=spectrogram(handles.Sig2Pres,handles.STFTwinLength,handles.STFToverlap,handles.STFTnfft,handles.Fs,'yaxis');
        handles.SPEC=10*log10(handles.P);
        refreshdata(handles.SPECPLOT,'caller');
        set(handles.Spec_axes,'ylim',[0 handles.Fs/2]);
        set(handles.Spec_axes,'xlim',[T(1),T(end)]);
        set(handles.Spec_axes,'box','on');
        drawnow;
    end;

    % stop recording
    stop(handles.a_obj_handle);
    handles.Signal=getaudiodata(handles.a_obj_handle);
    
    % present product
    handles.WFPLOT=plot(handles.Amp_axes,[1:length(handles.Signal)],handles.Signal,'color',[0;139;69]/256,'linewidth',2);
    set(handles.Amp_axes,'ylim',1.2*max(abs(handles.Signal))*[-1 1]);
    set(handles.Amp_axes,'xlim',[1 length(handles.Signal)]);
    set(handles.Amp_axes,'XTickLabel',[],'YTickLabel',[]);
    set(handles.Amp_axes,'Color',[0 0 0 ]);
    
    [~,F,T,handles.P]=spectrogram(handles.Signal,handles.STFTwinLength,handles.STFToverlap,handles.STFTnfft,handles.Fs,'yaxis');
    handles.SPEC=10*log10(handles.P);
    handles.SPECPLOT=surf(handles.Spec_axes,T,F,handles.SPEC,'edgecolor','none');
    caxis(handles.Spec_axes,[handles.STFTcmin handles.STFTcmax]);
    colormap(handles.Spec_axes,jet);
    view(handles.Spec_axes,[0,90]);
    set(handles.Spec_axes,'fontsize',10);
    set(handles.Spec_axes,'xlim',[T(1),T(end)]);
    set(handles.Spec_axes,'ylim',[0,handles.Fs/2]);

    XLABELHANDLE=get(handles.Spec_axes,'xlabel');
    YLABELHANDLE=get(handles.Spec_axes,'ylabel');
    set(XLABELHANDLE,'string','Time [Sec]');
    set(YLABELHANDLE,'string','Frequency [Hz]');
    box(handles.Spec_axes,'on');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Clear_butt.
function Clear_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% enable recording button
set(handles.Rec_butt,'visible','on');
set(handles.Rec_butt,'String','Record');
% status flags
setappdata(0,'IsRunning',0);
setappdata(0,'IsRecorded',0);
% clearing axes and output
hold(handles.Amp_axes,'off');
cla(handles.Amp_axes);
cla(handles.NRG_axes);
cla(handles.Spec_axes);
set(handles.NRG_axes,'visible','off');
set(handles.ModelDecision_text,'String','');
legend(handles.NRG_axes,'off');
handles.SuperVector=[];
%clear formant analysis
set(handles.EstFormants_butt,'Visible','off');
set(handles.Phoneme_choose,'Visible','off');


% prepare for recording
handles.SampToPresent=handles.TimeToPres*handles.Fs;
handles.a_obj_handle=audiorecorder(handles.Fs,handles.nBits,handles.nChannels);
%present hypothetic zero signal
handles.TIMESIG=zeros(handles.SampToPresent,1);
handles.ZerSig=handles.TIMESIG;
handles.WaveFormSig=handles.TIMESIG(end-handles.STFTwinLength+1:end);
handles.WFPLOT=plot(handles.Amp_axes,[1:length(handles.WaveFormSig)],handles.WaveFormSig,'color',[0;139;69]/256,'linewidth',2);
handles.XDataSig=[1:length(handles.WaveFormSig)];
set(handles.WFPLOT,'YDataSource','handles.WaveFormSig');
set(handles.WFPLOT,'XDataSource','handles.XDataSig');
set(handles.Amp_axes,'ylim',[-1 1]);
set(handles.Amp_axes,'XTickLabel',[],'YTickLabel',[]);
set(handles.Amp_axes,'Color',[0 0 0 ]);

[~,F,T,handles.P]=spectrogram(handles.TIMESIG,handles.STFTwinLength,handles.STFToverlap,handles.STFTnfft,handles.Fs,'yaxis');
handles.SPEC=10*log10(handles.P);
handles.zerSPEC=handles.SPEC;
handles.SPECPLOT=surf(handles.Spec_axes,T,F,handles.SPEC,'edgecolor','none');
set(handles.SPECPLOT,'ZDataSource','handles.SPEC');
set(handles.Spec_axes,'fontsize',10);
view(handles.Spec_axes,[0,90]);
set(handles.Spec_axes,'xtick',[],'xticklabel',{' '},'yticklabel',{' '},'ytick',[]);
set(handles.Amp_axes,'xtick',[],'xticklabel',{' '},'yticklabel',{' '},'ytick',[]);
XLABELHANDLE=get(handles.Spec_axes,'xlabel');
YLABELHANDLE=get(handles.Spec_axes,'ylabel');
set(XLABELHANDLE,'string','Time');
set(YLABELHANDLE,'string','Frequency');
box(handles.Spec_axes,'on');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in SelectModel_butt.
function SelectModel_butt_Callback(hObject, eventdata, handles)
% hObject    handle to SelectModel_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FileName = uigetfile('../*.mat','Choose a model',handles.Train_PATH);
if ~isequal(FileName,0)
    handles.Model_PATH=fullfile(handles.Train_PATH,'Model.mat');
    M=load(handles.Model_PATH);
    M=M.Model;
    handles.modelFLAG=1;
    set(handles.SelectedModel_text,'String',['Selected model: Model.mat' char(10) 'Model consists of: '  num2str(M.countA) ' samples for speaker A and ' num2str(M.countB) ' samples for speaker B']);
end
    
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Analyze_butt.
function Analyze_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Analyze_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(0,'IsRecorded')==0
    errordlg('Must record a segment first!');
else if getappdata(0,'modelFLAG')==0
        errordlg('Must choose a model first!');
    else
        
        %analyze
        set(handles.ModelDecision_text,'String','Analyzing...'); pause(0.01);
        [handles.SuperVector,Feat_title,processedSignal,framedProcessed]=analyzeSample(handles.Signal,handles.Fs,handles.PREPalpha,handles.PREPwinLength,handles.PREPoverlap,handles.SEGwinLength,handles.SEGeta,handles.SEGdt);

        %plot NRG and ZCR
        set(handles.NRG_axes,'visible','on');
        hold(handles.NRG_axes,'on');
        handles.NRG=calcNRG(framedProcessed);
        plot(handles.NRG_axes,handles.NRG,'r');
        handles.ZCR=calcZCR(framedProcessed);
        handles.ZCR4Plot=handles.ZCR-min(handles.ZCR);
        handles.ZCR4Plot=handles.ZCR4Plot/max(handles.ZCR4Plot)*max(handles.NRG);
        plot(handles.NRG_axes,handles.ZCR4Plot,'k');
        legend(handles.NRG_axes,'NRG','ZCR');
        xlim(handles.NRG_axes,[1 size(framedProcessed,1)]);
        set(handles.NRG_axes,'xtick',[],'xticklabel',{' '},'yticklabel',{' '},'ytick',[]);
        ylim(handles.NRG_axes,1.2*[0 max(handles.NRG)]-max(handles.NRG)*0.1);
        box(handles.NRG_axes,'on');
        
        %compare to model and make a decision
        Decision=classifySpeaker(handles.SuperVector,handles.Model_PATH);
        if Decision==1
            set(handles.ModelDecision_text,'String','This is speaker A');
        else %Decision==2
            set(handles.ModelDecision_text,'String','This is speaker B');
        end
        
        %set visible 'on' for formant analysis
        set(handles.EstFormants_butt,'Visible','on');
        set(handles.Phoneme_choose,'Visible','on');

    end
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Export_butt.
function Export_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Export_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder_name = uigetdir(pwd,'All figures will be saved in the folder you choose...');

if folder_name~=0
   Flag=strcmp(get(handles.EstFormants_butt,'Visible'),'on');
   phon=get(handles.Phoneme_choose,'String');
   exportGraphs(folder_name,handles.Signal,handles.Fs,phon,handles.seg_ind,handles.STFTwinLength,handles.STFToverlap,handles.STFTnfft,handles.STFTcmin,handles.STFTcmax,handles.NRG,handles.ZCR4Plot,Flag);
end

% Update handles structure
guidata(hObject, handles);


function Sampl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Sampl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sampl_edit as text
%        str2double(get(hObject,'String')) returns contents of Sampl_edit as a double
handles.Fs=str2double(get(handles.Sampl_edit,'String'))*1000;
handles.STFTnfft=round(str2double(get(handles.STFTwinLength_edit,'String')))/1000*handles.Fs;
set(handles.STFTnfft_edit,'String',handles.STFTnfft);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Sampl_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sampl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WinLength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to WinLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WinLength_edit as text
%        str2double(get(hObject,'String')) returns contents of WinLength_edit as a double
handles.SEGwinLength=str2double(get(handles.WinLength_edit,'String'))/1000; 

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function WinLength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WinLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of Thresh_edit as a double
handles.SEGeta=str2double(get(handles.Thresh_edit,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TimeAbvThrsh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TimeAbvThrsh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeAbvThrsh_edit as text
%        str2double(get(hObject,'String')) returns contents of TimeAbvThrsh_edit as a double
handles.SEGdt=str2double(get(handles.TimeAbvThrsh_edit,'String'))/1000;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TimeAbvThrsh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeAbvThrsh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Alpha_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Alpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Alpha_edit as text
%        str2double(get(hObject,'String')) returns contents of Alpha_edit as a double
handles.PREPalpha=str2double(get(handles.Alpha_edit,'String')); 

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Alpha_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Alpha_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PreproWinLength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to PreproWinLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreproWinLength_edit as text
%        str2double(get(hObject,'String')) returns contents of PreproWinLength_edit as a double
handles.PREPwinLength=str2double(get(handles.PreproWinLength_edit,'String'))/1000; 

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function PreproWinLength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreproWinLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Overlap_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Overlap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Overlap_edit as text
%        str2double(get(hObject,'String')) returns contents of Overlap_edit as a double
handles.PREPoverlap=str2double(get(handles.Overlap_edit,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Overlap_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Overlap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Seg_butt.
function Seg_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Seg_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(0,'IsRecorded')==0
    errordlg('Must record a segment first!');

else
    %pre-process
    [processedSignal,FramedSig] =PreProcess(handles.Signal,handles.Fs,handles.PREPalpha,handles.PREPwinLength,handles.PREPoverlap);

    %segmantation
    handles.Idx = FindWordIdx(FramedSig,handles.Fs,handles.PREPwinLength,handles.PREPoverlap);
    handles.seg_ind = segmentation(processedSignal,handles.SEGwinLength,handles.SEGeta,handles.SEGdt,handles.Fs,handles.Idx);
    
    %display graph
    cla(handles.Amp_axes);
    set(handles.Amp_axes,'Color',[1 1 1]);
    handles.seg_ind=[1 handles.seg_ind length(handles.Signal)];
    XT=[];
    for i=1:length(handles.seg_ind)-1
        plot(handles.Amp_axes,handles.seg_ind(i):handles.seg_ind(i+1),handles.Signal(handles.seg_ind(i):handles.seg_ind(i+1)));
        XT=[XT round((handles.seg_ind(i)+handles.seg_ind(i+1))/2)];
        hold(handles.Amp_axes,'on');
    end
    xlim(handles.Amp_axes,[1 length(handles.Signal)]);
    set(handles.Amp_axes,'xtick',XT(2:end-1));
    set(handles.Amp_axes,'xticklabel',{'SH','A','L','O','M'});
    set(handles.Amp_axes,'YTickLabel',[]);
    set(handles.Amp_axes,'ylim',1.2*max(abs(handles.Signal))*[-1 1]);
end

% Update handles structure
guidata(hObject, handles);



function STFTwinLength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to STFTwinLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STFTwinLength_edit as text
%        str2double(get(hObject,'String')) returns contents of STFTwinLength_edit as a double
handles.STFTwinLength=round(str2double(get(handles.STFTwinLength_edit,'String'))/1000*handles.Fs); 
handles.STFTnfft=handles.STFTwinLength;
set(handles.STFTnfft_edit,'String',handles.STFTnfft);
handles.STFToverlap=round(str2double(get(handles.STFToverlap_edit,'String'))/100*handles.STFTwinLength);
set(handles.STFToverlap_edit,'String',handles.STFToverlap*100/handles.STFTwinLength);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function STFTwinLength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STFTwinLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function STFToverlap_edit_Callback(hObject, eventdata, handles)
% hObject    handle to STFToverlap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STFToverlap_edit as text
%        str2double(get(hObject,'String')) returns contents of STFToverlap_edit as a double
handles.STFToverlap=round(str2double(get(handles.STFToverlap_edit,'String'))/100*handles.STFTwinLength); 

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function STFToverlap_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STFToverlap_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function STFTnfft_edit_Callback(hObject, eventdata, handles)
% hObject    handle to STFTnfft_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STFTnfft_edit as text
%        str2double(get(hObject,'String')) returns contents of STFTnfft_edit as a double


% --- Executes during object creation, after setting all properties.
function STFTnfft_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STFTnfft_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RefSpec_butt.
function RefSpec_butt_Callback(hObject, eventdata, handles)
% hObject    handle to RefSpec_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[~,F,T,handles.P]=spectrogram(handles.Signal,handles.STFTwinLength,handles.STFToverlap,handles.STFTnfft,handles.Fs,'yaxis');
handles.SPEC=10*log10(handles.P);
handles.SPECPLOT=surf(handles.Spec_axes,T,F,handles.SPEC,'edgecolor','none');
refreshdata(handles.SPECPLOT,'caller');
%set(handles.SPECPLOT,'ZDataSource','handles.SPEC');
caxis(handles.Spec_axes,[handles.STFTcmin handles.STFTcmax]);
colormap(handles.Spec_axes,jet);
view(handles.Spec_axes,[0,90]);
set(handles.Spec_axes,'fontsize',10);
set(handles.Spec_axes,'xlim',[T(1),T(end)]);
set(handles.Spec_axes,'ylim',[0,handles.Fs/2]);
XLABELHANDLE=get(handles.Spec_axes,'xlabel');
YLABELHANDLE=get(handles.Spec_axes,'ylabel');
set(XLABELHANDLE,'string','Time [Sec]');
set(YLABELHANDLE,'string','Frequency [Hz]');
box(handles.Spec_axes,'on');

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in RefSeg_butt.
function RefSeg_butt_Callback(hObject, eventdata, handles)
% hObject    handle to RefSeg_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(0,'IsRecorded')==0
    errordlg('Must record a segment first!');

else
    %pre-process
    [processedSignal,FramedSig]=PreProcess(handles.Signal,handles.Fs,handles.PREPalpha,handles.PREPwinLength,handles.PREPoverlap);

    %segmantation
    handles.Idx = FindWordIdx(FramedSig,handles.Fs,handles.PREPwinLength,handles.PREPoverlap);
    handles.seg_ind = segmentation(processedSignal,handles.SEGwinLength,handles.SEGeta,handles.SEGdt,handles.Fs);
    
    %display graph
    cla(handles.Amp_axes);
    set(handles.Amp_axes,'Color',[1 1 1]);
    handles.seg_ind=[1 handles.seg_ind length(handles.Signal)];
    XT=[];
    for i=1:length(handles.seg_ind)-1
        plot(handles.Amp_axes,handles.seg_ind(i):handles.seg_ind(i+1),handles.Signal(handles.seg_ind(i):handles.seg_ind(i+1)));
        XT=[XT round((handles.seg_ind(i)+handles.seg_ind(i+1))/2)];
        hold(handles.Amp_axes,'on');
    end
    xlim(handles.Amp_axes,[1 length(handles.Signal)]);
    set(handles.Amp_axes,'xtick',XT(2:end-1));
    set(handles.Amp_axes,'xticklabel',{'SH','A','L','O','M'});
    set(handles.Amp_axes,'YTickLabel',[]);
    set(handles.Amp_axes,'ylim',1.2*max(abs(handles.Signal))*[-1 1]);
end

% Update handles structure
guidata(hObject, handles);



function STFTcmin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to STFTcmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STFTcmin_edit as text
%        str2double(get(hObject,'String')) returns contents of STFTcmin_edit as a double
handles.STFTcmin=str2double(get(handles.STFTcmin_edit,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function STFTcmin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STFTcmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function STFTcmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to STFTcmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STFTcmax_edit as text
%        str2double(get(hObject,'String')) returns contents of STFTcmax_edit as a double
handles.STFTcmax=str2double(get(handles.STFTcmax_edit,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function STFTcmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STFTcmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EstFormants_butt.
function EstFormants_butt_Callback(hObject, eventdata, handles)
% hObject    handle to EstFormants_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

phoneme_num=get(handles.Phoneme_choose,'Value');
PhonemeSig=handles.Signal(handles.seg_ind(phoneme_num+1):handles.seg_ind(phoneme_num+2));
PhonemeSig=PhonemeSig(round(length(PhonemeSig)/4):round(length(PhonemeSig)*3/4)); %taking the phoneme center
S=get(handles.Phoneme_choose,'String');
estimatePhonemeFormants(PhonemeSig,handles.Fs,S(phoneme_num));

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in Phoneme_choose.
function Phoneme_choose_Callback(hObject, eventdata, handles)
% hObject    handle to Phoneme_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Phoneme_choose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Phoneme_choose


% --- Executes during object creation, after setting all properties.
function Phoneme_choose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Phoneme_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
