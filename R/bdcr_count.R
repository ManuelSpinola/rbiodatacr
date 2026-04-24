#' Count occurrence records for a taxon
#'
#' @param taxon Character. Scientific name (e.g. `"Panthera onca"`).
#' @return Integer with the total number of available records.
#' @export
#' @examples
#' \dontrun{
#' bdcr_count("Panthera onca")
#' }
bdcr_count <- function(taxon) {
  bdcr_check_string(taxon, "taxon")
  url  <- bdcr_url("occurrences/search")
  resp <- bdcr_GET(url, query = list(q = taxon, pageSize = 0))
  resp[["totalRecords"]]
}
