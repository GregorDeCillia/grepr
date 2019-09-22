#' @export
print.grepr <- function(x, ...) {
  if (nrow(x) > 0) {
    x$type <- "info"
    rstudioapi::sourceMarkers(name = "grepr", markup_messages(x),
                              basePath = attr(x, "dir"))
  }
  else
    message("no matches to show")
}

markup_messages <- function(matches, env_open = "<font color='red'>",
                            env_close = "</font>") {
  new_msg <- sapply(seq_len(nrow(matches)), function(i) {
    match <- matches[i, ]
    message <- match$message
    column <- match$column
    length <- match$length
    pre <- substr(message, 1, column - 1)
    middle <- substr(message, column, column + length - 1)
    post <- substr(message, column + length, 1e6)
    paste0(pre, env_open, middle, env_close, post)
  })
  class(new_msg) <- c("character", "html")
  matches$message <- new_msg
  matches
}
