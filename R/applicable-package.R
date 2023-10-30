#' @keywords internal
"_PACKAGE"

## usethis namespace: start

#' @import rlang
#' @importFrom dplyr %>%
#' @importFrom dplyr count
#' @importFrom dplyr group_by
#' @importFrom dplyr matches
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_all
#' @importFrom dplyr rename_all
#' @importFrom dplyr sample_n
#' @importFrom dplyr select
#' @importFrom dplyr slice
#' @importFrom dplyr starts_with
#' @importFrom dplyr ungroup
#' @importFrom ggplot2 ggplot geom_step xlab ylab aes autoplot
#' @importFrom glue glue
#' @importFrom hardhat forge
#' @importFrom hardhat mold
#' @importFrom hardhat new_model
#' @importFrom hardhat validate_prediction_size
#' @importFrom Matrix Matrix colSums
#' @importFrom proxyC simil
#' @importFrom purrr map_dfc
#' @importFrom purrr map2_dfc
#' @importFrom stats approx
#' @importFrom stats ecdf
#' @importFrom stats prcomp
#' @importFrom stats predict
#' @importFrom stats quantile
#' @importFrom stats setNames
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom tidyr gather
#' @importFrom tidyselect vars_select
#' @importFrom utils globalVariables
## usethis namespace: end

# ------------------------------------------------------------------------------
# global variable" check
# nocov
# nocov end
# Reduce false positives when R CMD check runs its "no visible binding for
utils::globalVariables(
  c("cumulative", "n", "sim", "percentile", "component", "value")
)
NULL
