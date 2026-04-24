# Count occurrence records for multiple taxa

Count occurrence records for multiple taxa

## Usage

``` r
bdcr_count_batch(taxa, wait = 1)
```

## Arguments

- taxa:

  Character vector. Scientific names.

- wait:

  Numeric. Seconds to pause between requests. Default 1.

## Value

A \`tibble\` with columns \`taxon\` and \`n_records\`.

## Examples

``` r
if (FALSE) { # \dontrun{
spp <- c("Tapirus bairdii", "Panthera onca")
bdcr_count_batch(spp)
} # }
```
