# Descargar registros de ocurrencia de BIODATACR

Descargar registros de ocurrencia de BIODATACR

Descargar registros de ocurrencia de BIODATACR

## Usage

``` r
bdcr_occurrences(taxon, rows = 100, start = 0)

bdcr_occurrences(taxon, rows = 100, start = 0)
```

## Arguments

- taxon:

  Character. Nombre científico del taxón.

- rows:

  Entero. Número máximo de registros a descargar. Default 100.

- start:

  Entero. Registro desde el cual iniciar (paginación). Default 0.

## Value

\`tibble\` con columnas: \`scientificName\`, \`decimalLatitude\`,
\`decimalLongitude\`, \`coordinateUncertaintyInMeters\`, \`year\`,
\`month\`, \`basisOfRecord\`, \`dataResourceName\`,
\`geospatialKosher\`, \`taxonomicKosher\`.

\`tibble\` con columnas: \`scientificName\`, \`decimalLatitude\`,
\`decimalLongitude\`, \`coordinateUncertaintyInMeters\`, \`year\`,
\`month\`, \`basisOfRecord\`, \`dataResourceName\`,
\`geospatialKosher\`, \`taxonomicKosher\`.

## Examples

``` r
if (FALSE) { # \dontrun{
bdcr_occurrences("Tapirus bairdii", rows = 50)
} # }
if (FALSE) { # \dontrun{
bdcr_occurrences("Tapirus bairdii", rows = 50)
} # }
```
