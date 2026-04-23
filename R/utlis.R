# R/utils.R
# Funciones internas de infraestructura para rbiodatacr
# No exportadas — uso interno únicamente

# ── Constantes ────────────────────────────────────────────────────────────────

#' @noRd
BDCR_BASE_URL <- "http://datos.biodiversidad.go.cr/biocache-service"


# ── Construcción de URL ───────────────────────────────────────────────────────

#' Construir URL completa para un endpoint de BIODATACR
#'
#' @param endpoint Character. Ruta relativa, e.g. `"occurrences/search"`.
#' @return Character con la URL completa.
#' @noRd
bdcr_url <- function(endpoint) {
  paste0(BDCR_BASE_URL, "/", endpoint)
}


# ── Cliente HTTP ──────────────────────────────────────────────────────────────

#' Realizar una petición GET al API de BIODATACR
#'
#' Envuelve `httr::GET()` con manejo de errores HTTP y de red,
#' y parsea automáticamente la respuesta JSON.
#'
#' @param url     Character. URL completa del endpoint.
#' @param query   Lista nombrada de parámetros query. Default `list()`.
#' @param timeout Numeric. Segundos antes de abortar la conexión. Default `60`.
#'
#' @return Lista parseada desde el JSON de respuesta.
#' @noRd
bdcr_GET <- function(url, query = list(), timeout = 60) {

  # Petición
  resp <- tryCatch(
    httr::GET(
      url,
      query = query,
      httr::timeout(timeout),
      httr::user_agent("rbiodatacr/0.1.0 (https://github.com/ManuelSpinola/rbiodatacr)")
    ),
    error = function(e) {
      cli::cli_abort(
        c("No se pudo conectar con BIODATACR.",
          "i" = "Verifique su conexión a internet.",
          "x" = conditionMessage(e)),
        call = NULL
      )
    }
  )

  # Verificar código HTTP
  status <- httr::status_code(resp)
  if (status != 200L) {
    cli::cli_abort(
      c("El servidor de BIODATACR retornó un error HTTP {status}.",
        "i" = "URL consultada: {url}"),
      call = NULL
    )
  }

  # Verificar que el content-type sea JSON
  ct <- httr::headers(resp)[["content-type"]]
  if (!grepl("json", ct, ignore.case = TRUE)) {
    cli::cli_abort(
      c("La respuesta no es JSON (content-type: {ct}).",
        "i" = "URL consultada: {url}"),
      call = NULL
    )
  }

  # Parsear JSON
  raw_text <- httr::content(resp, as = "text", encoding = "UTF-8")
  parsed   <- tryCatch(
    jsonlite::fromJSON(raw_text, simplifyVector = FALSE),
    error = function(e) {
      cli::cli_abort(
        c("No se pudo parsear la respuesta JSON de BIODATACR.",
          "x" = conditionMessage(e)),
        call = NULL
      )
    }
  )

  parsed
}


# ── Pausa cortés ──────────────────────────────────────────────────────────────

#' Pausa mínima entre consultas al API
#'
#' Agrega una pausa de al menos `seconds` segundos para no saturar el servidor.
#'
#' @param seconds Numeric. Segundos a esperar. Default `1`.
#' @noRd
bdcr_polite_wait <- function(seconds = 1) {
  Sys.sleep(seconds)
}


# ── Validación de argumentos ──────────────────────────────────────────────────

#' Verificar que un argumento sea character no vacío
#'
#' @param x     El objeto a verificar.
#' @param arg   Nombre del argumento (para mensaje de error).
#' @noRd
bdcr_check_string <- function(x, arg = deparse(substitute(x))) {
  if (!is.character(x) || length(x) != 1L || nchar(trimws(x)) == 0L) {
    cli::cli_abort(
      "{.arg {arg}} debe ser un character de longitud 1 no vacío.",
      call = NULL
    )
  }
  invisible(x)
}

#' Verificar que un argumento sea numérico positivo
#'
#' @param x     El objeto a verificar.
#' @param arg   Nombre del argumento (para mensaje de error).
#' @noRd
bdcr_check_count <- function(x, arg = deparse(substitute(x))) {
  if (!is.numeric(x) || length(x) != 1L || x < 1L || x != as.integer(x)) {
    cli::cli_abort(
      "{.arg {arg}} debe ser un entero positivo.",
      call = NULL
    )
  }
  invisible(as.integer(x))
}
