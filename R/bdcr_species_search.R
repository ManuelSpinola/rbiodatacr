#' Search for taxonomic information of a species in BIODATACR
#'
#' Queries the BIE (Biodiversity Information Explorer) index of BIODATACR
#' to retrieve taxonomic information for a species.
#'
#' @param name  Character. Scientific name (may be a synonym or partial name).
#' @param rows  Integer. Maximum number of results. Default 10.
#'
#' @return A `tibble` with columns: `name`, `guid`, `commonName`,
#'   `scientificName`, `rank`, `taxonomicStatus`, `nameComplete`.
#' @export
#' @examples
#' \dontrun{
#' bdcr_species_search("Panthera onca")
#' }
bdcr_species_search <- function(name, rows = 10) {
  bdcr_check_string(name, "name")
  bdcr_check_count(rows, "rows")

  url  <- paste0(BDCR_BIE_URL, "/search")
  resp <- bdcr_GET(url, query = list(q = name, pageSize = rows))

  resultados <- resp[["searchResults"]][["results"]]

  if (is.null(resultados) || nrow(resultados) == 0) {
    cli::cli_inform("No results found for {.val {name}}.")
    return(dplyr::tibble())
  }

  resultados |>
    dplyr::as_tibble() |>
    dplyr::select(
      name, guid, commonName, scientificName,
      rank, taxonomicStatus, nameComplete
    )
}
