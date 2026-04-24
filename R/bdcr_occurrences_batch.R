#' Download occurrence records for multiple taxa
#'
#' @param taxa  Character vector. Scientific names.
#' @param rows  Integer. Records per taxon. Default 100.
#' @param wait  Numeric. Seconds to pause between requests. Default 1.
#'
#' @return Named list of tibbles, one per taxon.
#' @export
#' @examples
#' \dontrun{
#' spp <- c("Tapirus bairdii", "Panthera onca")
#' bdcr_occurrences_batch(spp, rows = 50)
#' }
bdcr_occurrences_batch <- function(taxa, rows = 100, wait = 1) {
  if (!is.character(taxa) || length(taxa) == 0)
    cli::cli_abort("{.arg taxa} must be a non-empty character vector.")
  bdcr_check_count(rows, "rows")

  resultados <- vector("list", length(taxa))
  names(resultados) <- taxa

  for (i in seq_along(taxa)) {
    cli::cli_progress_step("Downloading {taxa[[i]]} ({i}/{length(taxa)})")
    resultados[[i]] <- bdcr_occurrences(taxa[[i]], rows = rows)
    if (i < length(taxa)) bdcr_polite_wait(wait)
  }

  resultados
}
