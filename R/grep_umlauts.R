specials <- "[\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df]"

#' Mark all umlauts
#'
#' Searches for umlauts (ÖÄÜöäü) with [grepr()] and creates RStudio markers
#' @inheritParams grepr
#' @param ... arguments which are passed to [grepr()]
#' @param ignore_roxygen do not show umlauts in roxygen blocks or Rd files
#' @export
grep_umlauts <- function(pattern = specials, ..., ignore_roxygen = FALSE) {
  matches <- grepr(pattern = pattern, ...)
  if (ignore_roxygen)
    matches <- drop_roxygen_matches(matches)
  matches
}

drop_roxygen_matches <- function(matches) {
  dir <- attr(matches, "dir")
  matches <- matches[substr(matches$message, 1, 2) != "#'", ]
  matches <- matches[substr(matches$file, 1, 4) != "man/", ]
  attr(matches, "dir") <- dir
  matches
}

#' @rdname grep_umlauts
#' @export
print_substitution_table <- function() {
  umlauts <- c("\u00c4", "\u00e4", "\u00d6", "\u00f6", "\u00dc", "\u00fc",
               "\u00df")
  substitutions <- c("\\u00c4", "\\u00e4", "\\u00d6", "\\u00f6", "\\u00dc",
                     "\\u00fc", "\\u00df")
  message("the following substitutions should be used if R CMD check ",
          "adds NOTEs because of umlauts")
  message(paste0(umlauts, ": ", substitutions, "\t", collapse = ""))
}
