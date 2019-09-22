globalVariables(".")

list_file_contents <- function(dir, ignore_dotfiles, file_pattern) {
  dir(path = dir, recursive = TRUE, full.names = TRUE,
      all.files = !ignore_dotfiles, pattern = file_pattern) %>%
    lapply(readLines)
}

find_matches <- function(pattern, dir, ignore_dotfiles, file_pattern) {
  res <- list_file_contents(dir, ignore_dotfiles, file_pattern) %>%
    lapply(function(file_contents) {
      matches <- gregexpr(pattern, file_contents)
      res <- lapply(seq_along(matches), function(i) {
        row_matches <- matches[[i]]
        if (any(row_matches == -1))
          return(NULL)
        n <- length(matches[[i]])
        match_length <- attr(matches[[i]], "match.length")
        data.frame(
          row = rep(i, n),
          column = matches[[i]],
          length = match_length
        )
      })
      do.call(rbind, res)
    })
  names(res) <- dir(recursive = TRUE, path = dir, all.files = !ignore_dotfiles,
                    pattern = file_pattern)
  res
}

#' Search for patterns in files
#' @param pattern a character string containing a regular expression
#' @param dir a directory from which the search is conducted. Defaults to
#'   the working directory.
#' @param ignore_dotfiles should hidden files be ignored? Defaults to `TRUE`
#' @param file_pattern a regular expression that can be used to exclude certain
#'   files from the search. Passed as the `pattern` argument to [list.files()]
#' @export
grepr <- function(pattern, dir = ".", ignore_dotfiles = TRUE,
                  file_pattern = NULL) {
  matches <- find_matches(pattern, dir, ignore_dotfiles,
                          file_pattern = file_pattern)
  markers <- list()
  for (j in seq_along(matches)) {
    match <- matches[[j]]
    for (i in seq_along(match$row)) {
      file <- names(matches)[j]
      if (dir != ".")
        file <- paste0(dir, "/", file)
      line <- match$row[i]
      marker <- data.frame(
        file = file,
        line = line,
        column = match$column[i],
        length = match$length[i],
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
