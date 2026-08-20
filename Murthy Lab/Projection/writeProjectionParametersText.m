function txtPath = writeProjectionParametersText(coords, txtPath)
%WRITEPROJECTIONPARAMETERSTEXT Export calibration values as MATLAB parameter code.
if nargin < 2 || isempty(txtPath)
    txtPath = fullfile(fileparts(mfilename('fullpath')), 'projection_parameters.txt');
end

projectorRelativeX = coords.projectorX_ - coords.mirrorX_;
projectorRelativeY = coords.projectorY_ - coords.mirrorY_;
projectorRelativeZ = coords.projectorZ_ - coords.mirrorZ_;
horizontalShift = coords.x1_ - coords.x2_;
verticalShift = coords.y1_ - coords.y2_;

fid = fopen(txtPath, 'w');
if fid == -1
    error('writeProjectionParametersText:OpenFailed', ...
        'Could not open projection parameter text file: %s', txtPath);
end
cleanupObj = onCleanup(@() fclose(fid));

fprintf(fid, '%%%% Mini VR projection parameters\n');
fprintf(fid, '%% Spherical screen radius\n');
fprintf(fid, 'proj_param_Rs           =   %s;\n\n', formatProjectionValue(coords.screenRadius_));

fprintf(fid, '%% Screen''s center location relative to the animal eyes\n');
fprintf(fid, 'proj_param_xsm          =   %s;\n', formatProjectionValue(coords.screenX_));
fprintf(fid, 'proj_param_ysm          =   %s;\n', formatProjectionValue(coords.screenY_));
fprintf(fid, 'proj_param_zsm          =   %s;\n\n', formatProjectionValue(coords.screenZ_));

fprintf(fid, '%% Mirror position relative to the animal eyes\n');
fprintf(fid, '%% Mirror position measurement is facilitated knowing that the center of \n');
fprintf(fid, '%% spherical mirror is (43.8-24.2=)19.6mm (0.77in) behind the back surface.\n');
fprintf(fid, 'proj_param_xOm          =   %s;\n', formatProjectionValue(coords.mirrorX_));
fprintf(fid, 'proj_param_yOm          =   %s;\n', formatProjectionValue(coords.mirrorY_));
fprintf(fid, 'proj_param_zOm          =   %s;\n\n', formatProjectionValue(coords.mirrorZ_));

fprintf(fid, '%% Radius of the spherical mirror (Silver coated lens LA1740-Thorlabs)\n');
fprintf(fid, 'proj_param_r            =   %s;\n\n', formatProjectionValue(coords.mirrorRadius_));

fprintf(fid, '%% Projector position relative to the mirror center\n');
fprintf(fid, 'proj_param_xP1o         =   %s;\n', formatProjectionValue(projectorRelativeX));
fprintf(fid, 'proj_param_yP1o         =   %s;\n', formatProjectionValue(projectorRelativeY));
fprintf(fid, 'proj_param_zP1o         =   %s;\n\n', formatProjectionValue(projectorRelativeZ));

fprintf(fid, '%% Horizontal coordinate shift and rescaling\n');
fprintf(fid, 'proj_param_hrescaling   =   %s;\n', formatProjectionValue(coords.x0_));
fprintf(fid, 'proj_param_hshift       =   %s;\n\n', formatProjectionValue(horizontalShift));

fprintf(fid, '%% Vertical coordinate shift and rescaling\n');
fprintf(fid, 'proj_param_vrescaling   =   %s;\n', formatProjectionValue(coords.y0_));
fprintf(fid, 'proj_param_vshift       =   %s;\n', formatProjectionValue(verticalShift));
end

function valueText = formatProjectionValue(value)
valueText = sprintf('%.6f', value);
valueText = regexprep(valueText, '0+$', '');
valueText = regexprep(valueText, '\.$', '');
if isempty(valueText) || strcmp(valueText, '-0')
    valueText = '0';
end
end
