# Changelog

## applicable 0.2.1

CRAN release: 2026-02-24

- Improved
  [`autoplot.apd_pca()`](https://applicable.tidymodels.org/reference/autoplot.apd_pca.md)
  selector handling to fail early with a clear error when `...`
  selectors match no columns.
- Modernized package code, tests, and vignettes to use base R pipes
  (`|>`) and replaced superseded tidyverse helpers (`pivot_longer()`,
  [`across()`](https://dplyr.tidyverse.org/reference/across.html), and
  [`rename_with()`](https://dplyr.tidyverse.org/reference/rename.html)).
- Updated tests to use stricter modern expectations, including replacing
  success-path `expect_error(..., regexp = NA)` checks with
  `expect_no_error()`.
- Expanded isolation-method maintenance and coverage work, including
  formula-interface checks, `check_isotree()` test paths, and refreshed
  isolation `.Rd` documentation.
- Added a helper script (`scripts/test-changed-functions.R`) to report
  changed functions, check test references, run testthat, and run `covr`
  coverage for changed code.
- Improved CRAN/release readiness with additional housekeeping: build
  ignore updates for `scripts/`, version/roxygen metadata maintenance,
  link/DOI and vignette compliance fixes, plus spelling/WORDLIST
  updates.
- Included prior plotting/printing refinements: PCA plot sizing/faceting
  and print-method formatting cleanups.
- Updated Quarto vignette chunk options to in-body YAML style and bumped
  package version in `DESCRIPTION` to `0.2.1`.
- Switched Ames dataset documentation links from `http` to `https` in
  source, vignette text, and generated `.Rd` docs.
- Refreshed website/project assets and configuration files (including
  favicon assets and editor/project config updates).

## applicable 0.1.1

CRAN release: 2024-04-24

- Changes in \[apd_isolation()\] because \[isotree::isolation.forest()\]
  changed their default for the number of dimensions to 1.

- Updated snapshot unit tests that changed from rlang’s changes related
  to the call/traceback.

## applicable 0.1.0

CRAN release: 2022-08-20

Added isolation forest methods via the isotree package in the function
[`apd_isolation()`](https://applicable.tidymodels.org/reference/apd_isolation.md).

## applicable 0.0.1.1

CRAN release: 2020-06-15

Minor patch release: fixed failing units tests due to recent package
updates.

## applicable 0.0.1

CRAN release: 2020-05-25

- First CRAN version.
