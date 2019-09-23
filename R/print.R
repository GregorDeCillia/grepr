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
                            env_close = "</font>", as_html = TRUE,
                            escape = TRUE) {
  escaper <- escape_html
  if (!escape)
    escaper <- identity
  new_msg <- sapply(seq_len(nrow(matches)), function(i) {
    match <- matches[i, ]
    message <- match$message
    column <- match$column
    length <- match$length
    pre <- substr(message, 1, column - 1)
    middle <- substr(message, column, column + length - 1)
    post <- substr(message, column + length, 1e6)
    paste0(escaper(pre), env_open, escaper(middle), env_close, escaper(post))
  })
  if (as_html)
    class(new_msg) <- c("character", "html")
  matches$message <- new_msg
  matches
}

markup_code <- function(matches) {
  matches$file <- paste0("<code>", matches$file, "</code>")
  matches$message <- paste0("<code>", matches$message, "</code>")
  matches$line <- paste0("<code>", matches$line, "</code>")
  matches
}

drop_columns <- function(matches) {
  matches[, c("file", "message")]
  data.frame(
    file = matches$file,
    line = matches$line,
    content = matches$message
  )
}

render_kable <- function(matches) {
  matches %>%
    knitr::kable(format = "pandoc", escape = FALSE) %>%
    paste(collapse = "\n") %>%
    knitr::asis_output()
}

escape_html <- function(text) {
  specials <- list(`&` = "&amp;", `<` = "&lt;", `>` = "&gt;", " " = "&nbsp;")
  for (chr in names(specials))
    text <- gsub(chr, specials[[chr]], text, fixed = TRUE, useBytes = TRUE)
  text
}

#' @importFrom knitr knit_print
#' @export
knit_print.grepr <- function(x, ...) {
  x %>%
    markup_messages("**", "**", as_html = FALSE) %>%
    markup_code() %>%
    drop_columns() %>%
    render_kable()
}
