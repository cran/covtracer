## ----include = FALSE--------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

local({
  source_hook <- knitr::knit_hooks$get("source")
  knitr::knit_hooks$set(source = function(x, options) {
    old_opts <- options(width = 120L)
    on.exit(options(old_opts))

    source_hook(x, options)
  })
})

## ----setup------------------------------------------------------------------------------------------------------------
library(covtracer)

## ----include = FALSE--------------------------------------------------------------------------------------------------
library(withr)
library(covr)

withr::with_temp_libpaths({
  options(keep.source = TRUE, keep.source.pkg = TRUE, covr.record_tests = TRUE)
  examplepkg_source_path <- system.file("examplepkg", package = "covtracer")
  install.packages(
    examplepkg_source_path,
    type = "source",
    repos = NULL,
    quiet = TRUE,
    INSTALL_opts = c("--with-keep.source", "--install-tests")
  )
  examplepkg_cov <- covr::package_coverage(examplepkg_source_path)
  examplepkg_ns <- getNamespace("examplepkg")
})

## ---------------------------------------------------------------------------------------------------------------------
print(examplepkg_ns$hypotenuse)

## ---------------------------------------------------------------------------------------------------------------------
getSrcref(covtracer::test_trace_df)

## ---------------------------------------------------------------------------------------------------------------------
# get line and column ranges (for details see ?srcref)
as.numeric(getSrcref(covtracer::test_trace_df))

## ---------------------------------------------------------------------------------------------------------------------
getSrcFilename(covtracer::test_trace_df)

## ----eval = FALSE-----------------------------------------------------------------------------------------------------
# library(withr)
# library(covr)
# 
# withr::with_temp_libpaths({
#   options(keep.source = TRUE, keep.source.pkg = TRUE, covr.record_tests = TRUE)
#   examplepkg_source_path <- system.file("examplepkg", package = "covtracer")
#   install.packages(
#     examplepkg_source_path,
#     type = "source",
#     repos = NULL,
#     INSTALL_opts = c("--with-keep.source", "--install-tests")
#   )
#   examplepkg_cov <- covr::package_coverage(examplepkg_source_path)
#   examplepkg_ns <- getNamespace("examplepkg")
# })

## ----include = FALSE--------------------------------------------------------------------------------------------------
pkg_srcrefs(examplepkg_ns)[1] # for brevity, only showing first srcref

## ----eval = FALSE-----------------------------------------------------------------------------------------------------
# pkg_srcrefs(examplepkg_ns)["test_description.character"]

## ---------------------------------------------------------------------------------------------------------------------
head(pkg_srcrefs_df(examplepkg_ns))

## ---------------------------------------------------------------------------------------------------------------------
df <- pkg_srcrefs_df(examplepkg_ns)
df$srcref[[1L]]

## ---------------------------------------------------------------------------------------------------------------------
examplepkg_test_srcrefs <- test_srcrefs(examplepkg_cov)

## ----eval = FALSE-----------------------------------------------------------------------------------------------------
# getSrcFilename(examplepkg_test_srcrefs[[1]])

## ----echo = FALSE-----------------------------------------------------------------------------------------------------
# execute this code instead, which avoids a vignette error on R devel
getSrcFilename(examplepkg_test_srcrefs[1][[1]])

## ---------------------------------------------------------------------------------------------------------------------
head(examplepkg_test_srcrefs)

## ---------------------------------------------------------------------------------------------------------------------
examplepkg_cov[[1]]$srcref

## ---------------------------------------------------------------------------------------------------------------------
examplepkg_trace_srcrefs <- trace_srcrefs(examplepkg_cov)
examplepkg_trace_srcrefs[1]

## ---------------------------------------------------------------------------------------------------------------------
head(trace_srcrefs_df(examplepkg_cov))

