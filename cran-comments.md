## Resubmission

This is an update to the version currently on CRAN (0.1.0), fixing two bugs:

* `bdcr_occurrences()` and `bdcr_occurrences_batch()` were silently
  truncating results at 100 records regardless of how many records were
  actually available for a given taxon. Both functions now paginate
  correctly to retrieve the requested number of records (or all of them,
  via `rows = Inf`), using the taxon's true record count to know when to
  stop. When the download is capped below the true total, an informative
  message reports it, so results are never mistaken for the complete
  dataset.
* `bdcr_occurrences_batch()` progress messages repeated the last taxon's
  name and status for every step instead of reporting each taxon
  correctly.

No user-facing API changes, deprecations, or new dependencies were
introduced.

## R CMD check results

0 errors | 0 warnings | 0 notes
