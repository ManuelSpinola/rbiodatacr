# Download occurrence records from BIODATACR

Download occurrence records from BIODATACR

## Usage

``` r
bdcr_occurrences(taxon, rows = 100, start = 0, page_size = 300, wait = 1)
```

## Arguments

- taxon:

  Character. Scientific name of the taxon.

- rows:

  Integer. Maximum number of records to download. Default 100. Pass
  \`Inf\` (or the taxon's true total, e.g. from \[bdcr_count()\]) to
  download every available record, paginating as needed. If fewer
  records are downloaded than actually exist, an informative message
  reports the true total so the result is never mistaken for the
  complete dataset.

- start:

  Integer. Starting record for pagination. Default 0.

- page_size:

  Integer. Records requested per HTTP call. Default 300. Kept below
  \`rows\` and used to chunk large downloads into several polite
  requests instead of one giant one.

- wait:

  Numeric. Seconds to pause between paginated requests (only relevant
  when more than one page is needed). Default 1.

## Value

A \`tibble\` with columns: \`scientificName\`, \`vernacularName\`,
\`decimalLatitude\`, \`decimalLongitude\`, \`year\`, \`month\`,
\`basisOfRecord\`, \`dataResourceName\`, \`country\`, \`family\`,
\`species\`, \`collector\`, \`license\`, \`geospatialKosher\`,
\`taxonomicKosher\`. Returns an empty \`tibble\` if the service is
unavailable or no records are found.

## Examples

``` r
if (FALSE) { # \dontrun{
bdcr_occurrences("Panthera onca", rows = 50)
bdcr_occurrences("Panthera onca")        # primeros 100 (default)
bdcr_occurrences("Panthera onca", rows = Inf)  # todos los registros
} # }
```
