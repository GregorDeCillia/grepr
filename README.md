
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
#>               file line column
#> 1 R/grep_umlauts.R   19     37
#> 2 R/grep_umlauts.R   31      3
#> 3 R/grep_umlauts.R   34      5
#>                                                                   message
#> 1             matches <- matches[substr(matches$message, 1, 2) != "#'", ]
#> 2   message("the following substitutions should be used if R CMD check ",
#> 3                      message(umlauts[i], ": ", substitutions[i], "\\t")
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

## Umlauts

`grep_umlauts` is a wrapper around `grepr` which looks for umlauts via
the `pattern` argument. It can be used with a flag `ignore_roxygen` to
skip Rd Files and roxygen comments.

Supported symbols: ÖÄÜöäü

``` r
grep_umlauts(file_pattern = "README\\.Rmd") %>% as.data.frame()
#>         file line column                   message
#> 1 README.Rmd   59     20 Supported symbols: ÖÄÜöäü
```

The function `print_substitution_table()` can be used to suggest
alternatives

``` r
print_substitution_table()
#> the following substitutions should be used if R CMD check adds NOTEs because of umlauts
#> Ä: \u00c4    
#> ä: \u00e4    
#> Ö: \u00d6    
#> ö: \u00f6    
#> Ü: \u00dc    
#> ü: \u00fc    
#> ß: \u00df    
```
