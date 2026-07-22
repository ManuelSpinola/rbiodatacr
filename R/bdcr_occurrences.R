#' Download occurrence records from BIODATACR
#'
#' @param taxon     Character. Scientific name of the taxon.
#' @param rows      Integer. Maximum number of records to download.
#'   Default 100. Pass `Inf` (or the taxon's true total, e.g. from
#'   [bdcr_count()]) to download every available record, paginating as
#'   needed. If fewer records are downloaded than actually exist, an
#'   informative message reports the true total so the result is never
#'   mistaken for the complete dataset.
#' @param start     Integer. Starting record for pagination. Default 0.
#' @param page_size Integer. Records requested per HTTP call. Default 300.
#'   Kept below `rows` and used to chunk large downloads into several
#'   polite requests instead of one giant one.
#' @param wait      Numeric. Seconds to pause between paginated requests
#'   (only relevant when more than one page is needed). Default 1.
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
#' bdcr_occurrences("Panthera onca")        # primeros 100 (default)
#' bdcr_occurrences("Panthera onca", rows = Inf)  # todos los registros
#' }
bdcr_occurrences <- function(taxon, rows = 100, start = 0, page_size = 300, wait = 1) {
  bdcr_check_string(taxon, "taxon")
  if (is.finite(rows)) bdcr_check_count(rows, "rows")
  bdcr_check_count(page_size, "page_size")

  url <- bdcr_url("occurrences/search")

  # First request: also tells us totalRecords, the true count for this taxon
  first_size <- if (is.finite(rows)) min(rows, page_size) else page_size
  resp <- bdcr_GET(url, query = list(q = taxon, pageSize = first_size, start = start))

  # bdcr_GET returns NULL when the service is unavailable
  if (is.null(resp)) return(dplyr::tibble())

  total <- resp[["totalRecords"]]
  if (is.null(total) || total == 0) {
    cli::cli_inform("No records found for {.val {taxon}}.")
    return(dplyr::tibble())
  }

  # Target = the smaller of what the user asked for and what actually exists
  target <- if (is.finite(rows)) min(rows, total) else total

  paginas   <- list()
  occs      <- resp[["occurrences"]]
  fetched   <- if (is.null(occs)) 0L else nrow(occs)
  if (fetched > 0) paginas[[1]] <- occs
  current_start <- start + fetched

  while (fetched < target) {
    faltan     <- target - fetched
    this_size  <- min(page_size, faltan)

    bdcr_polite_wait(wait)
    resp_i <- bdcr_GET(url, query = list(q = taxon, pageSize = this_size, start = current_start))
    if (is.null(resp_i)) break  # service dropped mid-pagination; return what we have

    occs_i <- resp_i[["occurrences"]]
    n_i    <- if (is.null(occs_i)) 0L else nrow(occs_i)
    if (n_i == 0) break

    paginas[[length(paginas) + 1]] <- occs_i
    fetched       <- fetched + n_i
    current_start <- current_start + n_i

    if (n_i < this_size) break  # server ran out of records before we expected
  }

  if (length(paginas) == 0) {
    cli::cli_inform("No records found for {.val {taxon}}.")
    return(dplyr::tibble())
  }

  if (fetched < total) {
    cli::cli_inform(c(
      "i" = "{.val {taxon}} has {total} record{?s} in total; downloaded {fetched}.",
      "i" = "Use {.code rows = Inf} (or {.code rows = {total}}) to download all of them."
    ))
  }

  dplyr::bind_rows(paginas) |>
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
