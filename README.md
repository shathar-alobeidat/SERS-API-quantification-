
# Colloidal SERS quantification of pharmaceuticals in wastewater

R scripts for the calibration, validation and chemometric analyses on
colloidal SERS quantification of compounds in complex matrices.
## Scripts (in `R/`)

| Script | Purpose |
|--------|---------|
| `Data importing and Preprocessing Pipeline.R` | Imports BWTek spectra, reads metadata from the file names, applies LOESS smoothing and ALS baseline correction, with optional vector normalisation. Defines the import function used by the other scripts. |
| `Ordinary Least Squares (OLS) calibration` | unweighted OLS calibration, figures of merit (LOD, LOQ, recovery, %RE, %RSD), and independent validation at the PNEC. |
| `Weighted Least Squares (WLS) Calibration` |  weighted least squares calibration , figures of merit, and independent validation at the  PNEC. |
| `PLSR model and unknown predictions` | PLS regression model in mixtures, with cross-validation, permutation test, and prediction of unknown samples (recovery and confidence intervals). |
| `Classic Least Squares model and predictions` | Classical least squares (CLS) decomposition of mixture spectra into pure-component contributions, and the resulting predictions. and net analyte signal (NAS) check |
| `Unknown mixtures predictions` | Quantification of the unknown mixture samples with OLS, WLS, with and without the internal standard. |

## Requirements

R with the packages `hyperSpec`, `baseline`, `readr`, `pls`, `chemCal`, `dplyr` and `lmtest`:

```r
install.packages(c("hyperSpec", "baseline", "readr", "pls", "chemCal", "dplyr", "lmtest"))
```

## Usage

1. Run the import and preprocessing script first, since the other scripts reuse its
   `scan.txt.BWtek` import function.
2. Set the working directory to the folder containing the spectra (`.txt` files).
3. Edit the folder paths at the top of each script (for example `val_dir` and `setwd(...)`)
   to point at your own data.
4. Run the calibration or prediction script for the analyte of interest.

## File naming

Spectra file names encode the metadata, separated by `_`: spectrometer, replicate, method,
substrate, NP concentration, ratio, laser power, integration time, accumulations, API,
concentration, solvent, PBS, pH, date, salt and salt concentration. (The concentration is
field 11, while the API name is field 10, usually)

## Data

Raw spectra are not included in this repository.
