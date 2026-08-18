function hFig = visualizeCalibratedBallImage(dataFile, viewMode, monitorIndex, colorMode)
%VISUALIZECALIBRATEDBALLIMAGE Visualize a calibratedBallImage.data warp file.
%
% Usage:
%   visualizeCalibratedBallImage
%   visualizeCalibratedBallImage([], 'mesh', 2)
%   visualizeCalibratedBallImage('C:\path\to\calibratedBallImage.data')
%   visualizeCalibratedBallImage([], 'points')
%   visualizeCalibratedBallImage([], 'points', 2, 'rainbow')
%   visualizeCalibratedBallImage([], 'texture')
%   visualizeCalibratedBallImage([], 'density')
%   visualizeCalibratedBallImage([], 'all')
%
% By default this shows only the projector warp mesh, fullscreen on the
% second monitor when available. The file is produced by
% ConfigureProjector/generateDome_MASM.

if nargin < 1 || isempty(dataFile)
    dataFile = findDefaultCalibrationFile();
end

if nargin < 2 || isempty(viewMode)
    viewMode = 'mesh';
end

if nargin < 3 || isempty(monitorIndex)
    monitorIndex = 2;
end

if nargin < 4 || isempty(colorMode)
    colorMode = 'white';
end

[versionNumber, nRows, nCols, calibrationData] = readCalibrationData(dataFile);

x = reshape(calibrationData(:, 1), nRows, nCols);
y = reshape(calibrationData(:, 2), nRows, nCols);
u = reshape(calibrationData(:, 3), nRows, nCols);
v = reshape(calibrationData(:, 4), nRows, nCols);
intensity = reshape(calibrationData(:, 5), nRows, nCols);
rgb = cat(3, clamp01(u), clamp01(v), clamp01(intensity));

switch lower(viewMode)
    case 'mesh'
        hFig = createPreviewFigure(dataFile, monitorIndex);
        drawProjectorMesh(x, y, rgb);
    case 'points'
        hFig = createPreviewFigure(dataFile, monitorIndex);
        drawCalibrationPoints(x, y, rgb, colorMode);
    case 'texture'
        hFig = createPreviewFigure(dataFile, monitorIndex);
        drawTextureCoordinates(u, v, rgb);
    case 'density'
        hFig = createPreviewFigure(dataFile, monitorIndex);
        drawPointDensity(x, y);
    case 'all'
        hFig = [
            visualizeCalibratedBallImage(dataFile, 'mesh', monitorIndex)
            visualizeCalibratedBallImage(dataFile, 'points', 1, colorMode)
            visualizeCalibratedBallImage(dataFile, 'texture', 1)
            visualizeCalibratedBallImage(dataFile, 'density', 1)
            ];
    otherwise
        error('visualizeCalibratedBallImage:UnknownViewMode', ...
            'Unknown viewMode "%s". Use mesh, points, texture, density, or all.', viewMode);
end

% No titles or labels in projection preview modes; text distorts the projected image.
end

function hFig = createPreviewFigure(dataFile, monitorIndex)
hFig = findobj(0, 'Type', 'figure', 'Tag', 'CalibratedBallImagePreview');
if isempty(hFig) || ~ishandle(hFig(1))
    hFig = figure('Name', ['Calibration preview: ' dataFile], ...
        'Color', 'k', ...
        'NumberTitle', 'off', ...
        'MenuBar', 'none', ...
        'ToolBar', 'none', ...
        'Tag', 'CalibratedBallImagePreview');
else
    hFig = hFig(1);
    figure(hFig);
    clf(hFig);
    set(hFig, 'Name', ['Calibration preview: ' dataFile], ...
        'Color', 'k', ...
        'MenuBar', 'none', ...
        'ToolBar', 'none');
end
moveFigureToMonitor(hFig, monitorIndex);
end

function drawProjectorMesh(x, y, rgb)
ax = axes('Units', 'normalized', 'Position', [0 0 1 1], 'Color', 'k');
surface(ax, x, y, zeros(size(x)), rgb, ...
    'FaceColor', 'interp', ...
    'EdgeColor', [0.05 0.05 0.05], ...
    'LineWidth', 0.75);
view(ax, 2);
axis(ax, 'equal', 'tight', 'off');
set(ax, 'Color', 'k', 'Position', [0 0 1 1]);
end

function drawCalibrationPoints(x, y, rgb, colorMode)
ax = axes('Units', 'normalized', 'Position', [0 0 1 1], 'Color', 'k');

switch lower(colorMode)
    case 'white'
        plot(ax, x(:), y(:), '.', ...
            'Color', [1 1 1], ...
            'MarkerSize', 12);
    case 'rainbow'
        scatter(ax, x(:), y(:), 28, rgbToScatter(rgb), 'filled');
    otherwise
        error('visualizeCalibratedBallImage:UnknownColorMode', ...
            'Unknown colorMode "%s". Use white or rainbow.', colorMode);
end

axis(ax, 'equal', 'tight', 'off');
set(ax, 'Color', 'k', 'XColor', 'none', 'YColor', 'none');
set(get(ax, 'Parent'), 'Color', 'k', 'InvertHardcopy', 'off');
end

function drawTextureCoordinates(u, v, rgb)
surface(u, v, zeros(size(u)), rgb, ...
    'FaceColor', 'interp', ...
    'EdgeColor', [0.15 0.15 0.15], ...
    'LineWidth', 0.5);
view(2);
axis equal tight;
grid on;
xlabel('U');
ylabel('V');
set(gca, 'Color', 'w');
end

function drawPointDensity(x, y)
histogram2(x(:), y(:), 24, 'DisplayStyle', 'tile', 'ShowEmptyBins', 'on');
axis tight;
colorbar;
xlabel('Projector X');
ylabel('Projector Y');
set(gca, 'Color', 'w');
end

function moveFigureToMonitor(hFig, monitorIndex)
try
    monitorPositions = get(groot, 'MonitorPositions');
catch
    monitorPositions = get(0, 'MonitorPositions');
end

if isempty(monitorPositions)
    set(hFig, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    return;
end

monitorIndex = min(max(1, monitorIndex), size(monitorPositions, 1));
set(hFig, 'Units', 'pixels', 'OuterPosition', monitorPositions(monitorIndex, :));
drawnow;
end

function dataFile = findDefaultCalibrationFile()
scriptDir = fileparts(mfilename('fullpath'));
candidateFiles = {
    fullfile(pwd, 'calibratedBallImage.data')
    fullfile(scriptDir, 'calibratedBallImage.data')
    fullfile('C:\Users\ms2910\Downloads\Murthy\ayelet\projection', 'calibratedBallImage.data')
    };

for i = 1:numel(candidateFiles)
    if exist(candidateFiles{i}, 'file')
        dataFile = candidateFiles{i};
        return;
    end
end

error('visualizeCalibratedBallImage:MissingFile', ...
    ['Could not find calibratedBallImage.data. Run ConfigureProjector and ', ...
     'click Regenerate Stim first, or pass the .data file path explicitly.']);
end

function [versionNumber, nRows, nCols, calibrationData] = readCalibrationData(dataFile)
fid = fopen(dataFile, 'r');
if fid < 0
    error('visualizeCalibratedBallImage:OpenFailed', ...
        'Could not open file: %s', dataFile);
end
cleanup = onCleanup(@() fclose(fid));

versionNumber = fscanf(fid, '%f', 1);
gridSize = fscanf(fid, '%d', 2);
if numel(gridSize) ~= 2
    error('visualizeCalibratedBallImage:InvalidHeader', ...
        'Invalid calibration file header: %s', dataFile);
end

nRows = gridSize(1);
nCols = gridSize(2);
calibrationData = fscanf(fid, '%f', [5, inf])';
expectedRows = nRows * nCols;

if size(calibrationData, 1) ~= expectedRows || size(calibrationData, 2) ~= 5
    error('visualizeCalibratedBallImage:InvalidData', ...
        'Expected %d data rows with 5 columns, but found %d rows.', ...
        expectedRows, size(calibrationData, 1));
end
end

function values = clamp01(values)
values = max(0, min(1, values));
end

function colors = rgbToScatter(rgb)
colors = reshape(rgb, [], 3);
colors = clamp01(colors);
end
