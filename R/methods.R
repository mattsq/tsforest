
#' @export

print.tsforest <- function(model) {
  ncol_training <- ncol(model$training_df) - 1
  ncol_converted <- ncol(model$featurized_df) - 1
  target <- model$target
  cat("Time series forest model converting time series of length:", ncol_training, "\n")
  cat("To length:", nrow(model$intervals[[1]]), "\n")
  cat("Predicting on target class:", target, "\n")
  if(is.null(model$ranger_model)) {
    cat("No random forest model trained yet.")
  } else {
    cat("Includes underlying random forest model:\n")
    print(model$ranger_model)
  }
  invisible(model)
}
