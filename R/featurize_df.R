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
featurize_df <- function(data, tsforest_obj, verbose) {

  if(ncol(data) != ncol(tsforest_obj$training_df)) {
    stop("New data must have the same dimensions as the data the object was created on.")
  }


  n_intervals <- length(tsforest_obj$intervals$start)
  if (verbose) {
    cat(glue::glue("Creating features with {n_intervals} intervals..."))
    cat("\n")
  }

  X_df <- data[,!colnames(data) == tsforest_obj$target]

  all_features <- vector("list", length = n_intervals)

  for (k in 1:n_intervals) {

    interval_start <- tsforest_obj$intervals$start[k]
    interval_end <- tsforest_obj$intervals$end[k]

    if (verbose) {
      cat(glue::glue("{k}: Interval from {interval_start} to {interval_end}"))
      cat("\n")
    }

    restricted_df <- X_df[,interval_start:interval_end]

    features <- restricted_df %>%
      dplyr::rowwise() %>%
      dplyr::mutate(mean = mean(dplyr::c_across(everything())),
                    sd = stats::sd(dplyr::c_across(everything())),
                    slope = get_slope(dplyr::c_across(everything()))) %>%
      dplyr::select(mean, sd, slope)

    colnames(features) <- paste0(c("mean","sd","slope"),"_",k,"_From",interval_start,"To",interval_end)
    all_features[[k]] <- features
  }

  featurized_df <- dplyr::bind_cols(all_features)
  featurized_df$target <- data$target
  return(featurized_df)
}
