#' Time Series Forest
#'
#' Train a time series forest model.
#'
#' This function trains a time series classification forest model using the methods
#' described by Deng et al. (2013). Specifically, the code here is based on
#' the description at:
#' http://www.timeseriesclassification.com/algorithmdescription.php?algorithm_id=5
#' In essence, the model splits each time series into `sqrt(ncol(df))` intervals,
#' then calcuates the mean, standard deviation and slope of those intervals, and
#' then uses those values for every interval as the inputs to a random forest model.
#' Here, we use `ranger::`.
#'
#' @param df A data.frame object where each row is a time series.
#' @param target The name of the predicted class column, as a string
#' @param min_length The minimum length of the sample intervals created. Must be >= 2
#' @param verbose Whether or not to print the state of training as it happens.
#' @param ... arguments to be passed to the `ranger::ranger()`model, like mtry
#' @return Returns a time series forest model object (just a list at the moment)
#' @examples
#' \dontrun{
#' data("LargeKitchenAppliances_TRAIN")
#' model <- tsforest(LargeKitchenAppliances_TRAIN, target = "target")
#' }
#' @importFrom purrr map_dbl
#' @import ranger
#' @importFrom stats as.formula
#' @export
tsforest <- function(df,
                     target = "target",
                     min_length = 2,
                     verbose = TRUE,
                     ...) {
  X_df <- df[,!colnames(df) == target]

  n_intervals <- floor(sqrt(ncol(X_df)))
  if (verbose) {
    cat(glue::glue("Training model with {n_intervals} intervals..."))
    cat("\n")
  }
  returned_object <- list(
    featurized_df = NA,
    ranger_model = NA,
    target = target,
    intervals = list(
      start = numeric(n_intervals),
      end = numeric(n_intervals)
    )
  )

  returned_object$intervals$start <- sample(1:(ncol(X_df)-min_length), n_intervals)
  returned_object$intervals$end <- purrr::map_dbl(returned_object$intervals$start, ~ sample((.x):ncol(X_df), 1))

  featurized_df <- featurize_df(X_df = X_df, returned_object = returned_object)
  featurized_df$target <- df[,colnames(df) == target]
  returned_object$featurized_df <- featurized_df

  form_for_pred <- stats::as.formula(paste0(target, " ~ ."))

  returned_object$ranger_model <- ranger::ranger(form_for_pred,
                                                 data = returned_object$featurized_df,
                                                 ...)
  return(returned_object)
}

#' Predict Time Series Forest
#'
#' Predict classes using a time series forest model
#'
#' This function takes a time series forest model and returns predictions, and
#' featurizes new data using the same intervals as needed.
#'
#' @param model A time series forest model object
#' @param newdata optional new data frame - if not supplied, will use training data
#' @param type As per 'response' argument of ranger::predict.ranger
#' @param verbose Whether to print state of featurizing new data
#' @param ... arguments to be passed to `ranger::predict.ranger`, like `type = "response"`
#' @return Returns predictions in the form of a `ranger::predict.ranger` response.
#' @examples
#' \dontrun{
#' data("LargeKitchenAppliances_TRAIN")
#' data("LargeKitchenAppliances_TEST")
#' model <- tsforest(LargeKitchenAppliances_TRAIN, target = "target")
#' train_preds <- predict_tsforest(model)
#' test_preds <- predict_tsforest(model, newdata = LargeKitchenAppliances_TEST)
#' }
#'
#' @importFrom stats predict
#' @export
predict_tsforest <- function(model,
                             newdata = NULL,
                             verbose = TRUE,
                             ...) {
  if(is.null(newdata)) {
    preds <- stats::predict(model$ranger_model, data = model$featurized_df, type = type)
  } else {
    X_newdata <- newdata[,!colnames(newdata) == model$target]
    featurized_newdata <- featurize_df(X_newdata, model, verbose = verbose)
    preds <- stats::predict(model$ranger_model, data = featurized_newdata, ...)
  }
  return(preds)
}
