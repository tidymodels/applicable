#' Plot the distribution function for pcas
#'
#' @param object An object produced by `apd_pca`.
#'
#' @param ... An optional set of `dplyr` selectors, such as `dplyr::matches()` or
#'  `dplyr::starts_with()` for selecting which variables should be shown in the
#'  plot.
#'
#' @return A `ggplot` object that shows the distribution function for each
#' principal component.
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' library(modeldata)
#' data(biomass)
#'
#' biomass_ad <- apd_pca(biomass[, 3:8])
#'
#' autoplot(biomass_ad)
#' # Using selectors in `...`
#' autoplot(biomass_ad, distance) + scale_x_log10()
#' autoplot(biomass_ad, matches("PC[1-2]"))
#'
#' @export autoplot.apd_pca
#' @export
autoplot.apd_pca <- function(object, ...) {
  selections <- rlang::enquos(...)

  pctl_data <- object$pctls

  if (length(selections) > 0) {
    terms <- tidyselect::vars_select(names(pctl_data), !!!selections)
    pctl_data <- pctl_data %>% dplyr::select(!!terms, percentile)
  }

  pctl_data %>%
    tidyr::gather(component, value, -percentile) %>%
    ggplot2::ggplot(aes(x = value, y = percentile)) +
    ggplot2::geom_step(direction = "hv") +
    ggplot2::facet_wrap(~ component) +
    xlab("abs(value)")
}

#' Plot the cumulative distribution function for similarity metrics
#'
#' @param object An object produced by `apd_similarity`.
#'
#' @param ... Not currently used.
#'
#' @return A `ggplot` object that shows the cumulative probability versus the
#'  unique similarity values in the training set. Not that for large samples,
#'  this is an approximation based on a random sample of 5,000 training set
#'  points.
#'
#' @examples
#' set.seed(535)
#' tr_x <- matrix(sample(0:1, size = 20 * 50, prob = rep(.5, 2),
#'  replace = TRUE), ncol = 20)
#' model <- apd_similarity(tr_x)
#'
#' @export autoplot.apd_similarity
#' @export
autoplot.apd_similarity <- function(object, ...) {
  lab <-
    dplyr::case_when(
      is.na(object$quantile) ~ "mean",
      object$quantile == 0.5 ~ "median",
      TRUE ~ paste0(round(object$quantile * 100, 1), "th quantile of")
    )

  ggplot2::ggplot(object$ref_scores, ggplot2::aes(x = sim, y = cumulative)) +
    ggplot2::geom_step(direction = "vh") +
    ggplot2::ylab("Cumulative Probability") +
    ggplot2::xlab(paste(lab, "similarity (training set)"))
}
