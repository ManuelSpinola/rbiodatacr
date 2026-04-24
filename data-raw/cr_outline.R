## code to prepare `cr_outline` dataset goes here

cr_outline <- geodata::gadm("CRI", level = 0, path = tempdir()) |>
  sf::st_as_sf()

usethis::use_data(cr_outline, overwrite = TRUE)
