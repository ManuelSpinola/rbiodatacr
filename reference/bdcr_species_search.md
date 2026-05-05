# Search for taxonomic information of a species in BIODATACR

Queries the BIE (Biodiversity Information Explorer) index of BIODATACR
to retrieve taxonomic information for a species.

## Usage

``` r
bdcr_species_search(name, rows = 10)
```

## Arguments

- name:

  Character. Scientific name (may be a synonym or partial name).

- rows:

  Integer. Maximum number of results. Default 10.

## Value

A \`tibble\` with columns: \`name\`, \`guid\`, \`commonName\`,
\`scientificName\`, \`rank\`, \`taxonomicStatus\`, \`nameComplete\`.
Returns an empty \`tibble\` if the service is unavailable or no results
are found.

## Examples

``` r
if (FALSE) { # \dontrun{
bdcr_species_search("Panthera onca")
} # }
```
