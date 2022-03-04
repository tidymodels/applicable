## R CMD check results

0 errors | 0 warnings | 0 note

## 0.0.1.1 Submission

This release fixes failing unit tests.

### Review - 2020-06-14

Fix the following unit tests:

  >
  ── 1. Failure: `score_apd_pca_numeric` pcs output matches `stats::predict` output
  `actual_output` not equivalent to `expected`.
  current is not list-like
  > 
  ── 2. Failure: `score` pcs output matches `stats::predict` output
  `actual_output` not equivalent to `expected`.
  current is not list-like
  >
  ── 3. Failure: `score_apd_pca_bridge` output is correct
  `actual_output` not equivalent to `expected`.
  current is not list-like
