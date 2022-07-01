# training is provided

    Code
      new_apd_di(blueprint = hardhat::default_xy_blueprint())
    Error <simpleError>
      argument "training" is missing, with no default

# `new_apd_di` fails when blueprint is numeric

    Code
      new_apd_di(oranges, blueprint = 1)
    Error <rlang_error>
      blueprint should be a blueprint, not a numeric.

