test_that("bdcr_quality_check etiqueta coordenadas ausentes", {
  df <- dplyr::tibble(
    decimalLatitude  = NA_real_,
    decimalLongitude = NA_real_,
    geospatialKosher = TRUE,
    taxonomicKosher  = TRUE,
    year             = 2020
  )
  expect_equal(bdcr_quality_check(df)$quality_flag, "no_coords")
})

test_that("bdcr_quality_check marca registros limpios como ok", {
  df <- dplyr::tibble(
    decimalLatitude  = 9.5,
    decimalLongitude = -84.0,
    geospatialKosher = TRUE,
    taxonomicKosher  = TRUE,
    year             = 2020
  )
  expect_equal(bdcr_quality_check(df)$quality_flag, "ok")
})
