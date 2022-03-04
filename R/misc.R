# from recipes:::names0
names0 <- function(num, prefix = "x") {
  if (num < 1) {
    rlang::abort("`num` should be > 0")
  }
  ind <- format(1:num)
  ind <- gsub(" ", "0", ind)
  paste0(prefix, ind)
}
