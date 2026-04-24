# rbiodatacr

`rbiodatacr` es un cliente R para consultar
[BIODATACR](https://biodiversidad.go.cr), la plataforma nacional de
información sobre biodiversidad de Costa Rica gestionada por la Oficina
Técnica de CONAGEBIO. Desarrollado en el marco de la consultoría IUCN
*Enlazando el Paisaje Centroamericano*.

## Instalación

``` r
remotes::install_github("ManuelSpinola/rbiodatacr")
```

## Funciones principales

| Función                                                                                                      | Descripción                                   |
|--------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| [`bdcr_count()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_count.md)                         | Cuenta registros disponibles para un taxón    |
| [`bdcr_count_batch()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_count_batch.md)             | Cuenta registros para varios taxones          |
| [`bdcr_occurrences()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_occurrences.md)             | Descarga registros de ocurrencia de un taxón  |
| [`bdcr_occurrences_batch()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_occurrences_batch.md) | Descarga registros para varios taxones        |
| [`bdcr_species_search()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_species_search.md)       | Busca información taxonómica en el índice BIE |
| [`bdcr_quality_check()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_quality_check.md)         | Evalúa calidad de registros y asigna flags    |

## Uso básico

``` r
library(rbiodatacr)

# Verificar disponibilidad de datos
bdcr_count("Panthera onca")
```

``` r
# Descargar registros de ocurrencia
df <- bdcr_occurrences("Panthera onca", rows = 50)
dplyr::glimpse(df)
```

``` r
# Consulta para varias especies
especies <- c("Tapirus bairdii", "Panthera onca", "Ara ambiguus")
conteos  <- bdcr_count_batch(especies)
conteos
```

``` r
# Control de calidad
df_qc <- bdcr_quality_check(df)
dplyr::count(df_qc, quality_flag, sort = TRUE)
```

## Flujo de trabajo completo

``` r
library(rbiodatacr)
library(dplyr)

# 1. Explorar disponibilidad
especies <- c("Tapirus bairdii", "Panthera onca",
              "Ara ambiguus",    "Bradypus variegatus")

conteos <- bdcr_count_batch(especies)

# 2. Descargar especies con datos suficientes
con_datos <- filter(conteos, n_records >= 10)

lista_occ <- bdcr_occurrences_batch(
  taxa = con_datos$taxon,
  rows = 200
)

# 3. Control de calidad y consolidar
df_final <- purrr::map(lista_occ, bdcr_quality_check) |>
  bind_rows(.id = "taxon") |>
  filter(quality_flag == "ok",
         !is.na(decimalLatitude),
         !is.na(decimalLongitude))

# 4. Resumen
df_final |>
  count(taxon, sort = TRUE) |>
  rename(registros_limpios = n)
```

## Sobre BIODATACR

BIODATACR está construido sobre la infraestructura del [Atlas of Living
Australia (ALA)](https://www.ala.org.au/).

## Licencia

MIT © Manuel Spinola
