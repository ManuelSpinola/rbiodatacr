# R/utils.R
# Internal infrastructure functions for rbiodatacr
# Not exported — internal use only

# Suppress R CMD check notes for dplyr column names
utils::globalVariables(c(
  "scientificName", "vernacularName",
  "decimalLatitude", "decimalLongitude",
  "year", "month", "basisOfRecord", "dataResourceName",
  "country", "family", "species", "collector", "license",
  "geospatialKosher", "taxonomicKosher",
  "guid", "commonName", "taxonomicStatus", "nameComplete",
  "quality_flag", "n_records"
))

# -- Constants -----------------------------------------------------------------

BDCR_BASE_URL <- "http://datos.biodiversidad.go.cr/biocache-service"
BDCR_BIE_URL  <- "http://datos.biodiversidad.go.cr/bie-index"

# -- URL builder ---------------------------------------------------------------

#' Build full URL for a BIODATACR biocache endpoint
#'
#' @param endpoint Character. Relative path, e.g. `"occurrences/search"`.
#' @return Character with the full URL.
#' @noRd
bdcr_url <- function(endpoint) {
  paste0(BDCR_BASE_URL, "/", endpoint)
}

# -- HTTP client ---------------------------------------------------------------

#' Perform a GET request to the BIODATACR API
#'
#' Wraps `httr::GET()` with network error handling, HTTP status checking,
#' and automatic JSON parsing. Returns `NULL` invisibly (with a message)
#' when the server is unavailable, so callers can fail gracefully.
#'
#' @param url     Character. Full endpoint URL.
#' @param query   Named list of query parameters. Default `list()`.
#' @param timeout Numeric. Seconds before aborting the connection. Default `60`.
#'
#' @return Parsed list from the JSON response, or `NULL` if the server is
#'   unavailable or returns a non-200 status.
#' @noRd
bdcr_GET <- function(url, query = list(), timeout = 60) {

  # -- Network request: catch connection errors --------------------------------
  resp <- tryCatch(
    httr::GET(
      url,
      query = query,
      httr::timeout(timeout),
      httr::user_agent(
        "rbiodatacr/0.1.0 (https://github.com/ManuelSpinola/rbiodatacr)"
      )
    ),
    error = function(e) {
      # Return NULL with an informative message instead of stopping
      cli::cli_inform(
        c("!" = "Could not connect to the BIODATACR service.",
          "i" = "Please check your internet connection.",
          "i" = "The service may be temporarily unavailable.",
          "x" = conditionMessage(e))
      )
      NULL
    }
  )

  # Propagate NULL from connection failure
  if (is.null(resp)) return(invisible(NULL))

  # -- HTTP status check -------------------------------------------------------
  status <- httr::status_code(resp)
  if (status != 200L) {
    cli::cli_inform(
      c("!" = "BIODATACR returned HTTP {status}.",
        "i" = "The service may be temporarily unavailable.",
        "i" = "URL: {url}")
    )
    return(invisible(NULL))
  }

  # -- Content-type check ------------------------------------------------------
  ct <- httr::headers(resp)[["content-type"]]
  if (is.null(ct) || !grepl("json", ct, ignore.case = TRUE)) {
    cli::cli_inform(
      c("!" = "Unexpected content-type from BIODATACR: {ct}.",
        "i" = "URL: {url}")
    )
    return(invisible(NULL))
  }

  # -- JSON parsing ------------------------------------------------------------
  raw_text <- httr::content(resp, as = "text", encoding = "UTF-8")
  parsed   <- tryCatch(
    jsonlite::fromJSON(raw_text, simplifyVector = TRUE),
    error = function(e) {
      cli::cli_inform(
        c("!" = "Could not parse BIODATACR JSON response.",
          "x" = conditionMessage(e))
      )
      NULL
    }
  )

  parsed
}

# -- Polite pause --------------------------------------------------------------

#' Pause between API requests
#'
#' Adds a pause of at least `seconds` seconds to avoid overloading the server.
#'
#' @param seconds Numeric. Seconds to wait. Default `1`.
#' @noRd
bdcr_polite_wait <- function(seconds = 1) {
  Sys.sleep(seconds)
}

# -- Argument validation -------------------------------------------------------

#' Check that an argument is a non-empty character string
#'
#' @param x   Object to check.
#' @param arg Argument name (used in error message).
#' @noRd
bdcr_check_string <- function(x, arg = deparse(substitute(x))) {
  if (!is.character(x) || length(x) != 1L || nchar(trimws(x)) == 0L) {
    cli::cli_abort(
      "{.arg {arg}} must be a non-empty character string of length 1.",
      call = NULL
    )
  }
  invisible(x)
}

#' Check that an argument is a positive integer
#'
#' @param x   Object to check.
#' @param arg Argument name (used in error message).
#' @noRd
bdcr_check_count <- function(x, arg = deparse(substitute(x))) {
  if (!is.numeric(x) || length(x) != 1L || x < 1L || x != as.integer(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a positive integer.",
      call = NULL
    )
  }
  invisible(as.integer(x))
}
