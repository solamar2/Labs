function varargout = Train_GUI(varargin)
% TRAIN_GUI MATLAB code for Train_GUI.fig
%      TRAIN_GUI, by itself, creates a new TRAIN_GUI or raises the existing
%      singleton*.
%
%      H = TRAIN_GUI returns the handle to a new TRAIN_GUI or the handle to
%      the existing singleton*.
%
%      TRAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAIN_GUI.M with the given input arguments.
%
%      TRAIN_GUI('Property','Value',...) creates a new TRAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Train_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Train_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Train_GUI

% Last Modified by GUIDE v2.5 05-Dec-2016 10:26:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Train_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Train_GUI_OutputFcn, ...
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


% --- Executes just before Train_GUI is made visible.
function Train_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Train_GUI (see VARARGIN)

% Choose default command line output for Train_GUI
handles.output = hObject;

% load a model, if exists, and update text in 'ModelInfo'
if exist('Model.mat','file')
    M=load('Model.mat');
    M=M.Model;
    handles.modelFLAG=1;
    msgbox(['Appending to the model ''Model.mat''' char(10) 'In order to start a new model - exit and change previous model''s name.']);
    set(handles.ModelInfo,'String',['Model consists of:' char(10) num2str(M.countA) ' samples for speaker A' char(10) num2str(M.countB) ' samples for speaker B']);
else 
    set(handles.ModelInfo,'String',['Model consists of:' char(10) '0 samples for speaker A' char(10) '0 samples for speaker B']);
    handles.modelFLAG=0;
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
handles.SEGwinLength=handles.SEGwinLength(2);
handles.SEGeta=str2double(get(handles.Thresh_edit,'String'));
handles.SEGeta=handles.SEGeta(2);
handles.SEGdt=str2double(get(handles.TimeAbvThrsh_edit,'String'))/1000;
handles.SEGdt=handles.SEGdt(2);

% prepare for recording
handles.Fs=16e3;
handles.win=round(0.05*handles.Fs);
handles.nBits=16;
handles.nChannels=1;
handles.TimeToPres=3;
handles.SampToPresent=handles.TimeToPres*handles.Fs;
handles.a_obj_handle=audiorecorder(handles.Fs,handles.nBits,handles.nChannels);
%present hypothetic zero signal
handles.TIMESIG=zeros(handles.SampToPresent,1);
handles.ZerSig=handles.TIMESIG;
handles.WaveFormSig=handles.TIMESIG(end-handles.win+1:end);
handles.WFPLOT=plot(handles.axes1,[1:length(handles.WaveFormSig)],handles.WaveFormSig,'color',[0;139;69]/256,'linewidth',2);
handles.XDataSig=[1:length(handles.WaveFormSig)];
set(handles.WFPLOT,'YDataSource','handles.WaveFormSig');
set(handles.WFPLOT,'XDataSource','handles.XDataSig');
set(handles.axes1,'ylim',[-1 1]);
set(handles.axes1,'XTickLabel',[],'YTickLabel',[]);
set(handles.axes1,'Color',[0 0 0 ]);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Train_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Train_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Record_butt.
function Record_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Record_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(0,'IsRunning')==true %recording now and button was pressed to stop
    IsRunning=false;
    setappdata(0,'IsRunning',IsRunning);
    %disable recording button
    set(handles.Record_butt,'visible','off');
    set(handles.Record_butt,'String','Record');
    set(handles.Clear_butt,'visible','on');

else % start recording    
    
    handles.WaveFormSig=handles.ZerSig;
    refreshdata(handles.WFPLOT,'caller');
    drawnow;
    %start recording
    record(handles.a_obj_handle);
    set(handles.Record_butt,'String','Stop');
    IsRunning=true;
    setappdata(0,'IsRunning',IsRunning);
    setappdata(0,'IsRecorded',1);
    set(handles.Clear_butt,'visible','off');

    pause(0.1);
    while getappdata(0,'IsRunning')
        handles.Signal=getaudiodata(handles.a_obj_handle);
        handles.TotSig=[handles.ZerSig;handles.Signal];
        handles.Sig2Pres=handles.TotSig(end-handles.SampToPresent+1:end);
        handles.WaveFormSig=handles.Sig2Pres(end-handles.win+1:end);
        handles.XDataSig=[1:length(handles.WaveFormSig)];
        refreshdata(handles.WFPLOT,'caller');
        set(handles.axes1,'ylim',1.2*max(abs(handles.Sig2Pres))*[-1 1]);
        drawnow;
    end;

    %% stop recording
    stop(handles.a_obj_handle);
    handles.Signal=getaudiodata(handles.a_obj_handle);
    
    %% present product
    handles.WFPLOT=plot(handles.axes1,[1:length(handles.Signal)],handles.Signal,'color',[0;139;69]/256,'linewidth',2);
    set(handles.axes1,'ylim',1.2*max(abs(handles.Signal))*[-1 1]);
    set(handles.axes1,'xlim',[1 length(handles.Signal)]);
    set(handles.axes1,'XTickLabel',[],'YTickLabel',[]);
    set(handles.axes1,'Color',[0 0 0 ]);
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in Clear_butt.
function Clear_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%enable recording button
set(handles.Record_butt,'visible','on');
set(handles.Record_butt,'String','Record');
% status flag
setappdata(0,'IsRunning',0);
setappdata(0,'IsRecorded',0);
hold(handles.axes1,'off');
cla(handles.axes1);
    
% prepare for recording
handles.SampToPresent=handles.TimeToPres*handles.Fs;
handles.a_obj_handle=audiorecorder(handles.Fs,handles.nBits,handles.nChannels);
%present hypothetic zero signal
handles.TIMESIG=zeros(handles.SampToPresent,1);
handles.ZerSig=handles.TIMESIG;
handles.WaveFormSig=handles.TIMESIG(end-handles.win+1:end);
handles.WFPLOT=plot(handles.axes1,[1:length(handles.WaveFormSig)],handles.WaveFormSig,'color',[0;139;69]/256,'linewidth',2);
handles.XDataSig=[1:length(handles.WaveFormSig)];
set(handles.WFPLOT,'YDataSource','handles.WaveFormSig');
set(handles.WFPLOT,'XDataSource','handles.XDataSig');
set(handles.axes1,'ylim',[-1 1]);
set(handles.axes1,'XTickLabel',[],'YTickLabel',[]);
set(handles.axes1,'Color',[0 0 0 ]);

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in Add_butt.
function Add_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Add_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if getappdata(0,'IsRecorded')==0
    errordlg('Must record a segment first!');
else
    
    %analysis
    [SuperVector,Feat_title]=analyzeSample(handles.Signal,handles.Fs,handles.PREPalpha,handles.PREPwinLength,handles.PREPoverlap,handles.SEGwinLength,handles.SEGeta,handles.SEGdt);
    
    if handles.modelFLAG==0
        Model=[];
        Model.countA=0; Model.countB=0;
        Model.FeatsA=[]; Model.FeatsB=[];
        Model.SigA={}; Model.SigB={};
    else
        Model=load('Model.mat');
        Model=Model.Model;
    end
    
    if get(handles.ChooseSpeaker,'Value')==1 % Speaker A
        Model.FeatsA=[Model.FeatsA ; SuperVector];
        Model.countA=Model.countA+1;
        Model.SigA{Model.countA}=handles.Signal;
    else % Speaker B
        Model.FeatsB=[Model.FeatsB ; SuperVector];
        Model.countB=Model.countB+1;
        Model.SigB{Model.countB}=handles.Signal;
    end
    
    handles.modelFLAG=1;
    set(handles.ModelInfo,'String',['Model consists of:' char(10) num2str(Model.countA) ' samples for speaker A' char(10) num2str(Model.countB) ' samples for speaker B']);
    setappdata(0,'IsRecorded',0);
    Model.Feat_title=Feat_title;
    save('Model.mat','Model');
    msgbox('Sample was added to ''Model.mat'' successfully');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in ChooseSpeaker.
function ChooseSpeaker_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseSpeaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChooseSpeaker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChooseSpeaker


% --- Executes during object creation, after setting all properties.
function ChooseSpeaker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChooseSpeaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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
    handles.seg_ind = segmentation( processedSignal ,handles.SEGwinLength,handles.SEGeta,handles.SEGdt,handles.Fs,handles.Idx );

    %display graph
    cla(handles.axes1);
    set(handles.axes1,'Color',[1 1 1]);
    handles.seg_ind=[1 handles.seg_ind length(processedSignal)];
    XTL=[];
    for i=1:length(handles.seg_ind)-1
       plot(handles.axes1,handles.seg_ind(i):handles.seg_ind(i+1),processedSignal(handles.seg_ind(i):handles.seg_ind(i+1)));
       XTL=[XTL round((handles.seg_ind(i)+handles.seg_ind(i+1))/2)];
       hold(handles.axes1,'on');
    end
    xlim(handles.axes1,[1 length(processedSignal)]);
    set(handles.axes1,'xtick',XTL(2:end-1));
    set(handles.axes1,'xticklabel',{'SH','A','L','O','M'});
    set(handles.axes1,'YTickLabel',[]);
    set(handles.axes1,'ylim',1.2*max(abs(handles.Signal))*[-1 1]);
end

% Update handles structure
guidata(hObject, handles);



function WinLength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to WinLength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WinLength_edit as text
%        str2double(get(hObject,'String')) returns contents of WinLength_edit as a double
handles.SEGwinLength=str2double(get(handles.WinLength_edit,'String'))/1000; 
handles.SEGwinLength=handles.SEGwinLength(end);
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
handles.SEGeta=handles.SEGeta(end);
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
handles.SEGdt=handles.SEGdt(end);

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



function Sampl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Sampl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sampl_edit as text
%        str2double(get(hObject,'String')) returns contents of Sampl_edit as a double
handles.Fs=str2double(get(handles.Sampl_edit,'String'))*1000;

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



% function edit4_Callback(hObject, eventdata, handles)
% % hObject    handle to WinLength_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of WinLength_edit as text
% %        str2double(get(hObject,'String')) returns contents of WinLength_edit as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit4_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to WinLength_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% 
% function edit5_Callback(hObject, eventdata, handles)
% % hObject    handle to Thresh_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of Thresh_edit as text
% %        str2double(get(hObject,'String')) returns contents of Thresh_edit as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit5_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to Thresh_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% 
% function edit6_Callback(hObject, eventdata, handles)
% % hObject    handle to TimeAbvThrsh_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of TimeAbvThrsh_edit as text
% %        str2double(get(hObject,'String')) returns contents of TimeAbvThrsh_edit as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit6_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to TimeAbvThrsh_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 

% --- Executes on button press in Close_butt.
function Close_butt_Callback(hObject, eventdata, handles)
% hObject    handle to Close_butt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;
