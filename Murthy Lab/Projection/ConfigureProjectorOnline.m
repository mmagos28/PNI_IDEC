function varargout = ConfigureProjectorOnline(varargin)
% CONFIGUREPROJECTORONLINE MATLAB code for ConfigureProjectorOnline.fig
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
addV2CalibrationPath();
handles = loadSavedCoordsIntoGui(handles);
handles = setupOnlineCalibrationControls(handles, hObject);
handles = setupPatternModeControl(handles, hObject);

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
    parentFigure = getParentFigure(hObject, handles);
    if ~isempty(parentFigure)
        handles = guidata(parentFigure);
    end

%     seth4
    if isempty(seth4) || isempty(h4) || ~ishandle(h4)
        seth4 = 1;
        h4=figure('OuterPosition',[10 10 1280 800]);
%             h4=figure('OuterPosition',[0 0 1 1]);
%         disp('ok?')
    end

    if shouldUseVisualGrid(handles)
        [coords, isValid] = tryReadCalibrationCoords(handles);
        if ~isValid
            return;
        end
        drawVisualCalibrationGrid(h4, coords);
        return;
    end

    [coords, isValid] = tryReadCalibrationCoords(handles);
    if ~isValid
        return;
    end

    h4 = generateDome_MASM(coords.screenRadius_,coords.screenX_,coords.screenY_,coords.screenZ_, coords.mirrorRadius_,coords.mirrorX_,coords.mirrorY_,coords.mirrorZ_, coords.projectorX_,coords.projectorY_,coords.projectorZ_, ...
        coords.x0_,coords.y0_,coords.x1_,coords.y1_,coords.x2_,coords.y2_,h4);
    % Run visualizeCalibratedBallImage manually when a separate .data preview is needed.

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
[coords, isValid] = tryReadCalibrationCoords(handles);
if ~isValid
    return;
end
saveCalibrationCoords(coords);
writeProjectionParametersText(coords);

function handles = loadSavedCoordsIntoGui(handles)
try
    coords = loadCalibrationCoords();
    handles = applyCalibrationCoordsToHandles(handles, coords);
catch ME
    warning('ConfigureProjectorOnline:LoadCoordsFailed', ...
        'Could not load saved coords.mat values: %s', ME.message);
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

function addV2CalibrationPath()
v2Path = fullfile(fileparts(mfilename('fullpath')), 'v2');
if exist(v2Path, 'dir') && ~contains(path, v2Path)
    addpath(v2Path);
end

function handles = setupPatternModeControl(handles, parentFigure)
existingControl = findobj(parentFigure, 'Tag', 'visualGridMode');
if ~isempty(existingControl)
    handles.visualGridMode = existingControl(1);
    return;
end

handles.visualGridMode = uicontrol('Parent', parentFigure, ...
    'Style', 'checkbox', ...
    'Units', 'normalized', ...
    'Position', [0.72 0.94 0.24 0.035], ...
    'String', 'Visual grid', ...
    'Value', 0, ...
    'Tag', 'visualGridMode', ...
    'BackgroundColor', get(parentFigure, 'Color'), ...
    'Callback', @(hObject,eventdata)visualGridMode_Callback(hObject, eventdata));

function visualGridMode_Callback(hObject, eventdata)
parentFigure = ancestor(hObject, 'figure');
handles = guidata(parentFigure);
guidata(parentFigure, handles);
regenerateStim_Callback(parentFigure, [], handles);

function parentFigure = getParentFigure(hObject, handles)
parentFigure = [];
if nargin >= 1 && ~isempty(hObject) && ishghandle(hObject)
    parentFigure = ancestor(hObject, 'figure');
end
if isempty(parentFigure) && nargin >= 2 && isstruct(handles) && isfield(handles, 'figure1') && ishghandle(handles.figure1)
    parentFigure = handles.figure1;
end

function useVisualGrid = shouldUseVisualGrid(handles)
useVisualGrid = false;
if isstruct(handles) && isfield(handles, 'visualGridMode') && ishghandle(handles.visualGridMode)
    useVisualGrid = get(handles.visualGridMode, 'Value') == 1;
end

function drawVisualCalibrationGrid(hFig, coords)
if exist('generateCalibrationPatternV2', 'file') ~= 2
    error('ConfigureProjectorOnline:MissingVisualGrid', ...
        'generateCalibrationPatternV2.m was not found on the MATLAB path.');
end
generateCalibrationPatternV2('FigureHandle', hFig, ...
    'FullScreen', false, ...
    'CalibrationCoords', coords, ...
    'XLimits', [-1140/912 1140/912], ...
    'YLimits', [-1 1]);
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
[coords, isValid] = tryReadCalibrationCoords(handles);
if ~isValid
    return;
end
saveCalibrationCoords(coords);

function [coords, isValid] = tryReadCalibrationCoords(handles)
try
    coords = readCalibrationCoordsFromHandles(handles);
    isValid = true;
catch ME
    coords = struct();
    isValid = false;
    warning('ConfigureProjectorOnline:InvalidCalibrationValue', ...
        'Could not read calibration values: %s', ME.message);
end
