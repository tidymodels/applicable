#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

run_tests <- "--run-tests" %in% args
run_covr <- "--run-covr" %in% args
diff_arg <- args[!args %in% "--run-tests"]
diff_arg <- diff_arg[!diff_arg %in% "--run-covr"]
diff_spec <- if (length(diff_arg) > 0) diff_arg[[1]] else "HEAD"

get_changed_r_files <- function(spec) {
  cmd <- if (spec == "HEAD") {
    "git diff --name-only --diff-filter=ACMRTUXB HEAD -- R"
  } else {
    sprintf("git diff --name-only --diff-filter=ACMRTUXB %s -- R", shQuote(spec))
  }

  out <- system(cmd, intern = TRUE, ignore.stderr = TRUE)
  out <- trimws(out)
  out[nzchar(out)]
}

extract_functions <- function(path) {
  lines <- readLines(path, warn = FALSE)
  matches <- regexec("^\\s*([.A-Za-z][.A-Za-z0-9_]*)\\s*<-\\s*function\\s*\\(", lines)
  caps <- regmatches(lines, matches)
  funs <- vapply(
    caps,
    function(x) if (length(x) >= 2) x[[2]] else "",
    character(1)
  )
  unique(funs[nzchar(funs)])
}

count_test_hits <- function(fun_name, test_text) {
  pattern <- sprintf("\\b%s\\b", fun_name)
  m <- gregexpr(pattern, test_text, perl = TRUE)[[1]]
  if (identical(m, -1L)) 0L else length(m)
}

changed_files <- get_changed_r_files(diff_spec)
if (length(changed_files) == 0) {
  cat("No changed files under R/ for diff spec:", diff_spec, "\n")
  quit(status = 0)
}

all_funs <- unlist(lapply(changed_files, extract_functions), use.names = FALSE)
all_funs <- sort(unique(all_funs))

if (length(all_funs) == 0) {
  cat("Changed R/ files found, but no function definitions matched.\n")
} else {
  cat("Changed R files:\n")
  cat(paste0("  - ", changed_files), sep = "\n")
  cat("\n\nFunctions found in changed files:\n")
  cat(paste0("  - ", all_funs), sep = "\n")
  cat("\n")
}

test_files <- Sys.glob("tests/testthat/test-*.R")
test_text <- if (length(test_files)) {
  paste(
    unlist(lapply(test_files, readLines, warn = FALSE), use.names = FALSE),
    collapse = "\n"
  )
} else {
  ""
}

if (length(all_funs) > 0 && nzchar(test_text)) {
  hits <- vapply(all_funs, count_test_hits, integer(1), test_text = test_text)
  covered <- names(hits[hits > 0])
  uncovered <- names(hits[hits == 0])

  cat("\nFunction name references in tests:\n")
  for (nm in names(hits)) {
    cat(sprintf("  - %s: %d\n", nm, hits[[nm]]))
  }

  if (length(uncovered) > 0) {
    cat("\nPotentially untested changed functions (name not found in tests):\n")
    cat(paste0("  - ", uncovered), sep = "\n")
    cat("\n")
  } else {
    cat("\nAll changed function names appear in tests.\n")
  }
}

if (run_tests) {
  if (!requireNamespace("testthat", quietly = TRUE)) {
    stop("Package 'testthat' is required. Install it with install.packages('testthat').")
  }
  cat("\nRunning full test suite...\n")
  testthat::test_local(".", reporter = "summary")
}

if (run_covr) {
  if (!requireNamespace("covr", quietly = TRUE)) {
    stop("Package 'covr' is required for --run-covr. Install it with install.packages('covr').")
  }

  cat("\nRunning execution coverage with covr...\n")
  cov <- covr::package_coverage(type = "tests")
  cov_df <- as.data.frame(cov)
  cov_df <- cov_df[!is.na(cov_df$value), , drop = FALSE]
  cov_df$covered <- cov_df$value > 0

  pct_by <- function(df, group_col) {
    split_idx <- split(seq_len(nrow(df)), df[[group_col]])
    keys <- names(split_idx)
    covered <- vapply(
      split_idx,
      function(idx) mean(df$covered[idx]) * 100,
      numeric(1)
    )
    data.frame(
      key = keys,
      coverage = as.numeric(covered),
      stringsAsFactors = FALSE
    )
  }

  by_file <- pct_by(cov_df, "filename")
  by_function <- pct_by(cov_df, "functions")

  file_key <- basename(changed_files)
  file_hits <- by_file[basename(by_file$key) %in% file_key, , drop = FALSE]
  file_hits <- file_hits[order(file_hits$key), , drop = FALSE]

  cat("\nCoverage for changed R files:\n")
  if (nrow(file_hits) == 0) {
    cat("  - No coverage rows matched changed files.\n")
  } else {
    for (i in seq_len(nrow(file_hits))) {
      cat(sprintf("  - %s: %.2f%%\n", file_hits$key[[i]], file_hits$coverage[[i]]))
    }
  }

  cat("\nCoverage for changed functions:\n")
  fn_hits <- by_function[by_function$key %in% all_funs, , drop = FALSE]
  if (nrow(fn_hits) == 0) {
    cat("  - No function coverage rows matched changed functions.\n")
  } else {
    fn_hits <- fn_hits[order(fn_hits$key), , drop = FALSE]
    for (i in seq_len(nrow(fn_hits))) {
      cat(sprintf("  - %s: %.2f%%\n", fn_hits$key[[i]], fn_hits$coverage[[i]]))
    }

    missing_cov <- setdiff(all_funs, fn_hits$key)
    if (length(missing_cov) > 0) {
      cat("\nChanged functions not present in covr function table:\n")
      cat(paste0("  - ", sort(missing_cov)), sep = "\n")
      cat("\n")
    }
  }
}
