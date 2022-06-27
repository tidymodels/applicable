# training is provided

    Code
      new_apd_aoa(blueprint = hardhat::default_xy_blueprint())
    Error <simpleError>
      argument "training" is missing, with no default

# `new_apd_aoa` fails when blueprint is numeric

    Code
      new_apd_aoa(oranges, blueprint = 1)
    Error <rlang_error>
      blueprint should be a blueprint, not a numeric.

