#' Featurize Data Frame
#'
#' Convert a data frame into a time series forest-ready bag of mean/sd/slope random features
#'
#' @importFrom glue glue
#' @importFrom dplyr rowwise mutate select bind_cols c_across
#' @importFrom stats sd
#' @examples
#' data("FreezerRegularTrain_TRAIN")
#' data("FreezerRegularTrain_TEST")
#' ts_obj <- new_tsforest(FreezerRegularTrain_TRAIN, target = "target")
#' test_df <- featurize_df(FreezerRegularTrain_TEST, tsforest_obj = ts_obj, verbose = TRUE)
#' @export

featurize_df <- function(data, tsforest_obj, tree_idx, verbose = FALSE) {

  if (missing(tree_idx))
    stop("`tree_idx` (1 … n_trees) is required.")

  int_tbl <- tsforest_obj$intervals[[tree_idx]]

  if (ncol(data) != ncol(tsforest_obj$training_df))
    stop("`data` must have the same number of columns as the training set.")

  X_df <- data[, !colnames(data) %in% tsforest_obj$target, drop = FALSE]
  all_features <- vector("list", nrow(int_tbl))

  for (k in seq_len(nrow(int_tbl))) {

    s <- int_tbl$start[k];  e <- int_tbl$end[k]
    if (verbose) cat(glue::glue("{tree_idx}:{k} interval {s}–{e}"), "\n")

    stats_mat <- calc_interval_features(as.matrix(X_df[, s:e, drop = FALSE]))

    colnames(stats_mat) <- paste0(c("mean", "sd", "slope"),
                                  "_", k, "_From", s, "To", e)
    all_features[[k]] <- as.data.frame(stats_mat, check.names = FALSE)
  }

  dplyr::bind_cols(all_features)
}

