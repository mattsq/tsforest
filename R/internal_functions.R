#' @importFrom stats lm
get_slope <- function(vec) {
  data <- data.frame(Y = vec, X = 1:length(vec))
  stats::lm(Y ~ X, data = data) %>%
    coef() %>%
    {.[2]}
}

#' @importFrom glue glue
#' @importFrom dplyr rowwise mutate select bind_cols c_across
#' @importFrom stats sd
featurize_df <- function(X_df, returned_object, verbose) {
  n_intervals <- length(returned_object$intervals$start)
  all_features <- vector("list", length = n_intervals)
  for (k in 1:n_intervals) {
    interval_start <- returned_object$intervals$start[k]
    interval_end <- returned_object$intervals$end[k]
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
}
