#' Download occurrence records for multiple taxa
#'
#' @param taxa      Character vector. Scientific names.
#' @param rows      Integer. Maximum records per taxon. Default 100,
#'   matching [bdcr_occurrences()]. Pass `Inf` to download every
#'   available record for each taxon; a message will report the true
#'   total for any taxon where the download is capped below it.
#' @param page_size Integer. Records requested per HTTP call within each
#'   taxon's pagination. Default 300.
#' @param wait      Numeric. Seconds to pause between requests (both
#'   between taxa and between pages within a taxon). Default 1.
#'
#' @return Named list of tibbles, one per taxon. If the service is unavailable
#'   for a given taxon, the corresponding element will be an empty `tibble`.
#' @export
#' @examples
#' \dontrun{
#' spp <- c("Tapirus bairdii", "Panthera onca")
#' bdcr_occurrences_batch(spp, rows = 50)
#' bdcr_occurrences_batch(spp, rows = Inf)  # descarga todos los registros
#' }
bdcr_occurrences_batch <- function(taxa, rows = 100, page_size = 300, wait = 1) {
  if (!is.character(taxa) || length(taxa) == 0)
    cli::cli_abort("{.arg taxa} must be a non-empty character vector.")
  if (is.finite(rows)) bdcr_check_count(rows, "rows")

  resultados <- vector("list", length(taxa))
  names(resultados) <- taxa

  n <- length(taxa)

  for (i in seq_along(taxa)) {
    sp <- taxa[[i]]
    # Congelamos el texto ya resuelto (sin llaves pendientes) para evitar que
    # cli_progress_step reinterprete `i`/`sp` de forma diferida; lo llamamos
    # directamente en el entorno del loop (no dentro de local()) para que
    # cli pueda asociar correctamente el inicio y el final del paso.
    msg <- sprintf("Downloading %s (%d/%d)", sp, i, n)
    cli::cli_progress_step(msg)

    resultados[[i]] <- tryCatch(
      bdcr_occurrences(sp, rows = rows, page_size = page_size, wait = wait),
      error = function(e) {
        cli::cli_inform(c("!" = "Failed for {sp}: {conditionMessage(e)}"))
        dplyr::tibble()
      }
    )
    if (i < n) bdcr_polite_wait(wait)
  }

  resultados
}
