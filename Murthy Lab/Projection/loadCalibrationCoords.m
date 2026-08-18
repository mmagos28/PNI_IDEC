function coords = loadCalibrationCoords(coordsPath)
%LOADCALIBRATIONCOORDS Load saved projection calibration values.
if nargin < 1 || isempty(coordsPath)
    coordsPath = getCalibrationCoordsPath();
end

if ~exist(coordsPath, 'file') && exist('coords.mat', 'file')
    coordsPath = 'coords.mat';
end

if ~exist(coordsPath, 'file')
    coords = struct();
    return;
end

coords = load(coordsPath);
end