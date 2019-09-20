# ------------------------------------------------------------------------------

new_apd_similarity <- function(quantile, ref_data, options, ref_scores, blueprint) {

  hardhat::new_model(
    quantile = quantile,
    ref_data = ref_data,
    blueprint = blueprint,
    options = options,
    ref_scores = ref_scores,
    class = "apd_similarity"
  )
}

# -------------------------------------------------------------------
# ----------------- Model function implementation -------------------
# -------------------------------------------------------------------


apd_similarity_impl <- function(predictors, quantile, options) {

  if (!any("method" == names(options))) {
    options$method <- "jaccard"
  }

  res <- list(quantile = quantile, ref_data  = predictors, options = options)

  p <- nrow(predictors)
  keep_n <- min(p, 5000)
  sampling <- sample.int(p, keep_n)
  ref_scores <-
    tibble::tibble(
      sim = score_apd_similarity_numeric(res, predictors[sampling,,drop = FALSE], options)
    ) %>%
    dplyr::group_by(sim) %>%
    dplyr::count() %>%
    dplyr::ungroup() %>%
    dplyr::mutate(cumulative = cumsum(n)/sum(n))
  res$ref_scores <- ref_scores
  res
}

# -------------------------------------------------------------------
# ------------------- Model function bridge -------------------------
# -------------------------------------------------------------------

apd_similarity_bridge <- function(processed, quantile = NA_real_, ...) {
  opts <- list(...)

  msg <- "The `quantile` argument should be NA or a single numeric value in [0, 1]."
  if (!is.na(quantile) && (!is.numeric(quantile) || length(quantile) != 1)) {
    stop(msg, call. = FALSE)
  }
  if (!is.na(quantile) && (quantile < 0 | quantile > 1)) {
    stop(msg, call. = FALSE)
  }

  predictors <- processed$predictors
  if (!is.matrix(predictors)) {
    predictors <- as.matrix(predictors)
  }

  not_bin <- apply(predictors, 2, function(x) any(x != 1 & x != 0))
  if (any(not_bin)) {
    bad_x <- colnames(predictors)[not_bin]
    stop("The following variables are not binary: ",
         paste0(bad_x, collapse = ", "),
         call. = FALSE)
  }

  if (!inherits(predictors, "dgCMatrix")) {
    predictors <- Matrix::Matrix(predictors, sparse = TRUE)
  }

  # check for binary and not zero-vars

  zv <- Matrix::colSums(predictors)
  if (all(zv == 0)) {
    stop("All variables have a single unique value.", call. = FALSE)
  } else {
    if (any(zv == 0)) {
      bad_x <- colnames(predictors)[zv == 0]
      warning("The following variables had zero variance and were removed: ",
              paste0(bad_x, collapse = ", "),
              call. = FALSE)
      predictors <- predictors[, zv > 0, drop = FALSE]
    }
  }

  fit <- apd_similarity_impl(predictors, quantile = quantile, options = opts)

  new_apd_similarity(
    quantile = quantile,
    ref_data = fit$ref_data,
    options = fit$options,
    ref_scores = fit$ref_scores,
    blueprint = processed$blueprint
  )
}

# -------------------------------------------------------------------
# ------------------ Model function interface -----------------------
# -------------------------------------------------------------------
#' Applicability domain methods using binary similarity analysis
#'
#' `apd_similarity()` is used to analyze samples in terms of similarity scores
#'  for binary data. All features in the data should be binary (i.e. zero or
#'  one).
#'
#' @param x Depending on the context:
#'
#'   * A __data frame__ of binary predictors.
#'   * A __matrix__ of binary predictors.
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#' @param data When a __recipe__ or __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing the binary predictors. Any predictors with
#'     no 1's will be removed (with a warning).
#'
#' @param formula A formula specifying the predictor terms on the right-hand
#' side. No outcome should be specified.
#'
#' @param quantile A real number between 0 and 1 or NA for how the similarity
#'  values for each sample versus the training set should be summarized. A value
#'  of `NA` specifies that the mean similarity is computed. Otherwise, the
#'  appropriate quantile is computed.
#'
#' @param ... Options to pass to `proxyC::simil()`, such as `method`. If no
#'  options are specified, `method = "jaccard"` is used.
#'
#' @details The function computes measures of similarity for different samples
#'  points. For example, suppose samples `A` and `B` both contain _p_ binary
#'  variables. First, a 2x2 table is constructed between `A` and `B` _across
#'  their elements_. The table will contain _p_ entries across the four cells
#'  (see the example below). From this, different measures of likeness are
#'  computed.
#'
#' For a training set of _n_ samples, a new sample is compared to each,
#'  resulting in _n_ similarity scores. These can be summarized into a single
#'  value; the median similarity is used by default by the scoring function.
#'
#' For this method, the computational methods are fairly taxing for large data
#'  sets. The training set must be stored (albeit in a sparse matrix format) so
#'  object sizes may become large.
#'
#' By default, the computations are run in parallel using _all possible
#'  cores_. To change this, call the `setThreadOptions` function in the
#'  `RcppParallel` package.
#'
#' @return
#'
#' A `apd_similarity` object.
#'
#' @references Leach, A. and Gillet V. (2007). _An Introduction to
#' Chemoinformatics_. Springer, New York
#' @examples
#' \dontrun{
#' data(qsar_binary)
#'
#' jacc_sim <- apd_similarity(binary_tr)
#' jacc_sim
#'
#' # plot the empirical cumulative distribution function (ECDF) for the training set:
#' library(ggplot2)
#' autoplot(jacc_sim)
#'
#' # Example calculations for two samples:
#' A <- as.matrix(binary_tr[1,])
#' B <- as.matrix(binary_tr[2,])
#' xtab <- table(A, B)
#' xtab
#'
#' # Jaccard statistic
#' xtab[2, 2] / (xtab[1, 2] + xtab[2, 1] + xtab[2, 2])
#'
#' # Hamman statistic
#' ( ( xtab[1, 1] + xtab[2, 2] ) - ( xtab[1, 2] + xtab[2, 1] ) ) / sum(xtab)
#'
#' # Faith statistic
#' ( xtab[1, 1] + xtab[2, 2]/2 ) / sum(xtab)
#'
#' # Summarize across all training set similarities
#' mean_sim <- score(jacc_sim, new_data = binary_unk)
#' mean_sim
#' }
#' @export
apd_similarity <- function(x, ...) {
  UseMethod("apd_similarity")
}



#' @export
#' @rdname apd_similarity
apd_similarity.default <- function(x, quantile = NA_real_, ...) {
  cls <- class(x)[1]
  message <-
    "`x` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified."
  message <- glue::glue(message)
  rlang::abort(message = message)
}

# Data frame method

#' @export
#' @rdname apd_similarity
apd_similarity.data.frame <- function(x, quantile = NA_real_, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_similarity_bridge(processed, quantile = quantile, ...)
}

# Matrix method

#' @export
#' @rdname apd_similarity
apd_similarity.matrix <- function(x, quantile = NA_real_, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_similarity_bridge(processed, quantile = quantile, ...)
}

# Formula method

#' @export
#' @rdname apd_similarity
apd_similarity.formula <- function(formula, data, quantile = NA_real_, ...) {
  processed <- hardhat::mold(formula, data)
  apd_similarity_bridge(processed, quantile = quantile, ...)
}

# Recipe method

#' @export
#' @rdname apd_similarity
apd_similarity.recipe <- function(x, data, quantile = NA_real_, ...) {
  processed <- hardhat::mold(x, data)
  apd_similarity_bridge(processed, quantile = quantile, ...)
}

# -------------------------------------------------------------------
# ----------------- Scoring function implementation -----------------
# -------------------------------------------------------------------
score_apd_similarity_numeric <- function(model, predictors, options) {
  predictors <-
    predictors[, colnames(predictors) %in% colnames(model$ref_data), drop = FALSE]

  if (!is.matrix(predictors)) {
    predictors <- as.matrix(predictors)
  }

  if (!inherits(predictors, "dgCMatrix")) {
    predictors <- Matrix::Matrix(predictors, sparse = TRUE)
  }

  cl <-
    rlang::call2(
      "simil",
      .ns = "proxyC",
      x = rlang::expr(model$ref_data),
      y = rlang::expr(predictors),
      !!!model$options
    )
  sims <- rlang::eval_tidy(cl)
  if (is.na(model$quantile)) {
    res <- apply(sims, 2, mean, na.rm = TRUE)
  } else {
    res <- apply(sims, 2, quantile, probs = model$quantile, na.rm = TRUE)
  }
  res
}

# -------------------------------------------------------------------
# ------------------- Scoring function bridge -----------------------
# -------------------------------------------------------------------
score_apd_similarity_bridge <- function(type, model, predictors) {

  score_function <- get_sim_score_function(type)

  predictions <- score_function(model, predictors, options)
  predictions <- tibble::tibble(similarity = predictions)

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

get_sim_score_function <- function(type) {
  switch(
    type,
    numeric = score_apd_similarity_numeric
  )
}

# -------------------------------------------------------------------
# ------------------ Scoring function interface ---------------------
# -------------------------------------------------------------------
#' Score new samples using similarity methods
#'
#' @param object A `apd_similarity` object.
#'
#' @param new_data A data frame or matrix of new predictors.
#'
#' @param type A single character. The type of predictions to generate.
#' Valid options are:
#'
#' - `"numeric"` for a numeric value that summarizes the similarity values for
#'   each sample across the training set.
#'
#' @param add_percentile A single logical; should the percentile of the
#'  similarity score _relative to the training set values_ by computed?
#'
#' @param ... Not used, but required for extensibility.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`. For `type = "numeric"`,
#' the tibble contains a column called "similarity". If `add_percentile = TRUE`,
#' an additional column called `similarity_pctl` will be added. These values are
#' in percent units so that a value of 11.5 indicates that, in the training set,
#' 11.5 percent of the training set samples had smaller values than the sample
#' being scored.
#'
#' @examples
#' \dontrun{
#' data(qsar_binary)
#'
#' jacc_sim <- apd_similarity(binary_tr)
#'
#' mean_sim <- score(jacc_sim, new_data = binary_unk)
#' mean_sim
#' }
#'
#' @export
score.apd_similarity <- function(object, new_data, type = "numeric", add_percentile = TRUE, ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  res <- score_apd_similarity_bridge(type, object, forged$predictors)
  if (add_percentile) {
    res$similarity_pctl <- sim_percentile(res$similarity, object$ref_scores)
  }
  res
}


sim_percentile <- function(sims, ref) {
  res <- stats::approx(ref$sim, ref$cumulative, xout = sims)$y
  res[sims < min(ref$sim, na.rm = TRUE)] <- 0
  res[sims > max(ref$sim, na.rm = TRUE)] <- 1

  res * 100
}
