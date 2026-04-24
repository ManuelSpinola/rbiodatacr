test_that("bdcr_url construye URLs correctamente", {
  expect_equal(
    rbiodatacr:::bdcr_url("occurrences/search"),
    "http://datos.biodiversidad.go.cr/biocache-service/occurrences/search"
  )
})

test_that("bdcr_check_string rechaza valores inválidos", {
  expect_error(rbiodatacr:::bdcr_check_string(""))
  expect_error(rbiodatacr:::bdcr_check_string(123))
  expect_error(rbiodatacr:::bdcr_check_string(NA_character_))
  expect_silent(rbiodatacr:::bdcr_check_string("Panthera onca"))
})

test_that("bdcr_check_count rechaza valores inválidos", {
  expect_error(rbiodatacr:::bdcr_check_count(0))
  expect_error(rbiodatacr:::bdcr_check_count(-5))
  expect_error(rbiodatacr:::bdcr_check_count("10"))
  expect_silent(rbiodatacr:::bdcr_check_count(100))
})
