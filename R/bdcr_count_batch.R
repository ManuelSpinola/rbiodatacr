#' Count occurrence records for multiple taxa
#'
#' @param taxa Character vector. Scientific names.
#' @param wait Numeric. Seconds to pause between requests. Default 1.
#'
#' @return A `tibble` with columns `taxon` and `n_records`.
#' @export
#' @examples
#' \dontrun{
#' spp <- c("Tapirus bairdii", "Panthera onca")
#' bdcr_count_batch(spp)
#' }
bdcr_count_batch <- function(taxa, wait = 1) {
  if (!is.character(taxa) || length(taxa) == 0)
    cli::cli_abort("{.arg taxa} must be a non-empty character vector.")

  purrr::imap_dfr(taxa, function(sp, i) {
    cli::cli_progress_step("Counting {sp} ({i}/{length(taxa)})")
    n <- tryCatch(bdcr_count(sp), error = function(e) NA_integer_)
    if (i < length(taxa)) bdcr_polite_wait(wait)
    dplyr::tibble(taxon = sp, n_records = n)
  })
}
