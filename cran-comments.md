
## Test environments
* local OS X install, R 3.6.3
* ubuntu 16.04, macOS, win-builder (on GitHub Actions), R 3.6, 3.5, 3.4, 3.3

## R CMD check results

0 errors | 0 warnings | 0 note

* This is a new release.

## 0.0.1 Submission

### Review - 2020-05-13

> Please always make sure to reset to user's options(), working directory 
or par() after you changed it in examples and vignettes and demos.
e.g.: vignette
old <- options(width = 100)
...
options(old)

On the continuous-data.Rmd vignette, reset the custom width. 
