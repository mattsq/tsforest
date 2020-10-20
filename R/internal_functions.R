#' @importFrom stats lm coef
get_slope <- function(vec) {
  data <- data.frame(Y = vec, X = 1:length(vec))
  stats::lm(Y ~ X, data = data) %>%
    stats::coef() %>%
    {.[2]}
}

#' @importFrom tibble rownames_to_column
#' @importFrom stringr str_extract str_remove_all str_remove
scores_to_tibble <- function(scores) {
  scores_df <- data.frame(
    importance = scores
  ) %>%
    tibble::rownames_to_column() %>%
    dplyr::mutate(From = stringr::str_extract(rowname, "From\\d+To"),
                  To = stringr::str_extract(rowname, "To\\d+$"),
                  From = stringr::str_remove_all(From, "From|To") %>% as.numeric(),
                  To = stringr::str_remove_all(To, "To") %>% as.numeric(),
                  Type = stringr::str_extract(rowname, "\\w+_\\d+") %>% stringr::str_remove("_\\d+"))
  return(scores_df)
}



