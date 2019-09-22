globalVariables(".")

list_file_contents <- function() {
  dir(recursive = TRUE) %>%
    lapply(readLines)
}

find_matches <- function(pattern) {
  res <- list_file_contents() %>%
    lapply(function(file_contents) {
      matches <- regexpr(pattern, file_contents)
      data.frame(
        row = which(matches != -1),
        column = matches[matches != -1]
      )
    })
  names(res) <- dir(recursive = TRUE)
  res
}

#' Search for patterns in files
#' @param pattern a character string containing a regular expression
#' @export
grepr <- function(pattern) {
  matches <- find_matches(pattern)
  markers <- list()
  for (j in seq_along(matches)) {
    match <- matches[[j]]
    for (i in seq_along(match$row)) {
      file <- names(matches)[j]
      line <- match$row[i]
      marker <- data.frame(
        file = file,
        line = line,
        column = match$column[i],
        message = readLines(file)[line],
        stringsAsFactors = FALSE
      )
      markers <- c(markers, list(marker))
    }
  }
  res <- do.call(rbind, markers)
  if (is.null(res))
    res <- data.frame(file = character(0), line = integer(0),
                      column = integer(0), type = character(0),
                      message = character(0))
  class(res) <- c("grepr", "data.frame")
  res
}

#' @export
print.grepr <- function(x, ...) {
  if (nrow(x) > 0) {
    x$type <- "info"
    rstudioapi::sourceMarkers(name = "grepr", x)
  }
  else
    message("no matches to show")
}
