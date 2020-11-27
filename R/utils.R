getLocalTags <- function() {
  shiny::addResourcePath("shinydiscon", system.file("src", package = "shinydisconnect"))
  js <- htmltools::tags$head(htmltools::tags$script(src = "shinydiscon/js/shinydisconnect.js"))
  if (!isLocal()) {
    return(js)
  }
  htmltools::tagList(
    js,
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
