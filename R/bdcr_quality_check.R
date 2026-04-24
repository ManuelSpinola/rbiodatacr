#' Quality check for occurrence records
#'
#' Adds a `quality_flag` column to an occurrence tibble. Requires that
#' `geospatialKosher` and `taxonomicKosher` are logical — a condition
#' guaranteed by `bdcr_occurrences()`.
#'
#' @param df       A `tibble` of occurrence records (output of `bdcr_occurrences()`).
#' @param min_year Integer. Minimum acceptable year. Default 1950.
#'
#' @return The same `tibble` with an additional `quality_flag` column.
#'   Possible values:
#'   \describe{
#'     \item{`"ok"`}{No issues detected.}
#'     \item{`"no_coords"`}{Missing coordinates.}
#'     \item{`"geospatial_issue"`}{`geospatialKosher == FALSE`.}
#'     \item{`"taxonomic_issue"`}{`taxonomicKosher == FALSE`.}
#'     \item{`"old_record"`}{Year before `min_year`.}
#'   }
#' @export
#' @examples
#' \dontrun{
#' df <- bdcr_occurrences("Panthera onca", rows = 50)
#' bdcr_quality_check(df)
#' }
bdcr_quality_check <- function(df, min_year = 1950) {
  if (!inherits(df, "data.frame") || nrow(df) == 0)
    cli::cli_abort("{.arg df} must be a non-empty data.frame.")

  df |>
    dplyr::mutate(
      quality_flag = dplyr::case_when(
        is.na(decimalLatitude) | is.na(decimalLongitude) ~ "no_coords",
        geospatialKosher == FALSE                         ~ "geospatial_issue",
        taxonomicKosher  == FALSE                         ~ "taxonomic_issue",
        !is.na(year) & year < min_year                   ~ "old_record",
        TRUE                                              ~ "ok"
      )
    )
}
