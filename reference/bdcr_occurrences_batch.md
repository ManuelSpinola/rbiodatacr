# Descargar ocurrencias para múltiples taxones

Descargar ocurrencias para múltiples taxones

## Usage

``` r
bdcr_occurrences_batch(taxa, rows = 100, wait = 1)
```

## Arguments

- taxa:

  Character vector. Nombres científicos.

- rows:

  Entero. Registros por taxón. Default 100.

- wait:

  Numeric. Segundos de pausa entre consultas. Default 1.

## Value

Lista nombrada de tibbles (uno por taxón).

## Examples

``` r
if (FALSE) { # \dontrun{
spp <- c("Tapirus bairdii", "Panthera onca", "Baird's tapir")
datos <- bdcr_occurrences_batch(spp, rows = 50)
} # }
```
