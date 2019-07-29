#' Binary QSAR Data
#'
#' @details These data are from two different sources on quantitative
#'  structure-activity relationship (QSAR) modeling and contain 49 predictors
#'  that are either 0 or 1. The training set contains 3796 samples (from the
#'  `caco` data set in the `QSARdata` package) and there are 80 unknown samples
#'  (taken from the `bbb2` data in the same package).
#'
#' The training set was collected from a general set used to measure
#'  permeability while the new samples are from a set of molecules used to study
#'  brain penetration (presumably for neuroscience related purposes).
#'
#' @name binary
#' @aliases qsar_binary binary_tr binary_unk
#' @docType data
#' @return \item{binary_tr,binary_ukn}{data frame frames with 49 columns}
#'
#'
#' @keywords datasets
#' @examples
#' data(qsar_binary)
#' str(binary_tr)
NULL

#' OkCupid Binary Predictors
#'
#' @details Data originally from Kim (2015) includes a training and test set
#'  consistent with Kuhn and Johnson (2020). Predictors include ethnicity
#'  indicators and a set of keywords derived from text essay data.
#'
#' @name okc_binary
#' @aliases okc_binary okc_binary_train okc_binary_test
#' @docType data
#' @return \item{okc_binary_train. okc_binary_test}{data frame frames with 61 columns}
#'
#' @source
#' Kim (2015), "OkCupid Data for Introductory Statistics and Data Science Courses", _Journal of Statistics Education_, Volume 23, Number 2. \url{http://www.amstat.org/publications/jse/contents_2015.html}
#'
#' Kuhn and Johnson (2020), _Feature Engineering and Selection_, Chapman and Hall/CRC . \url{https://bookdown.org/max/FES/} and \url{https://github.com/topepo/FES}
#'
#' @keywords datasets
#' @examples
#' data(okc_binary)
#' str(okc_binary_train)
NULL



