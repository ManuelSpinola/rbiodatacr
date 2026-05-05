## Resubmission

This is a resubmission addressing the CRAN policy on internet resources:

* `bdcr_GET()` now returns `NULL` with an informative message instead of
  throwing an error when the BIODATACR API is unavailable or returns a
  non-200 HTTP status.
* All vignette chunks that call the API now use `eval = FALSE` to avoid
  failures during build when the service is unavailable.

## R CMD check results

0 errors | 0 warnings | 0 notes

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
