globalVariables(".")

list_file_contents <- function(dir, ignore_dotfiles, file_pattern) {
  dir(path = dir, recursive = TRUE, full.names = TRUE,
      all.files = !ignore_dotfiles, pattern = file_pattern) %>%
    lapply(readLines)
}

parse_match <- function(i, matches) {
  row_matches <- matches[[i]]
  if (any(row_matches == -1))
    return(NULL)
  n <- length(row_matches)
  match_length <- attr(row_matches, "match.length")
  data.frame(
    row = rep(i, n),
    column = row_matches,
    length = match_length
  )
}

get_file_matches <- function(file_contents, pattern) {
  matches <- gregexpr(pattern, file_contents)
  lapply(seq_along(matches), parse_match, matches) %>%
    do.call(rbind, .)
}

find_matches <- function(pattern, dir, ignore_dotfiles, file_pattern) {
  list_file_contents(dir, ignore_dotfiles, file_pattern) %>%
    lapply(get_file_matches, pattern) %>%
    `names<-`(dir(
      recursive = TRUE, path = dir, all.files = !ignore_dotfiles,
      pattern = file_pattern
    ))
}

null_match <- data.frame(
  file = character(0), line = integer(0),
  column = integer(0), type = character(0),
  message = character(0))

handle_empty_matches <- function(matches) {
  if (nrow(matches) == 0)
    return(null_match)
  else
    return(matches)
}

create_marker <- function(matches, i, j, dir) {
  file <- names(matches)[j]
  match <- matches[[j]]
  if (dir != ".")
    file <- paste0(dir, "/", file)
  line <- match$row[i]
  data.frame(
    file = file,
    line = line,
    column = match$column[i],
    length = match$length[i],
    message = readLines(file)[line],
    stringsAsFactors = FALSE
  )
}

tidy_matches <- function(matches, dir) {
  markers <- list()
  for (j in seq_along(matches)) {
    match <- matches[[j]]
    for (i in seq_along(match$row)) {
      marker <- create_marker(matches, i, j, dir)
      markers <- c(markers, list(marker))
    }
  }
  do.call(rbind, markers)
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
  pattern %>%
    find_matches(dir, ignore_dotfiles, file_pattern = file_pattern) %>%
    tidy_matches(dir) %>%
    handle_empty_matches() %>%
    `class<-`(c("grepr", "data.frame")) %>%
    `attr<-`("dir", dir)
}
