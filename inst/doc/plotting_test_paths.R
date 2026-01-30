## ----include = FALSE--------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

options(width = 120L)

## ----setup------------------------------------------------------------------------------------------------------------
library(covtracer)

library(withr)
library(covr)

## ----libpaths, include = FALSE----------------------------------------------------------------------------------------
init_libs <- .libPaths()
dir.create(lib <- tempfile("covtracer_pkgs_"))
.libPaths(c(lib, .libPaths()))

## ----calc_cov, message = FALSE, warning = FALSE-----------------------------------------------------------------------
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

ttdf <- covtracer::test_trace_df(examplepkg_cov, aggregate_by = NULL)

## ----more_setup-------------------------------------------------------------------------------------------------------
library(dplyr)
library(igraph)

## ---------------------------------------------------------------------------------------------------------------------
ttdf <- ttdf %>%
  filter(!is.na(test_name)) %>%
  filter(is.na(doctype) | !doctype %in% "class") %>%
  select(test_name, alias, is_exported, i) %>%
  arrange(test_name, i) %>%
  mutate(test_id = cumsum(!duplicated(test_name)))

head(ttdf)

## ---------------------------------------------------------------------------------------------------------------------
edges_df <- ttdf %>%
  split(.$test_name) %>%
  lapply(function(sdf) {
    unique(data.frame(
      from = c(sdf$test_name[[1L]], head(sdf$alias, -1L)),
      to = sdf$alias
    ))
  }) %>%
  bind_rows() %>%
  distinct()

head(edges_df)

## ---------------------------------------------------------------------------------------------------------------------
test_names <- Filter(Negate(is.na), unique(ttdf$test_name))
obj_names <- Filter(Negate(is.na), unique(ttdf$alias))

n_tests <- length(test_names)
n_objs <- length(obj_names)

vertices_df <- data.frame(
  name = c(test_names, obj_names),
  color = rep(c("cornflowerblue", "darkgoldenrod"), times = c(n_tests, n_objs)),
  label = c(sprintf("Test #%d", seq_along(test_names)), obj_names),
  test_id = c(seq_along(test_names), rep_len(NA, n_objs)),
  is_test = rep(c(TRUE, FALSE), times = c(n_tests, n_objs)),
  is_exported = c(rep_len(NA, n_tests), ttdf$is_exported[match(obj_names, ttdf$alias)])
)

vertices_df <- vertices_df %>%
  mutate(color = ifelse(is_exported, "goldenrod", color))

vertices_df %>%
  select(name, label) %>%
  head()

## ----include = FALSE--------------------------------------------------------------------------------------------------
# for whatever reason... this fixes errors when building vignettes on R-devel
edges_df
vertices_df

## ----fig.asp = 1, fig.width = 8L, out.width = "100%", error = TRUE----------------------------------------------------
try({
g <- igraph::graph_from_data_frame(edges_df, vertices = vertices_df)

par(mai = rep(0, 4), omi = rep(0, 4L))
plot.igraph(g,
  vertex.size = 8,
  vertex.label = V(g)$label,
  vertex.color = V(g)$color,
  vertex.label.family = "sans",
  vertex.label.color = "black",
  vertex.label.dist = 1,
  vertex.label.degree = -pi / 2,
  vertex.label.cex = 0.8,
  mark.border = NA,
  margin = c(0, 0.2, 0, 0.2)
)

legend(
  "bottomleft",
  inset = c(0.05, 0),
  legend = c("test", "exported function", "unexported function"),
  col = c("cornflowerblue", "goldenrod", "darkgoldenrod"),
  pch = 16,
  bty = "n"
)
})

