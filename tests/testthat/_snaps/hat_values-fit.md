# XtX_inv is provided

    Code
      new_apd_hat_values(blueprint = hardhat::default_xy_blueprint())
    Error <simpleError>
      argument "XtX_inv" is missing, with no default

# `new_apd_hat_values` fails when blueprint is numeric

    Code
      new_apd_hat_values(XtX_inv = 1, blueprint = 1)
    Error <rlang_error>
      blueprint should be a blueprint, not a numeric.

# `apd_hat_values` is not defined for vectors

    Code
      apd_hat_values(mtcars$mpg)
    Error <rlang_error>
      `x` is not of a recognized type.
      i
      Only data.frame, matrix, recipe, and formula objects are allowed.
      i
      A numeric was specified.

# `apd_hat_values` fails when matrix has more predictors than samples

    Code
      apd_hat_values(bad_data)
    Error <rlang_error>
      The number of columns must be less than number of rows.

# `apd_hat_values` fails when the matrix X^tX is singular

    Code
      apd_hat_values(bad_data)
    Error <rlang_error>
      Unable to compute the hat values of the matrix X.
      i
      Singular matrix results from multiplying transpose of X by X.

