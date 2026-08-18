function stepSize = getCalibrationStepSize(fieldName)
%GETCALIBRATIONSTEPSIZE Increment used by the online calibration +/- buttons.
switch fieldName
    case {'x0','y0','x1','y1','x2','y2'}
        stepSize = 0.01;
    otherwise
        stepSize = 0.1;
end
end