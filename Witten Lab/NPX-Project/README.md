# Neuropixels 2.0 Implant Designs

This folder contains 3D-printable implant designs for Neuropixels 2.0 multi-shank probes. The designs were manufactured on a Formlabs Form 4BL SLA 3D printer using Precision material at a layer resolution of 0.05 mm.

The highest available printer resolution was not used intentionally. In practice, the relevant tolerances varied between Neuropixels probes and during post-processing of the printed parts. For this reason, 0.05 mm was selected as the standard manufacturing resolution for these components.

## Design Rationale

Unlike many implant models, this project prioritizes two goals at the same time: recovering the Neuropixels probe at the end of the study and maintaining a chronic implant configuration that preserves the repeatability of recordings from day to day.

This is especially important for double-probe implants. In many conventional double implants, both probes are fixed together. If one shank or probe fails at the end of an experiment, the bonded assembly can make it very difficult to reuse the unaffected probe. The designs in this folder propose a modular double-implant approach in which each Neuropixels probe has its own holder. If one probe or holder is damaged, the unaffected component can be recovered more easily.

## Folder Organization

The designs are organized into two main categories for Neuropixels 2.0 multi-shank probes:

- `Dovetail`: for probes with a metal cap.
- `No Dovetail`: for probes with a silicon cap.

## Dovetail Designs

The dovetail designs include both single-holder and double-holder configurations.

### Single Holder

The single-holder design allows the experimenter to secure and store the cable easily without requiring the headstage to be included in the implant. This holder is intentionally compact, reducing both the space occupied on the mouse's head and the overall implant weight.

### Double Holder

The double-holder design is intended to increase the number of recording sites within a defined brain area. The spacing between probes can also be adjusted depending on the needs of the experiment.

Current dovetail double-holder designs include the following distances between Neuropixels shanks:

- 2.5 mm
- 2.7 mm
- 2.9 mm
- 3.5 mm

For Neuropixels probes with a metal cap, 2.5 mm is currently the minimum shank-to-shank distance achieved with this design.

## No Dovetail Designs

The no-dovetail holder is intended for Neuropixels probes with a silicon cap. Under this configuration, the closest shank-to-shank spacing achieved so far is 1.5 mm.

