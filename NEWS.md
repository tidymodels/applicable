# applicable (development version)

- Modernized package code and examples to use base R pipes (`|>`) and updated deprecated tidyverse helpers (`gather()`, `mutate_all()`, and `rename_all()`).
- Updated tests to use stricter modern expectations, including replacing success-path `expect_error(..., regexp = NA)` checks with `expect_no_error()`.
- Added and used a changed-function test/coverage helper workflow during maintenance, and refreshed isolation method documentation.

# applicable 0.1.1


- Changes in [apd_isolation()] because [isotree::isolation.forest()] changed their default for the number of dimensions to 1. 

- Updated snapshot unit tests that changed from rlang's changes related to the call/traceback. 

# applicable 0.1.0


Added isolation forest methods via the isotree package in the function `apd_isolation()`.

# applicable 0.0.1.1


Minor patch release: fixed failing units tests due to recent package updates.

# applicable 0.0.1


* First CRAN version.
