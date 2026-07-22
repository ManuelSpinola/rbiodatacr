# rbiodatacr 0.1.1

* Fixed graceful failure when the BIODATACR API is unavailable or returns
  a non-200 HTTP status. Functions now return an empty tibble or `NA_integer_`
  with an informative message instead of throwing an error, in compliance
  with CRAN policy on internet resources.
* Fixed `bdcr_occurrences()` (and `bdcr_occurrences_batch()`) silently
  truncating results at 100 records regardless of how many were actually
  available. Both functions now paginate correctly to retrieve the
  requested number of records (or all of them, with `rows = Inf`), and
  report the taxon's true total when the download is capped below it.
* Fixed `bdcr_occurrences_batch()` progress messages repeating the last
  taxon's name and status for every step instead of showing each taxon
  correctly.

# rbiodatacr 0.1.0

* First release on CRAN.
* `bdcr_count()`: count available records for a taxon.
* `bdcr_count_batch()`: count records for multiple taxa.
* `bdcr_occurrences()`: download occurrence records for a taxon.
* `bdcr_occurrences_batch()`: download occurrence records for multiple taxa.
* `bdcr_species_search()`: search taxonomic information in the BIE index.
* `bdcr_quality_check()`: evaluate record quality and assign flags.
