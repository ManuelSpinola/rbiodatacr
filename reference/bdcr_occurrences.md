# Download occurrence records from BIODATACR

Download occurrence records from BIODATACR

## Usage

``` r
bdcr_occurrences(taxon, rows = 100, start = 0)
```

## Arguments

- taxon:

  Character. Scientific name of the taxon.

- rows:

  Integer. Maximum number of records to download. Default 100.

- start:

  Integer. Starting record for pagination. Default 0.

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
} # }
```
