# `score_apd_pca_numeric` fails when model has no pcs argument

    Code
      score_apd_pca_numeric(mtcars, mtcars)
    Condition
      Error in `score_apd_pca_numeric()`:
      ! The model must contain a pcs argument.

# `score` fails when predictors only contain factors

    Code
      score(model, iris$Species)
    Condition
      Error in `hardhat::forge()`:
      ! The class of `new_data`, 'factor', is not recognized.

# `score` fails when predictors are vectors

    Code
      score(object)
    Condition
      Error in `score()`:
      ! `object` is not of a recognized type.
      Only data.frame, matrix, recipe, and formula objects are allowed.
      A data.frame was specified.

