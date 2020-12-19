getLocalTags <- function() {
  if (!isLocal()) {
    return(NULL)
  }
  htmltools::tagList(
    htmltools::tags$div(
      id="ss-connect-dialog", style="display: none;",
      htmltools::tags$a(id="ss-reload-link", href="#", onclick="window.location.reload(true);")
    ),
    htmltools::tags$div(id="ss-overlay", style="display: none;")
  )
}

isLocal <- function() {
  Sys.getenv("SHINY_PORT", "") == ""
}
