function coords = readCalibrationCoordsFromHandles(handles)
%READCALIBRATIONCOORDSFROMHANDLES Read numeric calibration values from the GUI.
fieldNames = getCalibrationFieldNames();
coords = struct();

for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    coordName = [fieldName '_'];

    if ~isfield(handles, fieldName) || ~ishandle(handles.(fieldName))
        error('readCalibrationCoordsFromHandles:MissingField', ...
            'Missing calibration GUI field: %s', fieldName);
    end

    valueText = strtrim(get(handles.(fieldName), 'String'));
    value = str2double(valueText);
    if isnan(value)
        error('readCalibrationCoordsFromHandles:InvalidValue', ...
            'Calibration field %s must be numeric. Current value: "%s"', ...
            fieldName, valueText);
    end

    coords.(coordName) = value;
end
end