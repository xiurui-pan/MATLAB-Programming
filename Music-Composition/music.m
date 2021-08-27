function varargout = music(varargin)
% MUSIC MATLAB code for music.fig
%      MUSIC, by itself, creates a new MUSIC or raises the existing
%      singleton*.
%
%      H = MUSIC returns the handle to a new MUSIC or the handle to
%      the existing singleton*.
%
%      MUSIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MUSIC.M with the given input arguments.
%
%      MUSIC('Property','Value',...) creates a new MUSIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before music_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to music_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help music

% Last Modified by GUIDE v2.5 24-Aug-2021 09:56:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @music_OpeningFcn, ...
                   'gui_OutputFcn',  @music_OutputFcn, ...
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


% --- Executes just before music is made visible.
function music_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to music (see VARARGIN)

% Choose default command line output for music
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes music wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = music_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in timbre.
function timbre_Callback(hObject, eventdata, handles)
% hObject    handle to timbre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global timbre;

str = get(hObject, 'String');
val = get(hObject, 'Value');
switch str{val}
case '吉他'
   timbre = 1;
case '管乐'
    timbre = 2; 
end

% Hints: contents = cellstr(get(hObject,'String')) returns timbre contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timbre


% --- Executes during object creation, after setting all properties.
function timbre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timbre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_notes_Callback(hObject, eventdata, handles)
% hObject    handle to input_notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_notes as text
%        str2double(get(hObject,'String')) returns contents of input_notes as a double


% --- Executes during object creation, after setting all properties.
function input_notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global volume;
volume = get(hObject, 'Value')

% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Max', 5);
set(hObject, 'Min', 0);
set(hObject, 'Value', 1)


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global volume;
global notes;
global notes_nums;
disp(volume);

notes = repmat(struct('pitch', '0C1', 'beat', 8), 1024, 1);
text_ = get(handles.input_notes, 'String');

[notes_nums, ~] = size(text_);
for i = 1:notes_nums
    notes(i).pitch = text_(i, 1:3);
    notes(i).beat  = fix(str2double(text_(i, 5)));
end

music_12();
