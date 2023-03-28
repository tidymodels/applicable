# pcs is provided

    Code
      new_apd_pca(blueprint = hardhat::default_xy_blueprint())
    Error <simpleError>
      argument "pcs" is missing, with no default

# `new_apd_pca` fails when blueprint is numeric

    Code
      new_apd_pca(pcs = 1, blueprint = 1)
    Error <rlang_error>
      blueprint should be a blueprint, not a numeric.

# `apd_pca` is not defined for vectors

    Code
      apd_pca(mtcars$mpg)
    Error <rlang_error>
      `x` is not of a recognized type.
      i
      Only data.frame, matrix, recipe, and formula objects are allowed.
      i
      A numeric was specified.

