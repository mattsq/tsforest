#' Create new TS Forest Object
#'
#' Helper function to create a new object of class 'tsforest'
#'
#' Creates a new tsforest object with a training dataset and a target column. Used internally by
#' `tsforest::tsforest`, but also can be used to featurize a new data frame using `tsforest::featurize_df`.
#' @param data a training data set where each row is a time series, plus a target class
#' @param target a character, indicating the name of the target column
#' @examples
#' data("FreezerRegularTrain_TRAIN")
#' ts_obj <- new_tsforest(FreezerRegularTrain_TRAIN, target = "target")
#'
#' @importFrom purrr map_dbl
#' @export

new_tsforest <- function(data, target, min_length = 2, n_trees) {

  if (missing(n_trees))
    stop("`n_trees` must be supplied explicitly.")

  X_df        <- data[, !colnames(data) %in% target, drop = FALSE]
  n_intervals <- floor(sqrt(ncol(X_df)))

  # sample a private interval bag for every tree
  per_tree <- vector("list", n_trees)
  for (j in seq_len(n_trees)) {
    starts <- sample(1:(ncol(X_df) - min_length), n_intervals, replace = TRUE)
    ends   <- purrr::map_dbl(starts,
                             ~ sample((.x + min_length):ncol(X_df), 1))
    per_tree[[j]] <- tibble::tibble(start = starts, end = ends)
  }

  structure(
    list(
      training_df   = data,
      featurized_df = NULL,
      ranger_model  = NULL,
      target        = target,
      intervals     = per_tree,   # list-of-tibbles (one per tree)
      feature_names = NULL
    ),
    class = "tsforest"
  )
}

