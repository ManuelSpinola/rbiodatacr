# Count occurrence records for a taxon

Count occurrence records for a taxon

## Usage

``` r
bdcr_count(taxon)
```

## Arguments

- taxon:

  Character. Scientific name (e.g. \`"Panthera onca"\`).

## Value

Integer with the total number of available records, or \`NA_integer\_\`
if the service is unavailable.

## Examples

``` r
if (FALSE) { # \dontrun{
bdcr_count("Panthera onca")
} # }
```
