
<!-- README.md is generated from README.Rmd. Please edit that file -->

# grepr

<!-- badges: start -->

<!-- badges: end -->

grepr aims to provide a similar functionality as the bash command
`grep`, but display the results as RStudio source markers

## Installation

You can install the developent version of grepr from GitHub with:

``` r
remotes::install_github("GregorDeCillia/grepr")
```

## Example

This package exposes one single function called `grepr`, which finds
matches based on a regular expression.

``` r
library(grepr)
grepr(pattern = "names") %>% as.data.frame() %>% head(3)
#>          file line column                                 message
#> 1 grepr.Rproj   21     31 PackageRoxygenize: rd,collate,namespace
#> 2   R/grepr.R   17      3     names(res) <- dir(recursive = TRUE)
#> 3   R/grepr.R   30     15               file <- names(matches)[j]
```

If `grepr` is called in RStudio, the results are displayed as RStudio
markers.
