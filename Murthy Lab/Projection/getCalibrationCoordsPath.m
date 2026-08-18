function coordsPath = getCalibrationCoordsPath()
%GETCALIBRATIONCOORDSPATH Location of the saved projection calibration values.
coordsPath = fullfile(fileparts(mfilename('fullpath')), 'coords.mat');
end