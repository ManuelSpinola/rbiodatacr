#' Count occurrence records for a taxon
#'
#' @param taxon Character. Scientific name (e.g. `"Panthera onca"`).
#' @return Integer with the total number of available records, or `NA_integer_`
#'   if the service is unavailable.
#' @export
#' @examples
#' \dontrun{
#' bdcr_count("Panthera onca")
#' }
bdcr_count <- function(taxon) {
  bdcr_check_string(taxon, "taxon")
  url  <- bdcr_url("occurrences/search")
  resp <- bdcr_GET(url, query = list(q = taxon, pageSize = 0))

  # bdcr_GET returns NULL when the service is unavailable
  if (is.null(resp)) return(NA_integer_)

  resp[["totalRecords"]]
}
