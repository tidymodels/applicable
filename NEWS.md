# applicable (development version)

- Modernized package code, tests, and vignettes to use base R pipes (`|>`) and replaced superseded tidyverse helpers (`pivot_longer()`, `across()`, and `rename_with()`).
- Updated tests to use stricter modern expectations, including replacing success-path `expect_error(..., regexp = NA)` checks with `expect_no_error()`.
- Expanded isolation-method maintenance and coverage work, including formula-interface checks, `check_isotree()` test paths, and refreshed isolation `.Rd` documentation.
- Added a helper script (`scripts/test-changed-functions.R`) to report changed functions, check test references, run testthat, and run `covr` coverage for changed code.
- Improved CRAN/release readiness with additional housekeeping: build ignore updates for `scripts/`, version/roxygen metadata maintenance, link/DOI and vignette compliance fixes, plus spelling/WORDLIST updates.
- Included prior plotting/printing refinements: PCA plot sizing/faceting and print-method formatting cleanups.

# applicable 0.1.1


- Changes in [apd_isolation()] because [isotree::isolation.forest()] changed their default for the number of dimensions to 1. 

- Updated snapshot unit tests that changed from rlang's changes related to the call/traceback. 

# applicable 0.1.0


Added isolation forest methods via the isotree package in the function `apd_isolation()`.

# applicable 0.0.1.1


Minor patch release: fixed failing units tests due to recent package updates.

# applicable 0.0.1


* First CRAN version.
