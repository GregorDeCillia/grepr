
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
grepr(pattern = "message") %>% as.data.frame() %>% head(3)
#>        file line column                                       message
#> 1 R/grepr.R   48      9              message = readLines(file)[line],
#> 2 R/grepr.R   58     23                       message = character(0))
#> 3 R/grepr.R   71      5                 message("no matches to show")
```

If `grepr` is called in RStudio, the results are displayed as RStudio
markers.

## Arguments

| Argument             | Description                                                                        |
| -------------------- | ---------------------------------------------------------------------------------- |
| **pattern**          | a character string containing a regular expression                                 |
| **dir**              | a directory from which the search is conducted. Defaults to the working directory. |
| **ignore\_dotfiles** | should hidden files be searched as well? Defaults to `FALSE`                       |
| **file\_pattern**    | a regular expression which can be used to exclude certain files from the search    |
