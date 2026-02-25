# `score_apd_hat_values_numeric` fails when model has no pcs argument

    Code
      score_apd_hat_values_numeric(mtcars, mtcars)
    Condition
      Error in `score_apd_hat_values_numeric()`:
      ! The model must contain an XtX_inv argument.

# `score` fails when predictors only contain factors

    Code
      score(model, iris$Species)
    Condition
      Error in `hardhat::forge()`:
      ! No `forge()` method provided for a <factor> object.

# `score` fails when predictors are vectors

    Code
      score(object)
    Condition
      Error in `score()`:
      ! `object` is not of a recognized type.
      Only data.frame, matrix, recipe, and formula objects are allowed.
      A data.frame was specified.

