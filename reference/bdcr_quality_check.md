# Verificar calidad de registros de ocurrencia

Agrega una columna \`quality_flag\` al tibble de ocurrencias.

## Usage

``` r
bdcr_quality_check(df, min_year = 1950)
```

## Arguments

- df:

  \`tibble\` de ocurrencias (salida de \`bdcr_occurrences()\`).

- min_year:

  Entero. Año mínimo aceptable. Default 1950.

- max_uncertainty:

  Numeric. Umbral en metros para coordenadas imprecisas. Default 10 000
  m.

## Value

El mismo \`tibble\` con columna adicional \`quality_flag\`. Los valores
posibles son: \`"ok"\`, \`"no_coords"\`, \`"high_uncertainty"\`,
\`"taxonomic_issue"\`, \`"old_record"\`.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- bdcr_occurrences("Panthera onca", rows = 50)
bdcr_quality_check(df)
} # }
```
