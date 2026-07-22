# Download occurrence records for multiple taxa

Download occurrence records for multiple taxa

## Usage

``` r
bdcr_occurrences_batch(taxa, rows = 100, page_size = 300, wait = 1)
```

## Arguments

- taxa:

  Character vector. Scientific names.

- rows:

  Integer. Maximum records per taxon. Default 100, matching
  \[bdcr_occurrences()\]. Pass \`Inf\` to download every available
  record for each taxon; a message will report the true total for any
  taxon where the download is capped below it.

- page_size:

  Integer. Records requested per HTTP call within each taxon's
  pagination. Default 300.

- wait:

  Numeric. Seconds to pause between requests (both between taxa and
  between pages within a taxon). Default 1.

## Value

Named list of tibbles, one per taxon. If the service is unavailable for
a given taxon, the corresponding element will be an empty \`tibble\`.

## Examples

``` r
if (FALSE) { # \dontrun{
spp <- c("Tapirus bairdii", "Panthera onca")
bdcr_occurrences_batch(spp, rows = 50)
bdcr_occurrences_batch(spp, rows = Inf)  # descarga todos los registros
} # }
```
