#' Binary QSAR Data
#'
#' @details These data are from two different sources on quantitative
#'  structure-activity relationship (QSAR) modeling and contain 67 predictors
#'  that are either 0 or 1. The training set contains 4,330 samples and there
#'  are five unknown samples (both from the `Mutagen` data in the `QSARdata`
#'  package).
#'
#' @name binary
#' @aliases qsar_binary binary_tr binary_unk
#' @docType data
#' @return \item{binary_tr,binary_ukn}{data frame frames with 67 columns}
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
#' @return \item{okc_binary_train,okc_binary_test}{data frame frames with 61 columns}
#'
#' @source
#' Kim (2015), "OkCupid Data for Introductory Statistics and Data Science Courses", _Journal of Statistics Education_, Volume 23, Number 2. \url{https://www.tandfonline.com/doi/abs/10.1080/10691898.2015.11889737}
#'
#' Kuhn and Johnson (2020), _Feature Engineering and Selection_, Chapman and Hall/CRC . \url{https://bookdown.org/max/FES/} and \url{https://github.com/topepo/FES}
#'
#' @keywords datasets
#' @examples
#' data(okc_binary)
#' str(okc_binary_train)
NULL

#' Recent Ames Iowa Houses
#'
#' More data related to the set described by De Cock (2011) where data where
#' data were recorded for 2,930 properties in Ames IA.
#'
#' This data sets includes three more properties added since the original
#' reference. There are less fields in this data set; only those that could be
#' transcribed from the assessor's office were included.
#'
#' @name ames_new
#' @aliases ames_new
#' @docType data
#' @return \item{ames_new}{a tibble}
#' @details
#'
#'
#' @source De Cock, D. (2011). "Ames, Iowa: Alternative to the Boston Housing
#' Data as an End of Semester Regression Project," \emph{Journal of Statistics
#' Education},  Volume 19, Number 3.
#'
#' \url{https://www.cityofames.org} (see Assessor's department site)
#'
#' \url{http://jse.amstat.org/v19n3/decock/DataDocumentation.txt}
#'
#' \url{http://jse.amstat.org/v19n3/decock.pdf}
#'
#' @keywords datasets
NULL
