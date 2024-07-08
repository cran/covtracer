## ----include = FALSE--------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(width = 120L)

## ----setup------------------------------------------------------------------------------------------------------------
library(covtracer)

## ----message = FALSE, warning = FALSE---------------------------------------------------------------------------------
library(withr)
library(covr)

withr::with_temp_libpaths({
  options(keep.source = TRUE, keep.source.pkg = TRUE, covr.record_tests = TRUE)
  examplepkg_source_path <- system.file("examplepkg", package = "covtracer")
  install.packages(
    examplepkg_source_path,
    type = "source",
    repos = NULL,
    INSTALL_opts = c("--with-keep.source", "--install-tests")
  )
  examplepkg_cov <- covr::package_coverage(examplepkg_source_path)
  examplepkg_ns <- getNamespace("examplepkg")
})

## ---------------------------------------------------------------------------------------------------------------------
traces_df <- trace_srcrefs_df(examplepkg_cov)
pkg_ns_df <- pkg_srcrefs_df(examplepkg_ns)

## ---------------------------------------------------------------------------------------------------------------------
cat("pkg  : ", format(pkg_ns_df$srcref["s3_example_func.list"]), "\n")
cat("trace: ", format(traces_df$srcref[1L]), "\n")

## ---------------------------------------------------------------------------------------------------------------------
head(join_on_containing_srcrefs(traces_df, pkg_ns_df))

## ---------------------------------------------------------------------------------------------------------------------
head(test_trace_mapping(examplepkg_cov))

## ---------------------------------------------------------------------------------------------------------------------
# filter for interesting columns for display
cols <- c("file", "alias", "doctype")
Rd_df(examplepkg_source_path)[, cols]

## ---------------------------------------------------------------------------------------------------------------------
pkg_srcrefs_df(examplepkg_ns)

