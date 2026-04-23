#' Buscar información taxonómica de una especie en BIODATACR
#'
#' @param name  Character. Nombre científico (puede ser sinónimo o parcial).
#' @param rows  Entero. Número máximo de resultados. Default 10.
#'
#' @return `tibble` con columnas: `name`, `guid`, `commonName`,
#'   `scientificName`, `rank`, `kingdom`, `family`, `occurrenceCount`.
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
    cli::cli_inform("No se encontraron resultados para {.val {name}}.")
    return(dplyr::tibble())
  }

  resultados |>
    dplyr::as_tibble() |>
    dplyr::select(
      name, guid, commonName, scientificName,
      rank, taxonomicStatus, nameComplete
    )
}
