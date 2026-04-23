#' Contar registros de ocurrencia para un taxón
#'
#' @param taxon Character. Nombre científico del taxón (e.g. `"Panthera onca"`).
#' @return Entero con el número total de registros.
#' @export
bdcr_count <- function(taxon) {
  bdcr_check_string(taxon, "taxon")
  url  <- bdcr_url("occurrences/search")
  resp <- bdcr_GET(url, query = list(q = taxon, pageSize = 0))
  resp[["totalRecords"]]
}

#' Descargar registros de ocurrencia de BIODATACR
#'
#' @param taxon  Character. Nombre científico del taxón.
#' @param rows   Entero. Número máximo de registros. Default 100.
#' @param start  Entero. Registro inicial para paginación. Default 0.
#' @return `tibble` con campos de ocurrencia.
#' @export
bdcr_occurrences <- function(taxon, rows = 100, start = 0) {
  bdcr_check_string(taxon, "taxon")
  bdcr_check_count(rows, "rows")

  url  <- bdcr_url("occurrences/search")
  resp <- bdcr_GET(url, query = list(q = taxon, pageSize = rows, start = start))

  occs <- resp[["occurrences"]]

  if (is.null(occs) || nrow(occs) == 0) {
    cli::cli_inform("No se encontraron registros para {.val {taxon}}.")
    return(dplyr::tibble())
  }

  occs |>
    dplyr::as_tibble() |>
    dplyr::select(
      scientificName, vernacularName,
      decimalLatitude, decimalLongitude,
      year, month, basisOfRecord, dataResourceName,
      country, family, species, collector, license,
      geospatialKosher, taxonomicKosher
    ) |>
    dplyr::mutate(
      geospatialKosher = geospatialKosher == "true",
      taxonomicKosher  = taxonomicKosher  == "true"
    )
}

#' Descargar ocurrencias para múltiples taxones
#'
#' @param taxa  Character vector. Nombres científicos.
#' @param rows  Entero. Registros por taxón. Default 100.
#' @param wait  Numeric. Segundos de pausa entre consultas. Default 1.
#' @return Lista nombrada de tibbles.
#' @export
bdcr_occurrences_batch <- function(taxa, rows = 100, wait = 1) {
  if (!is.character(taxa) || length(taxa) == 0)
    cli::cli_abort("{.arg taxa} debe ser un character vector no vacío.")
  bdcr_check_count(rows, "rows")

  resultados <- vector("list", length(taxa))
  names(resultados) <- taxa

  for (i in seq_along(taxa)) {
    cli::cli_progress_step("Descargando {taxa[[i]]} ({i}/{length(taxa)})")
    resultados[[i]] <- bdcr_occurrences(taxa[[i]], rows = rows)
    if (i < length(taxa)) bdcr_polite_wait(wait)
  }
  resultados
}

#' Contar registros para múltiples taxones
#'
#' @param taxa Character vector. Nombres científicos.
#' @param wait Numeric. Segundos de pausa entre consultas. Default 1.
#' @return `tibble` con columnas `taxon` y `n_records`.
#' @export
bdcr_count_batch <- function(taxa, wait = 1) {
  if (!is.character(taxa) || length(taxa) == 0)
    cli::cli_abort("{.arg taxa} debe ser un character vector no vacío.")

  purrr::imap_dfr(taxa, function(sp, i) {
    cli::cli_progress_step("Contando {sp} ({i}/{length(taxa)})")
    n <- tryCatch(bdcr_count(sp), error = function(e) NA_integer_)
    if (i < length(taxa)) bdcr_polite_wait(wait)
    dplyr::tibble(taxon = sp, n_records = n)
  })
}
