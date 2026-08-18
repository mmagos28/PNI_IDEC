function handles = applyCalibrationCoordsToHandles(handles, coords)
%APPLYCALIBRATIONCOORDSTOHANDLES Put saved calibration values into the GUI.
fieldNames = getCalibrationFieldNames();

for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    coordName = [fieldName '_'];

    if isfield(handles, fieldName) && ishandle(handles.(fieldName)) && isfield(coords, coordName)
        set(handles.(fieldName), 'String', num2str(coords.(coordName), 15));
    end
end
end