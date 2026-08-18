# Lumbosacral spinal cord fMRI during transcutaneous tibial nerve stimulation

Analysis pipeline for the study *"Functional magnetic resonance imaging of the lumbosacral
spinal cord during transcutaneous tibial nerve stimulation: feasibility and test-retest
reliability"* (Kündig et al.). The pipeline takes raw DICOMs of lumbosacral spinal cord fMRI
acquired during transcutaneous tibial nerve stimulation (TTNS) and produces group-level
activation maps, together with the run-duration, sample-size and test-retest reliability
analyses reported in the paper.

The pipeline is a set of hand-run modules `m00 … m98`. Modules run in numeric order and are
driven by `m00_PipMaster`, which is **edited per subject and session** rather than
parameterised on the command line.

## Table of content
* [1. Dependencies](#1-dependencies)
* [2. Data organisation](#2-data-organisation)
* [3. Preprocessing](#3-preprocessing)
* [4. Segmentation and physiological noise](#4-segmentation-and-physiological-noise)
* [5. Registration to template](#5-registration-to-template)
* [6. First-, subject- and group-level GLM](#6-first-subject-and-group-level-glm)
* [7. Reliability, run-duration and sample-size analyses](#7-reliability-run-duration-and-sample-size-analyses)
* [8. How to cite](#8-how-to-cite)

## 1. Dependencies

* SCT 6.5 (De Leener et al., 2017)
* FSL 6.0.7.16 (FEAT, randomise, fsl_motion_outliers)
* JIM 9.0 (Xinapse Systems) for manual spinal cord and CSF segmentation
* MATLAB R2024b, with the PhysIO toolbox (aCompCor) and SPM for smoothing
* R 4.3.3, packages `irr` (Kendall's W, ICC) and `emmeans` (ANOVA post-hoc)
* dcm2niix for DICOM conversion

## 2. Data organisation

The NIfTI-converted data follow the BIDS format. Each participant has two sessions approximately one week apart:

```
02_BIDS/
├── sub-ltrNN/
   ├── ses-01/  and  ses-02/
   │   ├── anat/   ME-GRE (6 measurements x 5 echoes), sagittal T2w
   │   └── func/   1 resting-state run + 4 task runs (TTNS)
03_Processing/   all pipeline outputs and manual segmentations
   ├── ses-01/  and  ses-02/
```

Acquisition, for reference. Functional: T2*-weighted inner-field-of-view single-shot GE-EPI
(ZOOMit), TE 42 ms, TR 1400 ms, 15 axial-oblique slices of 5 mm, 1 x 1 mm in plane, 429
volumes, 10:06 min per run. Structural reference: 3D multi-echo gradient-echo (ME-GRE), 20
slices of 5 mm, 0.5 x 0.5 mm, 5 echoes. Stimulation: right tibial nerve at 3.1 Hz, 200 us
pulse width, 5 mA above motor threshold, block design of 15 s rest and 15 s stimulation,
20 blocks per run.

## 3. Pipeline execution

The pipeline is organized as a set of modules (m00-m98). The order and selection of modules are controlled through m00_PipMaster.m, which serves as the main pipeline script. Before execution, the script must be configured with the appropriate participant, session, directory, and analysis settings. Depending on the chosen configuration, processing can be performed for individual participants, sessions, or groups of participants.

Modules are generally executed in numerical order.

m02_convert
m03_sorting
m04_anat_preproc
m05_cropping
m06_2_motioncorrection
...
m16_stat_trafo

Subsequent group-level analyses are performed using:

m21_I_fslrandomise_grplvl_perm
m22_fslrandomise_difference

Methodological analyses (reliability, run-duration, sample-size, Dice coefficient, etc.) are implemented in the scripts described in Section 8.

The repository includes data from one representative participant to facilitate testing and validation of the workflow. The shared dataset contains raw BIDS-formatted NIfTI data, manual segmentations, and outputs from intermediate processing steps, allowing users to verify results throughout the analysis pipeline. Prior to execution, users should review and configure the participant, session, directory, and analysis settings in m00_PipMaster.m according to their dataset and intended analysis.
``
## 4. Preprocessing

| step | module | does |
|---|---|---|
| convert | `m02_convert`, `m03_sorting` | DICOM to NIfTI, sort series into runs (functional) and echoes (structural) |
| structural | `m04_anat_preproc`, `m05_cropping` | root-mean-square echo combination, average measurements, crop to 97 x 97 |
| motion correction | `m06_2_motioncorrection` | two-step: volume-wise MCFLIRT, then slice-wise `sct_fmri_moco` with a 15 mm cylindrical cord mask |

Motion correction is run on the concatenated rest-plus-task series so that both within-run
and between-run displacements are corrected, then split back into runs. Volume outliers are
flagged with `fsl_motion_outliers` (DVARS, box-plot threshold) inside `m12_regressors`.

## 5. Segmentation and physiological noise

| step | module | does |
|---|---|---|
| cord and CSF | `m07_2_segmentation_I/II/III` | import manual JIM masks of the ME-GRE and the mean EPI, binarise at 50%, propagate to each run |
| tSNR | `m08_tsnr` | temporal signal-to-noise on the detrended resting-state run |
| confounds | `m11_aCompCor`, `m12_regressors` | five aCompCor principal components from the CSF ROI (PhysIO), plus eight motion parameters and volume outliers |

The cord and CSF are segmented manually in JIM because automatic segmentation is less
reliable in the lumbosacral cord. The anatomical mask is realigned to the EPI before use.

## 6. Registration to template

| step | module | does |
|---|---|---|
| EPI to ME-GRE | `m09_registration` | `sct_register_multimodal`, slice-wise, centermass then BSplineSyn registration |
| ME-GRE to PAM50 | `m09_registration_PAM50.m` | `sct_register_to_template`, two-label normalization |

Normalization uses two landmarks: the tip of the spinal cord (aligned to PAM50 label 60) and
the lumbosacral enlargement, the slice of largest cord cross-sectional area (a manually added
label 59, at PAM50 slice 143, the caudal end of segment L3 per Frostell et al., 2016). The
forward warp carries statistics into PAM50 for the group analysis; the backward warp carries
spinal-cord segment definitions back into EPI space for the BOLD signal-change calculation.

## 7. First-, subject- and group-level GLM

| step | module | does |
|---|---|---|
| smoothing | `m13_smooth` | anisotropic 2 x 2 x 5 mm FWHM Gaussian smoothing |
| first level | `m14_fslfeat_{6,8,10}min` | run-level GLM using FSL FEAT |
| subject level | `m15_fslfeat_sublvl_{2,3,4}run_*` | fixed-effects combination across runs |
| to template | `m16_stat_trafo` | warp COPEs and z-statistics into PAM50 space |
| group | `m21_I_fslrandomise_grplvl_perm` | one-sample permutation test |
| session difference | `m22_fslrandomise_difference` | paired test, session 2 vs session 1 |

The run-level design convolves a boxcar of the stimulation blocks with FSL's canonical
**double-gamma HRF and its temporal derivative** (`convolve1=3`, `deriv_yn1=1`). The temporal derivative accounts for latency differences,
while the contrast includes only the canonical HRF regressor.
Nuisance regressors are eight motion parameters (six volume-wise and two slice-wise), volume outliers, and the five CSF principal
components (slice-wise). High-pass filtering uses a 100 s cutoff, with FILM
prewhitening. The group analysis is a sign-flip permutation test in `randomise` (4096
permutations, variance smoothing of 2 mm), with threshold-free cluster enhancement (TFCE) and
family-wise-error correction at p < 0.05 and p < 0.01.

> **Note on the committed designs.** The `m14`/`m15` `.fsf` files in this repository must be
> the canonical-HRF version (`convolve1=3`, `deriv_yn1=1`, `evs_real=2` at run level;
> `ncopeinputs=1` at subject level) to match the paper. An earlier FLOBS variant
> (`convolve1=7`, three basis functions) is superseded.

## 8. Reliability, run-duration and sample-size analyses

The methodological analyses that are the focus of the paper are implemented through separate, analysis-specific scripts:

| analysis | script |
|---|---|
| run-, subject-, session-level summaries | `m82_analysis_run.m`, `m82_analysis_sub.m`, `m82_analysis_ses.m` |
| within-run (first vs second half) | `m82_analysis_run_half.m` |
| BOLD signal change, Z-statistics, effect size | `m88_effect_size.m`, `m89_tvalue.m`, `m84_outlvseffsiz.m` |
| Dice overlap between TFCE maps | `m83_dicecoefficient.m`, `m98_dice_calculator` |
| test-retest ICC (motor threshold, Z-statistic, effect size) | `m88_motorthreshold_ICC.R`, `m88_tvalue_ICC.R`, `m88_effect_size_ICC.R` |
| sample-size (Monte-Carlo subsets) | `m21_I_permutations.m` |
| registration quality | `m30_registration_quality.m` |
| spinal-level and axial masks | `m90_neuro_segm`, `m90_axial_segm`, `m91_grplvl_masks` |

Consistency across runs and sessions is quantified with Kendall's coefficient of concordance;
between-session agreement of motor threshold, tSNR and outlier counts with the absolute-agreement
single-measure ICC(3,1); both via the R `irr` package. Within- and between-session differences in
BOLD signal change and mean Z-statistics use a two-way repeated-measures ANOVA with Tukey correction
(`emmeans`).

## 9. How to cite

If you use this pipeline, please cite Kündig et al. (paper reference to be added on publication).
The pipeline derives from LufMRI-pip (https://doi.org/10.1162/imag_a_00227).
