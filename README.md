
<!-- README.md is generated from README.Rmd. Please edit that file -->

# grepr

<!-- badges: start -->

<!-- badges: end -->

grepr aims to provide a similar functionality as the bash command `grep`
and display the results as RStudio source markers

## Installation

You can install the developent version of grepr from GitHub with:

``` r
remotes::install_github("GregorDeCillia/grepr")
```

## Example

The function `grepr` can be used to find matches in files based on a
regular expression.

``` r
library(grepr)
grepr("message")[5:9, ]
```

| file                   | line            | content                                                                                     |
| :--------------------- | :-------------- | :------------------------------------------------------------------------------------------ |
| <code>R/grepr.R</code> | <code>60</code> | <code>    **message** = readLines(file)\[line\],</code>                                     |
| <code>R/print.R</code> | <code>5</code>  | <code>    rstudioapi::sourceMarkers(name = “grepr”, markup\_**message**s(x),</code>         |
| <code>R/print.R</code> | <code>9</code>  | <code>    **message**(“no matches to show”)</code>                                          |
| <code>R/print.R</code> | <code>12</code> | <code>markup\_**message**s \<- function(matches, env\_open = “\<font color=‘red’\>”,</code> |
| <code>R/print.R</code> | <code>20</code> | <code>    **message** \<- match$message</code>                                              |

If `grepr` is called in RStudio, the results are displayed as [RStudio
source
markers](https://rstudio.github.io/rstudioapi/reference/sourceMarkers.html).

## Arguments

| Argument             | Description                                                                        |
| -------------------- | ---------------------------------------------------------------------------------- |
| **pattern**          | a character string containing a regular expression                                 |
| **dir**              | a directory from which the search is conducted. Defaults to the working directory. |
| **ignore\_dotfiles** | should hidden files be ignored? Defaults to `TRUE`                                 |
| **file\_pattern**    | a regular expression which can be used to exclude certain files from the search    |

## Umlauts

`grep_umlauts` is a wrapper around `grepr` which looks for umlauts via
the `pattern` argument. It can be used with a flag `ignore_roxygen` to
skip Rd Files and roxygen comments.

Supported symbols: Ö, Ä, Ü, ö, ä, ü,
ß

``` r
grep_umlauts(file_pattern = "README\\.Rmd")
```

| file                    | line            | content                                                 |
| :---------------------- | :-------------- | :------------------------------------------------------ |
| <code>README.Rmd</code> | <code>61</code> | <code>Supported symbols: **Ö**, Ä, Ü, ö, ä, ü, ß</code> |
| <code>README.Rmd</code> | <code>61</code> | <code>Supported symbols: Ö, **Ä**, Ü, ö, ä, ü, ß</code> |
| <code>README.Rmd</code> | <code>61</code> | <code>Supported symbols: Ö, Ä, **Ü**, ö, ä, ü, ß</code> |
| <code>README.Rmd</code> | <code>61</code> | <code>Supported symbols: Ö, Ä, Ü, **ö**, ä, ü, ß</code> |
| <code>README.Rmd</code> | <code>61</code> | <code>Supported symbols: Ö, Ä, Ü, ö, **ä**, ü, ß</code> |
| <code>README.Rmd</code> | <code>61</code> | <code>Supported symbols: Ö, Ä, Ü, ö, ä, **ü**, ß</code> |
| <code>README.Rmd</code> | <code>61</code> | <code>Supported symbols: Ö, Ä, Ü, ö, ä, ü, **ß**</code> |

The function `print_substitution_table()` can be used to suggest
alternatives

``` r
print_substitution_table()
#> the following substitutions should be used if R CMD check adds NOTEs because of umlauts
#> Ä: \u00c4    ä: \u00e4   Ö: \u00d6   ö: \u00f6   Ü: \u00dc   ü: \u00fc   ß: \u00df   
```

## Class methods

Calls to `grepr::grepr()` create objects of the class `grepr`. Those
objects can be used in the following ways.

  - printing an object in an interactive console will display the
    matches with `rstudioapi::sourceMarkers()`
  - printing an object in a RMarkdown file will render the matches with
    `knitr::kable()`
  - the generic `as.data.frame()` converts the matches into a tidy
    `data.frame` that contains filenames, row numbers, colum numbers and
    lengths of the matches.

<!-- end list -->

``` r
grep_umlauts(file_pattern = "README\\.Rmd") %>% as.data.frame()
#>         file line column length                                message
#> 1 README.Rmd   61     20      1 Supported symbols: Ö, Ä, Ü, ö, ä, ü, ß
#> 2 README.Rmd   61     23      1 Supported symbols: Ö, Ä, Ü, ö, ä, ü, ß
#> 3 README.Rmd   61     26      1 Supported symbols: Ö, Ä, Ü, ö, ä, ü, ß
#> 4 README.Rmd   61     29      1 Supported symbols: Ö, Ä, Ü, ö, ä, ü, ß
#> 5 README.Rmd   61     32      1 Supported symbols: Ö, Ä, Ü, ö, ä, ü, ß
#> 6 README.Rmd   61     35      1 Supported symbols: Ö, Ä, Ü, ö, ä, ü, ß
#> 7 README.Rmd   61     38      1 Supported symbols: Ö, Ä, Ü, ö, ä, ü, ß
```

## Known Issues

  - in RMarkdown documents with markdown output, square brackets (`[`
    and `]`) get escaped in a way that can affect the markup of
    `knit_print.grepr()`:
    <https://github.com/rstudio/rmarkdown/issues/667>
  - double quotes (`"`) are displayed as fancy quotes (<code>“</code>)
    in column `content`
  - currently, there is no check if RStudio is running which might lead
    to errors in the print method in case another IDE or no IDE is used

## Possible improvements

  - add `grep_package()` which respects the contents of `.gitignore` and
    `.Rbuildignore` by default
  - ignore BLOBS and other problematic file types by default
  - add `gsub_umlauts()` which applies the suggestions in
    `print_substitution_table()` automatically
