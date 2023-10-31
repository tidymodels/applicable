# pcs is provided

    Code
      new_apd_pca(blueprint = hardhat::default_xy_blueprint())
    Condition
      Error in `new_apd_pca()`:
      ! argument "pcs" is missing, with no default

# `new_apd_pca` fails when blueprint is numeric

    Code
      new_apd_pca(pcs = 1, blueprint = 1)
    Condition
      Error in `hardhat::new_model()`:
      ! `blueprint` must be a <hardhat_blueprint>, not the number 1.

