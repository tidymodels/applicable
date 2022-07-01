# `score_apd_di_numeric` fails when model has no pcs argument

    Code
      score_apd_di_numeric(mtcars, mtcars)
    Error <rlang_error>
      `model` must be an `apd_di` object

# normal use

    Code
      score(aoa, test)
    Output
      # A tibble: 300 x 2
              di aoa  
           <dbl> <lgl>
       1 0.0230  TRUE 
       2 0.00907 TRUE 
       3 0.0126  TRUE 
       4 0.0121  TRUE 
       5 0.129   FALSE
       6 0.0261  TRUE 
       7 0.0154  TRUE 
       8 0.00707 TRUE 
       9 0.141   FALSE
      10 0.0159  TRUE 
      # ... with 290 more rows

---

    Code
      score(aoa, train)
    Output
      # A tibble: 700 x 2
            di aoa  
         <dbl> <lgl>
       1     0 TRUE 
       2     0 TRUE 
       3     0 TRUE 
       4     0 TRUE 
       5     0 TRUE 
       6     0 TRUE 
       7     0 TRUE 
       8     0 TRUE 
       9     0 TRUE 
      10     0 TRUE 
      # ... with 690 more rows

