#' Verificar calidad de registros de ocurrencia
#'
#' Agrega una columna `quality_flag` al tibble de ocurrencias.
#'
#' @param df              `tibble` de ocurrencias (salida de `bdcr_occurrences()`).
#' @param max_uncertainty Numeric. Umbral en metros para coordenadas imprecisas.
#'   Default 10 000 m.
#' @param min_year        Entero. Año mínimo aceptable. Default 1950.
#'
#' @return El mismo `tibble` con columna adicional `quality_flag`. Los valores
#'   posibles son: `"ok"`, `"no_coords"`, `"high_uncertainty"`,
#'   `"taxonomic_issue"`, `"old_record"`.
#' @export
#' @examples
#' \dontrun{
#' df <- bdcr_occurrences("Panthera onca", rows = 50)
#' bdcr_quality_check(df)
#' }
bdcr_quality_check <- function(df,
                               min_year = 1950) {
  if (!inherits(df, "data.frame") || nrow(df) == 0)
    cli::cli_abort("{.arg df} debe ser un data.frame no vacío.")

  df |>
    dplyr::mutate(
      quality_flag = dplyr::case_when(
        is.na(decimalLatitude) | is.na(decimalLongitude) ~ "no_coords",
        geospatialKosher == FALSE                         ~ "geospatial_issue",
        taxonomicKosher  == FALSE                         ~ "taxonomic_issue",
        !is.na(year) & year < min_year                   ~ "old_record",
        TRUE                                              ~ "ok"
      )
    )
}
