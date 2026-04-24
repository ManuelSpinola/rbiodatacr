# Contar registros para múltiples taxones

Contar registros para múltiples taxones

## Usage

``` r
bdcr_count_batch(taxa, wait = 1)
```

## Arguments

- taxa:

  Character vector. Nombres científicos.

- wait:

  Numeric. Segundos de pausa entre consultas. Default 1.

## Value

\`tibble\` con columnas \`taxon\` y \`n_records\`.
