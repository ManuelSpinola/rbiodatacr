# Buscar información taxonómica de una especie en BIODATACR

Buscar información taxonómica de una especie en BIODATACR

## Usage

``` r
bdcr_species_search(name, rows = 10)
```

## Arguments

- name:

  Character. Nombre científico (puede ser sinónimo o parcial).

- rows:

  Entero. Número máximo de resultados. Default 10.

## Value

\`tibble\` con columnas: \`name\`, \`guid\`, \`commonName\`,
\`scientificName\`, \`rank\`, \`kingdom\`, \`family\`,
\`occurrenceCount\`.

## Examples

``` r
if (FALSE) { # \dontrun{
bdcr_species_search("Panthera onca")
} # }
```
