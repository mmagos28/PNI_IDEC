function hFig = generateCalibrationPatternV2(varargin)
% generateCalibrationPatternV2 Draw a calibration grid from code.
%
% Without CalibrationCoords, this draws a flat polar reference grid. With
% CalibrationCoords, each azimuth/elevation line is projected through the
% same dome/mirror geometry used by generateDome_MASM.

params = parsePatternInputs(varargin{:});

if isempty(params.FigureHandle) || ~ishandle(params.FigureHandle)
    hFig = figure('Name', 'Calibration Pattern V2', ...
        'Color', params.BackgroundColor, ...
        'NumberTitle', 'off', ...
        'MenuBar', 'none', ...
        'ToolBar', 'none');
else
    hFig = params.FigureHandle;
    clf(hFig);
    set(hFig, 'Color', params.BackgroundColor, ...
        'Name', 'Calibration Pattern V2', ...
        'NumberTitle', 'off', ...
        'MenuBar', 'none', ...
        'ToolBar', 'none');
end

ax = axes('Parent', hFig);
hold(ax, 'on');
axis(ax, 'off');
set(ax, 'Color', params.BackgroundColor, ...
    'Position', [0 0 1 1], ...
    'DataAspectRatioMode', 'auto', ...
    'PlotBoxAspectRatioMode', 'auto');
xlim(ax, params.XLimits);
ylim(ax, params.YLimits);

if isempty(params.CalibrationCoords)
    drawFlatPolarGrid(ax, params);
else
    drawWarpedDomeGrid(ax, params, params.CalibrationCoords);
end

if params.FullScreen
    movePatternToMonitor(hFig, params.MonitorIndex);
end
end

function drawFlatPolarGrid(ax, params)
theta = linspace(0, 2*pi, params.CircleResolution);
ringRadii = params.RingStep:params.RingStep:params.Radius;
for r = ringRadii
    plot(ax, r*cos(theta), r*sin(theta), ...
        'Color', params.GridColor, ...
        'LineWidth', params.LineWidth);
end

angles = params.AngleMin:params.AngleStep:params.AngleMax;
for angleDeg = angles
    [x1, y1] = flatAngleToXY(angleDeg, params.CenterHoleRadius);
    [x2, y2] = flatAngleToXY(angleDeg, params.Radius);
    plot(ax, [x1 x2], [y1 y2], ...
        'Color', params.GridColor, ...
        'LineWidth', params.LineWidth);
end

for angleDeg = params.LabelAngles
    [x, y] = flatAngleToXY(angleDeg, params.LabelRadius);
    text(ax, x, y, sprintf('%g', angleDeg), ...
        'Color', params.LabelColor, ...
        'FontSize', params.LabelFontSize, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end

patch(ax, params.CenterHoleRadius*cos(theta), params.CenterHoleRadius*sin(theta), ...
    params.BackgroundColor, ...
    'EdgeColor', params.GridColor, ...
    'LineWidth', params.LineWidth);
end

function drawWarpedDomeGrid(ax, params, coords)
% Match generateDome_MASM exactly: same azimuth/elevation range and grid size.
elevations = linspace(params.ElevationMax, params.ElevationMin, params.GridSize(1));
azimuths = linspace(params.AzimuthMin, params.AzimuthMax, params.GridSize(2));
[projGridE, projGridA] = meshgrid(elevations, azimuths);
[xGrid, yGrid] = projectAngleGrid(projGridE, projGridA, coords);

for rowIdx = 1:size(xGrid, 1)
    plot(ax, xGrid(rowIdx, :), yGrid(rowIdx, :), ...
        'Color', params.GridColor, ...
        'LineWidth', params.LineWidth);
end

for colIdx = 1:size(xGrid, 2)
    plot(ax, xGrid(:, colIdx), yGrid(:, colIdx), ...
        'Color', params.GridColor, ...
        'LineWidth', params.LineWidth);
end

if params.ShowGridPoints
    plot(ax, xGrid(:), yGrid(:), '.', ...
        'Color', params.PointColor, ...
        'MarkerSize', params.PointSize);
end

drawWarpedReferenceMarkers(ax, coords);
drawCalibrationCross(ax, params, coords);
end

function drawCalibrationCross(ax, params, coords)
if ~params.ShowCalibrationCross
    return;
end

azimuthSamples = linspace(params.AzimuthMin, params.AzimuthMax, params.CrossSamples);
elevationSamples = linspace(params.ElevationMax, params.ElevationMin, params.CrossSamples);

[x, y] = projectAngleSeries(params.HorizonElevation + zeros(size(azimuthSamples)), azimuthSamples, coords);
plot(ax, x, y, '-', ...
    'Color', params.HorizonColor, ...
    'LineWidth', params.CrossLineWidth, ...
    'Clipping', 'off');

[x, y] = projectAngleSeries(params.CenterHorizontalElevation + zeros(size(azimuthSamples)), azimuthSamples, coords);
plot(ax, x, y, '-', ...
    'Color', params.CenterHorizontalColor, ...
    'LineWidth', params.CrossLineWidth, ...
    'Clipping', 'off');

[x, y] = projectAngleSeries(elevationSamples, params.CenterVerticalAzimuth + zeros(size(elevationSamples)), coords);
plot(ax, x, y, '-', ...
    'Color', params.CenterVerticalColor, ...
    'LineWidth', params.CrossLineWidth, ...
    'Clipping', 'off');

for idx = 1:numel(params.ReferenceAzimuths)
    [x, y] = projectAngleSeries(elevationSamples, params.ReferenceAzimuths(idx) + zeros(size(elevationSamples)), coords);
    plot(ax, x, y, '-', ...
        'Color', params.ReferenceAzimuthColor, ...
        'LineWidth', params.CrossLineWidth, ...
        'Clipping', 'off');
end

for idx = 1:numel(params.SideVerticalAzimuths)
    [x, y] = projectAngleSeries(elevationSamples, params.SideVerticalAzimuths(idx) + zeros(size(elevationSamples)), coords);
    plot(ax, x, y, '-', ...
        'Color', params.SideVerticalColor, ...
        'LineWidth', params.SideVerticalLineWidth, ...
        'Clipping', 'off');
end
end

function drawWarpedReferenceMarkers(ax, coords)
displayEls = [0,-45,-90,-90, 0,-45, 0,-45, 0,-45, 0,-45];
displayAzs = [0, 0, 0,-90, -45,-45, 45,45, 90,90, -90,-90];

for idx = 1:numel(displayEls)
    [x, y] = projectAngleSeries(displayEls(idx), displayAzs(idx), coords);
    if ~isfinite(x) || ~isfinite(y)
        continue;
    end

    if displayEls(idx) == -90
        plot(ax, x, y, 'go', 'LineWidth', 5);
    elseif displayEls(idx) == -45
        plot(ax, x, y, 'yx', 'LineWidth', 5);
    else
        plot(ax, x, y, 'b+', 'LineWidth', 2);
    end
end
end

function [xGrid, yGrid] = projectAngleGrid(elevationDegGrid, azimuthDegGrid, coords)
xGrid = nan(size(elevationDegGrid));
yGrid = nan(size(elevationDegGrid));
for idx = 1:numel(elevationDegGrid)
    try
        [xGrid(idx), yGrid(idx)] = projectDomeAngleV2(deg2rad(elevationDegGrid(idx)), deg2rad(azimuthDegGrid(idx)), coords);
    catch
        xGrid(idx) = nan;
        yGrid(idx) = nan;
    end
end
end

function [x, y] = projectAngleSeries(elevationDeg, azimuthDeg, coords)
x = nan(size(elevationDeg));
y = nan(size(elevationDeg));
for idx = 1:numel(elevationDeg)
    try
        [x(idx), y(idx)] = projectDomeAngleV2(deg2rad(elevationDeg(idx)), deg2rad(azimuthDeg(idx)), coords);
    catch
        x(idx) = nan;
        y(idx) = nan;
    end
end
end

function [x, y] = projectDomeAngleV2(elevat, azim, coords)
radius = 1;

Rs = coords.screenRadius_;
xsm = coords.screenX_;
ysm = coords.screenY_;
zsm = coords.screenZ_;
r = coords.mirrorRadius_;
xOm = coords.mirrorX_;
yOm = coords.mirrorY_;
zOm = coords.mirrorZ_;
xP1m = coords.projectorX_;
yP1m = coords.projectorY_;
zP1m = coords.projectorZ_;
x0 = coords.x0_;
y0 = coords.y0_;
x1 = coords.x1_;
y1 = coords.y1_;
x2 = coords.x2_;
y2 = coords.y2_;

xOs = xOm - xsm;
yOs = yOm - ysm;
zOs = zOm - zsm;
xP1o = xP1m - xOm;
yP1o = yP1m - yOm;
zP1o = zP1m - zOm;

xVm = radius * cos(elevat) * cos(azim);
yVm = radius * cos(elevat) * sin(azim);
zVm = radius * sin(elevat);

a = xVm^2 + yVm^2 + zVm^2;
b = -2 * (xVm*xsm + yVm*ysm + zVm*zsm);
c = xsm^2 + ysm^2 + zsm^2 - Rs^2;
discriminant = b^2 - 4*a*c;
if discriminant < 0
    x = nan;
    y = nan;
    return;
end

t1 = (-b + sqrt(discriminant)) / (2*a);
t2 = (-b - sqrt(discriminant)) / (2*a);
if t1 >= 0
    t = t1;
elseif t2 > 0
    t = t2;
else
    x = nan;
    y = nan;
    return;
end

xP2m = xVm * t;
yP2m = yVm * t;
zP2m = zVm * t;

xP2s = xP2m - xsm;
yP2s = yP2m - ysm;
zP2s = zP2m - zsm;

xP2o = xP2s - xOs;
yP2o = yP2s - yOs;
zP2o = zP2s - zOs;

aab = sqrt(xP1o^2 + zP1o^2);
cospsi = xP1o / aab;
sinpsi = zP1o / aab;

xP2opsi = cospsi*xP2o + sinpsi*zP2o;
yP2opsi = yP2o;
zP2opsi = -sinpsi*xP2o + cospsi*zP2o;

aac = sqrt(zP2opsi^2 + yP2opsi^2);
sinalpha = yP2opsi / aac;
cosalpha = zP2opsi / aac;

P2x = xP2opsi;
P2y = cosalpha*yP2opsi - sinalpha*zP2opsi;
P2z = sinalpha*yP2opsi + cosalpha*zP2opsi;

xP1opsi = cospsi*xP1o + sinpsi*zP1o;
yP1opsi = yP1o;
zP1opsi = -sinpsi*xP1o + cospsi*zP1o;

P1x = xP1opsi;
P1y = cosalpha*yP1opsi - sinalpha*zP1opsi;
P1z = sinalpha*yP1opsi + cosalpha*zP1opsi;

P1norm = sqrt(P1x^2 + P1y^2 + P1z^2);
P2norm = sqrt(P2x^2 + P2y^2 + P2z^2);
P3x = P1x/P1norm + P2x/P2norm;
P3y = P1y/P1norm + P2y/P2norm;
P3z = P1z/P1norm + P2z/P2norm;
P3norm = sqrt(P3x^2 + P3y^2 + P3z^2);
YY = sqrt((P1y*P3z - P1z*P3y)^2 + (P1z*P3x - P1x*P3z)^2 + (P1x*P3y - P1y*P3x)^2);
XX = P1x*P3x + P1y*P3y + P1z*P3z;
sintheta = YY / (P1norm * P3norm);
costheta = XX / (P1norm * P3norm);

sinphi = r*sintheta / sqrt((r*sintheta)^2 + (P1x - r*costheta)^2);

verticPx = y0 * sinphi * cosalpha + y1;
horizPx = x0 * sinphi * sinalpha + x1;

x = horizPx - x2;
y = verticPx - y2;
end

function [x, y] = flatAngleToXY(angleDeg, radius)
angleRad = deg2rad(angleDeg);
x = radius * sin(angleRad);
y = -radius * cos(angleRad);
end

function movePatternToMonitor(hFig, monitorIndex)
monitorPositions = get(groot, 'MonitorPositions');
monitorIndex = min(max(1, monitorIndex), size(monitorPositions, 1));
set(hFig, 'Units', 'pixels');
set(hFig, 'OuterPosition', monitorPositions(monitorIndex, :));
end

function params = parsePatternInputs(varargin)
parser = inputParser;
parser.FunctionName = 'generateCalibrationPatternV2';

addParameter(parser, 'FigureHandle', [], @(value) isempty(value) || ishandle(value));
addParameter(parser, 'FullScreen', false, @(value) islogical(value) || isnumeric(value));
addParameter(parser, 'MonitorIndex', 1, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'CalibrationCoords', [], @(value) isempty(value) || isstruct(value));
addParameter(parser, 'Radius', 1, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'RingStep', 0.08, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'AngleStep', 10, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'ElevationStep', 10, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'AngleMin', -180, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'AngleMax', 180, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'AzimuthMin', -150, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'AzimuthMax', 150, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'ElevationMin', -90, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'ElevationMax', 0, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'LineSamples', 160, @(value) isnumeric(value) && isscalar(value) && value > 2);
addParameter(parser, 'GridSize', [34 34], @(value) isnumeric(value) && numel(value) == 2);
addParameter(parser, 'ShowGridPoints', false, @(value) islogical(value) || isnumeric(value));
addParameter(parser, 'PointColor', [1 0 0], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'PointSize', 8, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'ShowCalibrationCross', true, @(value) islogical(value) || isnumeric(value));
addParameter(parser, 'CrossSamples', 240, @(value) isnumeric(value) && isscalar(value) && value > 2);
addParameter(parser, 'CrossLineWidth', 4, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'CenterHorizontalElevation', -45, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'HorizonElevation', 0, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'CenterVerticalAzimuth', 0, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'ReferenceAzimuths', [-150 150], @isnumeric);
addParameter(parser, 'SideVerticalAzimuths', [-90 90], @isnumeric);
addParameter(parser, 'CenterHorizontalColor', [0 0.65 1], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'HorizonColor', [1 0 0.85], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'CenterVerticalColor', [0 1 0.55], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'SideVerticalColor', [0.25 1 0.75], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'SideVerticalLineWidth', 4.5, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'ReferenceAzimuthColor', [1 0 0.85], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'LabelAngles', [-90 -60 -40 -20 0 20 40 60 90], @isnumeric);
addParameter(parser, 'LabelElevation', -86, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'LabelRadius', 0.94, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'LabelFontSize', 10, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'CenterHoleRadius', 0.085, @(value) isnumeric(value) && isscalar(value) && value >= 0);
addParameter(parser, 'CenterHoleElevation', -86, @(value) isnumeric(value) && isscalar(value));
addParameter(parser, 'CircleResolution', 720, @(value) isnumeric(value) && isscalar(value) && value > 10);
addParameter(parser, 'BackgroundColor', [0 0 0], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'GridColor', [0.82 0.82 0.82], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'LabelColor', [0.95 0.95 0.95], @(value) isnumeric(value) && numel(value) == 3);
addParameter(parser, 'LineWidth', 0.75, @(value) isnumeric(value) && isscalar(value) && value > 0);
addParameter(parser, 'XLimits', [-1140/912 1140/912], @(value) isnumeric(value) && numel(value) == 2);
addParameter(parser, 'YLimits', [-1 1], @(value) isnumeric(value) && numel(value) == 2);

parse(parser, varargin{:});
params = parser.Results;
params.FullScreen = logical(params.FullScreen);
params.ShowGridPoints = logical(params.ShowGridPoints);
params.ShowCalibrationCross = logical(params.ShowCalibrationCross);
end
