# Quality check for occurrence records

Adds a \`quality_flag\` column to an occurrence tibble. Requires that
\`geospatialKosher\` and \`taxonomicKosher\` are logical — a condition
guaranteed by \`bdcr_occurrences()\`.

## Usage

``` r
bdcr_quality_check(df, min_year = 1950)
```

## Arguments

- df:

  A \`tibble\` of occurrence records (output of \`bdcr_occurrences()\`).

- min_year:

  Integer. Minimum acceptable year. Default 1950.

## Value

The same \`tibble\` with an additional \`quality_flag\` column. Possible
values:

- \`"ok"\`:

  No issues detected.

- \`"no_coords"\`:

  Missing coordinates.

- \`"geospatial_issue"\`:

  \`geospatialKosher == FALSE\`.

- \`"taxonomic_issue"\`:

  \`taxonomicKosher == FALSE\`.

- \`"old_record"\`:

  Year before \`min_year\`.

## Examples

``` r
if (FALSE) { # \dontrun{
df <- bdcr_occurrences("Panthera onca", rows = 50)
bdcr_quality_check(df)
} # }
```
