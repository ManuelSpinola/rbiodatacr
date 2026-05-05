#' Download occurrence records from BIODATACR
#'
#' @param taxon  Character. Scientific name of the taxon.
#' @param rows   Integer. Maximum number of records to download. Default 100.
#' @param start  Integer. Starting record for pagination. Default 0.
#'
#' @return A `tibble` with columns: `scientificName`, `vernacularName`,
#'   `decimalLatitude`, `decimalLongitude`, `year`, `month`,
#'   `basisOfRecord`, `dataResourceName`, `country`, `family`,
#'   `species`, `collector`, `license`, `geospatialKosher`,
#'   `taxonomicKosher`. Returns an empty `tibble` if the service is
#'   unavailable or no records are found.
#' @export
#' @examples
#' \dontrun{
#' bdcr_occurrences("Panthera onca", rows = 50)
#' }
bdcr_occurrences <- function(taxon, rows = 100, start = 0) {
  bdcr_check_string(taxon, "taxon")
  bdcr_check_count(rows, "rows")

  url  <- bdcr_url("occurrences/search")
  resp <- bdcr_GET(url, query = list(q = taxon, pageSize = rows, start = start))

  # bdcr_GET returns NULL when the service is unavailable
  if (is.null(resp)) return(dplyr::tibble())

  occs <- resp[["occurrences"]]

  if (is.null(occs) || nrow(occs) == 0) {
    cli::cli_inform("No records found for {.val {taxon}}.")
    return(dplyr::tibble())
  }

  occs |>
    dplyr::as_tibble() |>
    dplyr::select(
      dplyr::any_of(c(
        "scientificName", "vernacularName",
        "decimalLatitude", "decimalLongitude",
        "year", "month", "basisOfRecord", "dataResourceName",
        "country", "family", "species", "collector", "license",
        "geospatialKosher", "taxonomicKosher"
      ))
    ) |>
    dplyr::mutate(
      geospatialKosher = geospatialKosher == "true",
      taxonomicKosher  = taxonomicKosher  == "true"
    )
}
