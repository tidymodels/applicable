#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom dplyr %>%
#' @importFrom dplyr select
#' @importFrom dplyr slice
#' @importFrom dplyr matches
#' @importFrom dplyr starts_with
#' @importFrom dplyr rename_all
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_all
#' @importFrom dplyr group_by
#' @importFrom dplyr ungroup
#' @importFrom dplyr count
#' @importFrom dplyr sample_n
#' @importFrom glue glue
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom purrr map_dfc
#' @importFrom purrr map2_dfc
#' @importFrom rlang abort
#' @importFrom rlang enquos
#' @importFrom rlang arg_match
#' @importFrom stats predict
#' @importFrom stats prcomp
#' @importFrom stats approx
#' @importFrom stats quantile
#' @importFrom stats ecdf
#' @importFrom stats setNames
#' @importFrom hardhat validate_prediction_size
#' @importFrom hardhat forge
#' @importFrom hardhat mold
#' @importFrom hardhat new_model
#' @importFrom ggplot2 ggplot geom_step xlab ylab aes autoplot
#' @importFrom Matrix Matrix colSums
#' @importFrom tidyselect vars_select
#' @importFrom tidyr gather
#' @importFrom proxyC simil

# ------------------------------------------------------------------------------
# nocov

# Reduce false positives when R CMD check runs its "no visible binding for
# global variable" check
#' @importFrom utils globalVariables
utils::globalVariables(
  c("cumulative", "n", "sim", "percentile", "component", "value")
)

# nocov end
## usethis namespace: end
NULL
