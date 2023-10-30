# XtX_inv is provided

    Code
      new_apd_hat_values(blueprint = hardhat::default_xy_blueprint())
    Error <simpleError>
      argument "XtX_inv" is missing, with no default

# `new_apd_hat_values` fails when blueprint is numeric

    Code
      new_apd_hat_values(XtX_inv = 1, blueprint = 1)
    Error <rlang_error>
      `blueprint` must be a <hardhat_blueprint>, not the number 1.

# `apd_hat_values` fails when matrix has more predictors than samples

    Code
      apd_hat_values(bad_data)
    Error <rlang_error>
      The number of columns must be less than the number of rows.

# `apd_hat_values` fails when the matrix X^tX is singular

    Code
      apd_hat_values(bad_data)
    Error <rlang_error>
      Unable to compute the hat values of the matrix X of
      predictors because the matrix resulting from multiplying
      the transpose of X by X is singular.

