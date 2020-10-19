
#' @export

print.tsforest <- function(model) {
  ncol_training <- ncol(model$training_df) - 1
  ncol_converted <- ncol(model$featurized_df) - 1
  target <- model$target
  cat("Time series forest model converting time series of length:", ncol_training, "\n")
  cat("To length:", ncol_converted, "\n")
  cat("Predicting on target class:", target, "\n")
  cat("Includes underlying random forest model:\n")
  print(model$ranger_model)
  invisible(model)
}
