function varargout = ConfigureProjectorOnline(varargin)
% CONFIGUREPROJECTORONLINE MATLAB code for ConfigureProjector.fig
%      CONFIGUREPROJECTORONLINE, by itself, creates a new CONFIGUREPROJECTORONLINE or raises the existing
%      singleton*.
%
%      H = CONFIGUREPROJECTORONLINE returns the handle to a new CONFIGUREPROJECTORONLINE or the handle to
%      the existing singleton*.
%
%      CONFIGUREPROJECTORONLINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGUREPROJECTORONLINE.M with the given input arguments.
%
%      CONFIGUREPROJECTORONLINE('Property','Value',...) creates a new CONFIGUREPROJECTORONLINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConfigureProjectorOnline_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConfigureProjectorOnline_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConfigureProjectorOnline

% Last Modified by MASM v3 20/05/2026 11:30 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConfigureProjectorOnline_OpeningFcn, ...
                   'gui_OutputFcn',  @ConfigureProjectorOnline_OutputFcn, ...
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

global h4 seth4
% h4=NaN;
% disp(h4);

% --- Executes just before ConfigureProjectorOnline is made visible.
function ConfigureProjectorOnline_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConfigureProjectorOnline (see VARARGIN)

% Choose default command line output for ConfigureProjectorOnline
handles.output = hObject;
handles = loadSavedCoordsIntoGui(handles);
handles = setupOnlineCalibrationControls(handles, hObject);

% Update handles structure
guidata(hObject, handles);
global seth4
seth4 = [];

% UIWAIT makes ConfigureProjectorOnline wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ConfigureProjectorOnline_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in regenerateStim.
function regenerateStim_Callback(hObject, eventdata, handles)
global h4 seth4
% hObject    handle to regenerateStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    screenRadius_ = str2num(get(handles.screenRadius,'String'));
    screenX_ = str2num(get(handles.screenX,'String'));
    screenY_ = str2num(get(handles.screenY,'String'));
    screenZ_ = str2num(get(handles.screenZ,'String'));
    
    mirrorRadius_ = str2num(get(handles.mirrorRadius,'String'));
    mirrorX_ = str2num(get(handles.mirrorX,'String'));
    mirrorY_ = str2num(get(handles.mirrorY,'String'));
    mirrorZ_ = str2num(get(handles.mirrorZ,'String'));
    
    projectorX_ = str2num(get(handles.projectorX,'String'));
    projectorY_ = str2num(get(handles.projectorY,'String'));
    projectorZ_ = str2num(get(handles.projectorZ,'String'));
    
    x0_ = str2num(get(handles.x0,'String'));
    y0_ = str2num(get(handles.y0,'String'));
    x1_ = str2num(get(handles.x1,'String'));
    y1_ = str2num(get(handles.y1,'String'));
    x2_ = str2num(get(handles.x2,'String'));
    y2_ = str2num(get(handles.y2,'String'));

%     seth4
    if isempty(seth4)
        seth4 = 1;
        h4=figure('OuterPosition',[10 10 1280 800]);
%             h4=figure('OuterPosition',[0 0 1 1]);
%         disp('ok?')
    end
    h4 = generateDome_shruthi(screenRadius_,screenX_,screenY_,screenZ_, mirrorRadius_,mirrorX_,mirrorY_,mirrorZ_, projectorX_,projectorY_,projectorZ_, ...
        x0_,y0_,x1_,y1_,x2_,y2_,h4);
    
   if exist('visualizeCalibratedBallImage', 'file') == 2
       try
           visualizeCalibratedBallImage(fullfile(pwd, 'calibratedBallImage.data'), 'points', 2, 'white');
       catch ME
           warning('ConfigureProjectorOnline:PreviewFailed', ...
               'Could not preview calibratedBallImage.data: %s', ME.message);
        end
    end

        



function mirrorRadius_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mirrorRadius as text
%        str2double(get(hObject,'String')) returns contents of mirrorRadius as a double


% --- Executes during object creation, after setting all properties.
function mirrorRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirrorRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screenRadius_Callback(hObject, eventdata, handles)
% hObject    handle to screenRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screenRadius as text
%        str2double(get(hObject,'String')) returns contents of screenRadius as a double


% --- Executes during object creation, after setting all properties.
function screenRadius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screenRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screenX_Callback(hObject, eventdata, handles)
% hObject    handle to screenX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screenX as text
%        str2double(get(hObject,'String')) returns contents of screenX as a double


% --- Executes during object creation, after setting all properties.
function screenX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screenX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screenY_Callback(hObject, eventdata, handles)
% hObject    handle to screenY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screenY as text
%        str2double(get(hObject,'String')) returns contents of screenY as a double


% --- Executes during object creation, after setting all properties.
function screenY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screenY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screenZ_Callback(hObject, eventdata, handles)
% hObject    handle to screenZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screenZ as text
%        str2double(get(hObject,'String')) returns contents of screenZ as a double


% --- Executes during object creation, after setting all properties.
function screenZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screenZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mirrorX_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mirrorX as text
%        str2double(get(hObject,'String')) returns contents of mirrorX as a double


% --- Executes during object creation, after setting all properties.
function mirrorX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirrorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mirrorY_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mirrorY as text
%        str2double(get(hObject,'String')) returns contents of mirrorY as a double


% --- Executes during object creation, after setting all properties.
function mirrorY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirrorY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mirrorZ_Callback(hObject, eventdata, handles)
% hObject    handle to mirrorZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mirrorZ as text
%        str2double(get(hObject,'String')) returns contents of mirrorZ as a double


% --- Executes during object creation, after setting all properties.
function mirrorZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mirrorZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function projectorX_Callback(hObject, eventdata, handles)
% hObject    handle to projectorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectorX as text
%        str2double(get(hObject,'String')) returns contents of projectorX as a double


% --- Executes during object creation, after setting all properties.
function projectorX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectorX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function projectorY_Callback(hObject, eventdata, handles)
% hObject    handle to projectorY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectorY as text
%        str2double(get(hObject,'String')) returns contents of projectorY as a double


% --- Executes during object creation, after setting all properties.
function projectorY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectorY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function projectorZ_Callback(hObject, eventdata, handles)
% hObject    handle to projectorZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectorZ as text
%        str2double(get(hObject,'String')) returns contents of projectorZ as a double


% --- Executes during object creation, after setting all properties.
function projectorZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectorZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x0_Callback(hObject, eventdata, handles)
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0 as text
%        str2double(get(hObject,'String')) returns contents of x0 as a double


% --- Executes during object creation, after setting all properties.
function x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y0_Callback(hObject, eventdata, handles)
% hObject    handle to y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y0 as text
%        str2double(get(hObject,'String')) returns contents of y0 as a double


% --- Executes during object creation, after setting all properties.
function y0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double


% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y1_Callback(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y1 as text
%        str2double(get(hObject,'String')) returns contents of y1 as a double


% --- Executes during object creation, after setting all properties.
function y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double


% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y2_Callback(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y2 as text
%        str2double(get(hObject,'String')) returns contents of y2 as a double


% --- Executes during object creation, after setting all properties.
function y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveCoords.
function saveCoords_Callback(hObject, eventdata, handles)
% hObject    handle to saveCoords (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    screenRadius_ = str2num(get(handles.screenRadius,'String'));
    screenX_ = str2num(get(handles.screenX,'String'));
    screenY_ = str2num(get(handles.screenY,'String'));
    screenZ_ = str2num(get(handles.screenZ,'String'));
    
    mirrorRadius_ = str2num(get(handles.mirrorRadius,'String'));
    mirrorX_ = str2num(get(handles.mirrorX,'String'));
    mirrorY_ = str2num(get(handles.mirrorY,'String'));
    mirrorZ_ = str2num(get(handles.mirrorZ,'String'));
    
    projectorX_ = str2num(get(handles.projectorX,'String'));
    projectorY_ = str2num(get(handles.projectorY,'String'));
    projectorZ_ = str2num(get(handles.projectorZ,'String'));
    
    x0_ = str2num(get(handles.x0,'String'));
    y0_ = str2num(get(handles.y0,'String'));
    x1_ = str2num(get(handles.x1,'String'));
    y1_ = str2num(get(handles.y1,'String'));
    x2_ = str2num(get(handles.x2,'String'));
    y2_ = str2num(get(handles.y2,'String'));
    
    coordsPath = fullfile(fileparts(mfilename('fullpath')), 'coords.mat');
    save(coordsPath,'screenRadius_','screenX_','screenY_','screenZ_', 'mirrorRadius_','mirrorX_','mirrorY_','mirrorZ_', 'projectorX_','projectorY_','projectorZ_', ...
                 'x0_','y0_','x1_','y1_','x2_','y2_');
function handles = loadSavedCoordsIntoGui(handles)
coordsPath = fullfile(fileparts(mfilename('fullpath')), 'coords.mat');
if ~exist(coordsPath, 'file') && exist('coords.mat', 'file')
    coordsPath = 'coords.mat';
end

if ~exist(coordsPath, 'file')
    return;
end

try
    coords = load(coordsPath);
    setCoordString(handles, 'screenRadius', coords, 'screenRadius_');
    setCoordString(handles, 'screenX', coords, 'screenX_');
    setCoordString(handles, 'screenY', coords, 'screenY_');
    setCoordString(handles, 'screenZ', coords, 'screenZ_');
    setCoordString(handles, 'mirrorRadius', coords, 'mirrorRadius_');
    setCoordString(handles, 'mirrorX', coords, 'mirrorX_');
    setCoordString(handles, 'mirrorY', coords, 'mirrorY_');
    setCoordString(handles, 'mirrorZ', coords, 'mirrorZ_');
    setCoordString(handles, 'projectorX', coords, 'projectorX_');
    setCoordString(handles, 'projectorY', coords, 'projectorY_');
    setCoordString(handles, 'projectorZ', coords, 'projectorZ_');
    setCoordString(handles, 'x0', coords, 'x0_');
    setCoordString(handles, 'y0', coords, 'y0_');
    setCoordString(handles, 'x1', coords, 'x1_');
    setCoordString(handles, 'y1', coords, 'y1_');
    setCoordString(handles, 'x2', coords, 'x2_');
    setCoordString(handles, 'y2', coords, 'y2_');
catch ME
    warning('ConfigureProjectorOnline:LoadCoordsFailed', ...
        'Could not load saved coords.mat values: %s', ME.message);
end

function setCoordString(handles, handleName, coords, coordName)
if isfield(handles, handleName) && isfield(coords, coordName)
    set(handles.(handleName), 'String', num2str(coords.(coordName), 15));
end
function handles = setupOnlineCalibrationControls(handles, parentFigure)
fieldNames = getCalibrationFieldNames();
for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    if ~isfield(handles, fieldName) || ~ishandle(handles.(fieldName))
        continue;
    end

    editHandle = handles.(fieldName);
    stepSize = getCalibrationStepSize(fieldName);
    addIncrementButtons(parentFigure, editHandle, fieldName, stepSize);
    set(editHandle, 'Callback', @(hObject,eventdata)onlineEdit_Callback(hObject, eventdata));
end

function addIncrementButtons(parentFigure, editHandle, fieldName, stepSize)
buttonParent = get(editHandle, 'Parent');
delete(findobj(buttonParent, 'Tag', ['inc_' fieldName]));
delete(findobj(buttonParent, 'Tag', ['dec_' fieldName]));
oldUnits = get(editHandle, 'Units');
pos = get(editHandle, 'Position');

switch lower(oldUnits)
    case 'normalized'
        buttonWidth = 0.025;
        gap = 0.004;
    case 'pixels'
        buttonWidth = 22;
        gap = 2;
    otherwise
        buttonWidth = 3.2;
        gap = 0.4;
end

buttonHeight = pos(4) / 2;
buttonX = pos(1) + pos(3) + gap;
buttonY = pos(2);

uicontrol('Parent', buttonParent, ...
    'Style', 'pushbutton', ...
    'Units', oldUnits, ...
    'Position', [buttonX buttonY + buttonHeight buttonWidth buttonHeight], ...
    'String', '+', ...
    'FontWeight', 'bold', ...
    'Tag', ['inc_' fieldName], ...
    'Callback', @(hObject,eventdata)incrementCalibrationField_Callback(hObject, eventdata, fieldName, stepSize));

uicontrol('Parent', buttonParent, ...
    'Style', 'pushbutton', ...
    'Units', oldUnits, ...
    'Position', [buttonX buttonY buttonWidth buttonHeight], ...
    'String', '-', ...
    'FontWeight', 'bold', ...
    'Tag', ['dec_' fieldName], ...
    'Callback', @(hObject,eventdata)incrementCalibrationField_Callback(hObject, eventdata, fieldName, -stepSize));

function incrementCalibrationField_Callback(hObject, eventdata, fieldName, delta)
parentFigure = ancestor(hObject, 'figure');
handles = guidata(parentFigure);
if ~isfield(handles, fieldName) || ~ishandle(handles.(fieldName))
    return;
end

currentValue = str2double(get(handles.(fieldName), 'String'));
if isnan(currentValue)
    currentValue = 0;
end

newValue = currentValue + delta;
set(handles.(fieldName), 'String', num2str(newValue, 15));
updateCalibrationOnline(parentFigure, handles);

function onlineEdit_Callback(hObject, eventdata)
parentFigure = ancestor(hObject, 'figure');
handles = guidata(parentFigure);
updateCalibrationOnline(parentFigure, handles);

function updateCalibrationOnline(parentFigure, handles)
guidata(parentFigure, handles);
saveCurrentCoordsFromHandles(handles);
regenerateStim_Callback(parentFigure, [], handles);

function saveCurrentCoordsFromHandles(handles)
screenRadius_ = str2num(get(handles.screenRadius,'String'));
screenX_ = str2num(get(handles.screenX,'String'));
screenY_ = str2num(get(handles.screenY,'String'));
screenZ_ = str2num(get(handles.screenZ,'String'));

mirrorRadius_ = str2num(get(handles.mirrorRadius,'String'));
mirrorX_ = str2num(get(handles.mirrorX,'String'));
mirrorY_ = str2num(get(handles.mirrorY,'String'));
mirrorZ_ = str2num(get(handles.mirrorZ,'String'));

projectorX_ = str2num(get(handles.projectorX,'String'));
projectorY_ = str2num(get(handles.projectorY,'String'));
projectorZ_ = str2num(get(handles.projectorZ,'String'));

x0_ = str2num(get(handles.x0,'String'));
y0_ = str2num(get(handles.y0,'String'));
x1_ = str2num(get(handles.x1,'String'));
y1_ = str2num(get(handles.y1,'String'));
x2_ = str2num(get(handles.x2,'String'));
y2_ = str2num(get(handles.y2,'String'));

coordsPath = fullfile(fileparts(mfilename('fullpath')), 'coords.mat');
save(coordsPath,'screenRadius_','screenX_','screenY_','screenZ_', 'mirrorRadius_','mirrorX_','mirrorY_','mirrorZ_', 'projectorX_','projectorY_','projectorZ_', ...
             'x0_','y0_','x1_','y1_','x2_','y2_');

function fieldNames = getCalibrationFieldNames()
fieldNames = {'screenRadius','screenX','screenY','screenZ', ...
    'mirrorRadius','mirrorX','mirrorY','mirrorZ', ...
    'projectorX','projectorY','projectorZ', ...
    'x0','y0','x1','y1','x2','y2'};

function stepSize = getCalibrationStepSize(fieldName)
switch fieldName
    case {'x0','y0','x1','y1','x2','y2'}
        stepSize = 0.01;
    otherwise
        stepSize = .1;
end
