# `score_apd_hat_values_numeric` fails when model has no pcs argument

    Code
      score_apd_hat_values_numeric(mtcars, mtcars)
    Error <rlang_error>
      The model must contain an XtX_inv argument.

# `score` fails when predictors only contain factors

    Code
      score(model, iris$Species)
    Error <rlang_error>
      The class of `new_data`, 'factor', is not recognized.

# `score` fails when predictors are vectors

    Code
      score(object)
    Error <rlang_error>
      `object` is not of a recognized type.
      Only data.frame, matrix, recipe, and formula objects are allowed.
      A data.frame was specified.

