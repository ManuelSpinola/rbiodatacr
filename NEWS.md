# rbiodatacr 0.1.1

* Fixed graceful failure when the BIODATACR API is unavailable or returns
  a non-200 HTTP status. Functions now return an empty tibble or `NA_integer_`
  with an informative message instead of throwing an error, in compliance
  with CRAN policy on internet resources.

# rbiodatacr 0.1.0

* First release on CRAN.
* `bdcr_count()`: count available records for a taxon.
* `bdcr_count_batch()`: count records for multiple taxa.
* `bdcr_occurrences()`: download occurrence records for a taxon.
* `bdcr_occurrences_batch()`: download occurrence records for multiple taxa.
* `bdcr_species_search()`: search taxonomic information in the BIE index.
* `bdcr_quality_check()`: evaluate record quality and assign flags.
