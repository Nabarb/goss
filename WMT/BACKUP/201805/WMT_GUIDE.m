function varargout = WMT_GUIDE(varargin)
% WMT_GUIDE MATLAB code for WMT_GUIDE.fig
% GUI for handling working memory task

% Marianna Semprini
% IIT, October 2017

% Last Modified by GUIDE v2.5 28-Nov-2017 10:52:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @WMT_GUIDE_OpeningFcn, ...
    'gui_OutputFcn',  @WMT_GUIDE_OutputFcn, ...
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


% --- Executes just before WMT_GUIDE is made visible.
function WMT_GUIDE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WMT_GUIDE (see VARARGIN)

% Choose default command line output for WMT_GUIDE
handles.output = hObject;

warning off;
set(handles.date_edit,'string',date);

set(handles.ct_radiobutton,'value',1);
set(handles.rs_radiobutton,'value',0);
set(handles.phase_listbox,'visible','on');
set(handles.phase_uipanel,'visible','on');
set(handles.duration_text,'visible','off');
set(handles.duration_edit,'visible','off');

% set default values
handles.rs_duration = 2;
handles.phase = 'pre stimulation';
handles.trialTime = 0.5;
handles.itiTime = 2.5;
handles.nStim = 32;
handles.nSeq = 130;
handles.seq1.back = 2;
handles.seq2.back = 2;


handles.sessionIN = daq.createSession('ni');
addDigitalChannel(handles.sessionIN,'Dev3','Port0/Line4','InputOnly');
handles.sessionIN.NumberOfScans = 10000;

handles.sessionOUT = daq.createSession('ni');
addDigitalChannel(handles.sessionOUT,'Dev3','Port0/Line0:3','OutputOnly');
outputSingleScan(handles.sessionOUT,[0,0,0,0]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WMT_GUIDE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WMT_GUIDE_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_pushbutton.
function start_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.name_edit,'string'))
    errordlg('Subject name missing!');
else
    handles.startTime = datetime('now','format','HH:mm:ss');
    
    if get(handles.rs_radiobutton,'value') % RESTING STATE POTENTIAL
        message = {'STARTING EXPERIMENT:'; ['subject........................................... ' get(handles.name_edit,'string')]; ['resting state acquisition for............ ' num2str(handles.rs_duration) ' minutes']};
        response = questdlg(message,'','CONFIRM','RETURN','CONFIRM');
        switch response
            case 'CONFIRM'
                set(hObject,'enable','off');
                
                % send istructions
                WMT_displayInstructions(handles.phase);
                
                outputSingleScan(handles.sessionOUT,[1,0,0,0]);
                f = WMT_displayFixationCross;
                tic;
                while toc < 60*handles.rs_duration && isgraphics(f)
                    handles.actualDuration = toc;
                    drawnow;
                end
                outputSingleScan(handles.sessionOUT,[0,0,0,0]);
                
                WMT_displayInstructions('conclusion');
                
                % save data
                flag = 0;
                while ~flag
                    flag = WMT_saveData(handles);
                end
                
            case 'return'
        end
    else
        % WORKING MEMORY TASK
        message = {'STARTING EXPERIMENT:'; ['subject.......... ' get(handles.name_edit,'string')]; ['phase........... ' handles.phase]};
        response = questdlg(message,'','CONFIRM','RETURN','CONFIRM');
        outputSingleScan(handles.sessionOUT,[0,0,0,0]);
        switch response
            case 'CONFIRM'
                set(hObject,'enable','off');
                handles.pressTime = [];
                
                % update sequence details
                if strcmp(handles.phase, 'stimulation')     % 2 sequences of 2-back
                    handles.seq1.back = 2;
                    handles.seq2.back = 2;
                else                                        % 2- and 3- back sequence in random order
                    seed = rand(1);
                    order = [2 2] + [seed>0.5 seed<=0.5];
                    handles.seq1.back = order(1);
                    handles.seq2.back = order(2);
                end
                
                if strcmp(handles.phase,'stimulation');   % if stimulation phase, begin with 2' of resting state potential
                    WMT_displayInstructions('resting state');
                    
                    outputSingleScan(handles.sessionOUT,[1,0,0,0]);
                    f = WMT_displayFixationCross;
                    tic;
                    while toc < 60*2 && isgraphics(f)
                        handles.actualDuration(1) = toc;
                        drawnow;
                    end
                    outputSingleScan(handles.sessionOUT,[0,0,0,0]);
                    
                    WMT_displayInstructions('conclusion');
                end
                
                % sequence 1
                [handles.seq1.sequence,  handles.seq1.stimuli] = WMT_buildSequence(handles.nStim, handles.nSeq, handles.seq1.back);
                WMT_displayInstructions(handles.phase, handles.seq1.back);
                [handles.seq1.pressTime, seq1Completed] = WMT_displaySequence(handles.seq1.sequence, handles.seq1.stimuli, handles.seq1.back, handles.trialTime, handles.itiTime, handles.sessionIN, handles.sessionOUT);
                if seq1Completed
                    WMT_displayInstructions('conclusion');
                    
                    if strcmp(handles.phase,'stimulation');   % if stimulation phase, record 5' of resting state potential
                        WMT_displayInstructions('resting state');
                        
                        outputSingleScan(handles.sessionOUT,[1,0,0,0]);
                        f = WMT_displayFixationCross;
                        tic;
                        while toc < 60*5 && isgraphics(f)
                            handles.actualDuration(2) = toc;
                            drawnow;
                        end
                        outputSingleScan(handles.sessionOUT,[0,0,0,0]);
                        
                        WMT_displayInstructions('conclusion');
                    else
                        pause(5);
                    end
                    
                    % sequence 2
                    [handles.seq2.sequence, handles.seq2.stimuli] = WMT_buildSequence(handles.nStim, handles.nSeq, handles.seq2.back);
                    WMT_displayInstructions(handles.phase, handles.seq2.back);
                    [handles.seq2.pressTime, seq2Completed] = WMT_displaySequence(handles.seq2.sequence, handles.seq2.stimuli, handles.seq2.back, handles.trialTime, handles.itiTime, handles.sessionIN, handles.sessionOUT);
                    if seq2Completed
                        WMT_displayInstructions('conclusion');
                        
                        if strcmp(handles.phase,'stimulation');   % if stimulation phase, end with 2' of resting state potential
                            WMT_displayInstructions('resting state');
                            
                            outputSingleScan(handles.sessionOUT,[1,0,0,0]);
                            f = WMT_displayFixationCross;
                            tic;
                            while toc < 60*2 && isgraphics(f)
                                handles.actualDuration(3) = toc;
                                drawnow;
                            end
                            outputSingleScan(handles.sessionOUT,[0,0,0,0]);
                            
                            WMT_displayInstructions('conclusion');
                        end
                        % save data
                        flag = 0;
                        while ~flag
                            flag = WMT_saveData(handles);
                        end
                    end
                end
                
            case 'RETURN'
        end
    end
    set(hObject,'enable','on');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in phase_listbox.
function phase_listbox_Callback(hObject, ~, handles)
% hObject    handle to phase_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns phase_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from phase_listbox

sequence_list = cellstr(get(hObject,'String'));
handles.phase = sequence_list{get(hObject,'Value')};

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in ct_radiobutton.
function ct_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to ct_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ct_radiobutton

if get(hObject,'Value')
    sequence_list = cellstr(get(handles.phase_listbox,'String'));
    handles.phase = sequence_list{get(handles.phase_listbox,'Value')};
    set(handles.rs_radiobutton,'value',0);
    set(handles.phase_listbox,'visible','on');
    set(handles.phase_uipanel,'title','Sequence');
    set(handles.duration_text,'visible','off');
    set(handles.duration_edit,'visible','off');
else
    handles.phase = 'resting state';
    set(handles.rs_radiobutton,'value',1);
    set(handles.phase_listbox,'visible','off');
    set(handles.phase_uipanel,'title','Recording');
    set(handles.duration_text,'visible','on');
    set(handles.duration_edit,'visible','on');
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rs_radiobutton.
function rs_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to rs_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rs_radiobutto

if get(hObject,'Value')
    handles.phase = 'resting state';
    set(handles.ct_radiobutton,'value',0);
    set(handles.phase_listbox,'visible','off');
    set(handles.phase_uipanel,'title','Recording');
    set(handles.duration_text,'visible','on');
    set(handles.duration_edit,'visible','on');
else
    sequence_list = cellstr(get(handles.phase_listbox,'String'));
    handles.phase = sequence_list{get(handles.phase_listbox,'Value')};
    set(handles.ct_radiobutton,'value',1);
    set(handles.phase_listbox,'title','Sequence');
    set(handles.phase_uipanel,'visible','on');
    set(handles.duration_text,'visible','off');
    set(handles.duration_edit,'visible','off');
end

% Update handles structure
guidata(hObject, handles);


function duration_edit_Callback(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_edit as text
%        str2double(get(hObject,'String')) returns contents of duration_edit as a double

handles.rs_duration = str2double(get(hObject,'String'));
if isnan(handles.rs_duration)||handles.rs_duration<2||handles.rs_duration>30
    h = errordlg('Enter a number between 2 and 30!'); drawnow;
    set(hObject,'string',2);
    uiwait(h)
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function duration_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function date_edit_Callback(hObject, eventdata, handles)
% hObject    handle to date_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function date_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function phase_listbox_CreateFcn(hObject, ~, handles)
% hObject    handle to phase_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


