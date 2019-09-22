globalVariables(".")

list_file_contents <- function(dir) {
  dir(path = dir, recursive = TRUE, full.names = TRUE) %>%
    lapply(readLines)
}

find_matches <- function(pattern, dir) {
  res <- list_file_contents(dir) %>%
    lapply(function(file_contents) {
      matches <- regexpr(pattern, file_contents)
      data.frame(
        row = which(matches != -1),
        column = matches[matches != -1]
      )
    })
  names(res) <- dir(recursive = TRUE, path = dir)
  res
}

#' Search for patterns in files
#' @param pattern a character string containing a regular expression
#' @param dir a directory from which the search is conducted. Defaults to
#'   the working directory.
#' @export
grepr <- function(pattern, dir = ".") {
  matches <- find_matches(pattern, dir)
  markers <- list()
  for (j in seq_along(matches)) {
    match <- matches[[j]]
    for (i in seq_along(match$row)) {
      file <- paste0(dir, "/", names(matches)[j])
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
  attr(res, "dir") <- dir
  res
}

#' @export
print.grepr <- function(x, ...) {
  if (nrow(x) > 0) {
    x$type <- "info"
    rstudioapi::sourceMarkers(name = "grepr", x, basePath = attr(x, "dir"))
  }
  else
    message("no matches to show")
}
