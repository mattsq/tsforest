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

new_tsforest <- function(data, target, min_length) {
  X_df <- data[,!colnames(data) == target]
  n_intervals <- floor(sqrt(ncol(X_df)))
  obj <-
    structure(
      list(
        training_df = data,
        featurized_df = NA,
        ranger_model = NA,
        target = target,
        intervals = list(
          start = sample(1:((ncol(X_df)-min_length)), n_intervals),
          end = NA
        )
      ), class = "tsforest")

  obj$intervals$end <- purrr::map_dbl(obj$intervals$start, ~ sample((.x+min_length):ncol(X_df), 1))

  return(obj)
}
