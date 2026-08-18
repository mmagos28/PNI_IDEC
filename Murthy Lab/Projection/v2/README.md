# Projection Calibration Pattern V2

This folder contains a standalone MATLAB prototype for generating a visual dome-style calibration grid entirely from code. It does not replace the current `ConfigureProjectorOnline` workflow or the `calibratedBallImage.data` generation process.

## Files

- `generateCalibrationPatternV2.m`: function that draws the polar grid pattern.
- `showCalibrationPatternV2.m`: simple script that opens the pattern full-screen.

## Basic Use

From MATLAB, run:

```matlab
cd('C:\Users\ms2910\OneDrive - Princeton University\Documents\GitHub\IDEC\PNI_IDEC\Murthy Lab\Projection\v2')
showCalibrationPatternV2
```

To send it to another monitor/projector, change `MonitorIndex` in `showCalibrationPatternV2.m`.

## Adjustable Parameters

The pattern is generated with rings, radial lines, labels, and a center mask. Useful parameters include:

```matlab
generateCalibrationPatternV2( ...
    'FullScreen', true, ...
    'MonitorIndex', 2, ...
    'RingStep', 0.08, ...
    'AngleStep', 10, ...
    'CenterHoleRadius', 0.085);
```

- `RingStep`: spacing between circular rings.
- `AngleStep`: angular spacing between radial lines.
- `MonitorIndex`: monitor/projector target.
- `CenterHoleRadius`: radius of the black center opening.

## Notes

This version is meant to make visual calibration easier before modifying the current projection pipeline. Once the visual pattern is useful, the same drawing logic can be connected to `ConfigureProjectorOnline` as a selectable calibration mode.
