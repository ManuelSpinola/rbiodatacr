# Download occurrence records for multiple taxa

Download occurrence records for multiple taxa

## Usage

``` r
bdcr_occurrences_batch(taxa, rows = 100, wait = 1)
```

## Arguments

- taxa:

  Character vector. Scientific names.

- rows:

  Integer. Records per taxon. Default 100.

- wait:

  Numeric. Seconds to pause between requests. Default 1.

## Value

Named list of tibbles, one per taxon.

## Examples

``` r
if (FALSE) { # \dontrun{
spp <- c("Tapirus bairdii", "Panthera onca")
bdcr_occurrences_batch(spp, rows = 50)
} # }
```
