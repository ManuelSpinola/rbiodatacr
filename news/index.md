# Changelog

## rbiodatacr 0.1.1

CRAN release: 2026-05-05

- Fixed graceful failure when the BIODATACR API is unavailable or
  returns a non-200 HTTP status. Functions now return an empty tibble or
  `NA_integer_` with an informative message instead of throwing an
  error, in compliance with CRAN policy on internet resources.
- Fixed
  [`bdcr_occurrences()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_occurrences.md)
  (and
  [`bdcr_occurrences_batch()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_occurrences_batch.md))
  silently truncating results at 100 records regardless of how many were
  actually available. Both functions now paginate correctly to retrieve
  the requested number of records (or all of them, with `rows = Inf`),
  and report the taxon’s true total when the download is capped below
  it.
- Fixed
  [`bdcr_occurrences_batch()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_occurrences_batch.md)
  progress messages repeating the last taxon’s name and status for every
  step instead of showing each taxon correctly.

## rbiodatacr 0.1.0

CRAN release: 2026-04-29

- First release on CRAN.
- [`bdcr_count()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_count.md):
  count available records for a taxon.
- [`bdcr_count_batch()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_count_batch.md):
  count records for multiple taxa.
- [`bdcr_occurrences()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_occurrences.md):
  download occurrence records for a taxon.
- [`bdcr_occurrences_batch()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_occurrences_batch.md):
  download occurrence records for multiple taxa.
- [`bdcr_species_search()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_species_search.md):
  search taxonomic information in the BIE index.
- [`bdcr_quality_check()`](https://manuelspinola.github.io/rbiodatacr/reference/bdcr_quality_check.md):
  evaluate record quality and assign flags.
