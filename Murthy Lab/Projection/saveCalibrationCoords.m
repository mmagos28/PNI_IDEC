function saveCalibrationCoords(coords, coordsPath)
%SAVECALIBRATIONCOORDS Save projection calibration values to coords.mat.
if nargin < 2 || isempty(coordsPath)
    coordsPath = getCalibrationCoordsPath();
end

save(coordsPath, '-struct', 'coords');
end