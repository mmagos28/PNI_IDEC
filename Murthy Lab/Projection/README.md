# Projection Calibration Code

This folder contains MATLAB code for calibrating the dome projection system. The main workflow is controlled from `ConfigureProjectorOnline.m`, which lets the user enter the physical measurements of the system, update calibration parameters, preview the projection geometry, and generate the `calibratedBallImage.data` file used by the projection pipeline.

## Main Files

- `ConfigureProjectorOnline.m`: main calibration GUI. This is the recommended entry point.
- `generateDome_MASM.m`: computes the dome/mirror/projector geometry and writes `calibratedBallImage.data`.
- `coords.mat`: stores the current calibration coordinates used by the GUI.
- `calibratedBallImage.data`: generated calibration map.
- `v2/generateCalibrationPatternV2.m`: visual grid helper used as an auxiliary calibration view.

## Basic Workflow

1. Measure the original physical geometry of the projection system.

   Measure the screen, mirror, and projector positions as carefully as possible. The calibration depends on these values, so the initial geometry should be based on the real system rather than guessed values.

2. Open the calibration GUI in MATLAB.

   ```matlab
   cd('C:\Users\ms2910\OneDrive - Princeton University\Documents\GitHub\IDEC\PNI_IDEC\Murthy Lab\Projection')
   ConfigureProjectorOnline
   ```

3. Enter the measured values in the corresponding fields.

   The main coordinate groups are:

   - `screenRadius`, `screenX`, `screenY`, `screenZ`
   - `mirrorRadius`, `mirrorX`, `mirrorY`, `mirrorZ`
   - `projectorX`, `projectorY`, `projectorZ`
   - `x0`, `y0`, `x1`, `y1`, `x2`, `y2`

   The screen, mirror, and projector values describe the physical layout. The `x0/y0`, `x1/y1`, and `x2/y2` values are used to scale and shift the projected coordinates during calibration.

4. Regenerate the projection.

   Press the regenerate button in the GUI. In the normal dome mode, the code calls `generateDome_MASM.m`, updates the projection figure, and writes `calibratedBallImage.data`.

5. Save the coordinates.

   Use the save option in the GUI after the system is aligned. The values are stored in `coords.mat` and loaded again the next time the GUI is opened.

## Visual Grid Mode

`ConfigureProjectorOnline.m` includes a `Visual grid` checkbox. This mode is intended as an auxiliary calibration view.

- When `Visual grid` is off, the GUI uses the normal dome calibration workflow and generates `calibratedBallImage.data`.
- When `Visual grid` is on, the GUI draws a polar azimuth/elevation grid using the same dome/mirror/projector geometry. This makes it easier to see how changes in the calibration parameters affect the projected image.

The visual grid is not a replacement for the final calibration file. It is a reference pattern to help align the system before returning to the normal dome mode and generating the final `calibratedBallImage.data`.

## Notes

- Start with accurate physical measurements, then use the GUI controls for fine adjustment.
- If the displayed projection does not update after code changes, clear MATLAB's cached functions:

  ```matlab
  close all force
  clear ConfigureProjectorOnline generateDome_MASM generateCalibrationPatternV2
  rehash toolboxcache
  ConfigureProjectorOnline
  ```

- `visualizeCalibratedBallImage.m` is kept as a manual debugging tool, but it is no longer opened automatically during calibration.
