#' Show a nice message when a shiny app disconnects
#'
#' A shiny app can disconnect for a variety of reasons: an unrecoverable error occurred in
#' the app, the server went down, the user's internet connection died, or any other reason
#' that might cause the shiny app to lose connection to its server. Call `disonnectMessage()`
#' anywhere in a Shiny app's UI to add a nice message when this happens. The message works both
#' locally (running Shiny apps within RStudio) and on Shiny servers (such as shinyapps.io,
#' RStudio Connect, Shiny Server Open Source, Shiny Server Pro).
#'
#' @param text The text to show in the message.
#' @param refresh The text to show in a link that allows the user to refresh the page.
#' Use `refresh = ""` if you don't want to show a refresh link.
#' @param size The size of the message, one of "s", "m", "l" (small, medium, or large).
#' @param background The background colour of the message box.
#' @param colour The colour of the text of the message box.
#' @param overlayColour The colour of the overlay to draw on the page behind the message box.
#' An overlay is used to "grey out" the application and draw attention to the message. Use
#' `overlayOpacity = 0` to disable the overlay.
#' @param overlayOpacity The opacity of the overlay, from 0 (fully transparent) to 1
#' (fully opaque). Use `overlayOpacity = 0` to disable the overlay.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       disconnectMessage(),
#'       actionButton("disconnect", "Disconnect the app")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$disconnect, {
#'         session$close()
#'       })
#'     }
#'   )
#' }
#' @export
disconnectMessage <- function(
  text = "An error occured. Please refresh the page and try again.",
  refresh = "Refresh",
  size = "m",
  background = "white",
  colour = "#444444",
  overlayColour = "black",
  overlayOpacity = 0.6
) {

  checkmate::assert_string(text, min.chars = 1)
  checkmate::assert_string(refresh)
  checkmate::assert_string(size)
  checkmate::assert_string(background)
  checkmate::assert_string(colour)
  checkmate::assert_string(overlayColour)
  checkmate::assert_number(overlayOpacity, lower = 0, upper = 1)
  if (!size %in% c("s", "m", "l")) {
    stop("disconnectMessage: 'size' must be one of: 's', 'm', 'l'.", call. = FALSE)
  }

  if (size == "s") {
    width <- 300
    font <- 14
  } else if (size == "m") {
    width <- 450
    font <- 20
  } else if (size == "l") {
    width <- 600
    font <- 26
  }

  htmltools::tagList(
    getLocalTags(),
    htmltools::tags$head(
      htmltools::tags$style(
        glue::glue(
          .open = "{{", .close = "}}",

          "#shiny-disconnected-overlay { display: none !important; }",

          "#ss-overlay {
             background-color: {{overlayColour}} !important;
             opacity: {{overlayOpacity}} !important;
             position: fixed !important;
             top: 0 !important;
             left: 0 !important;
             bottom: 0 !important;
             right: 0 !important;
             z-index: 99998 !important;
             overflow: hidden !important;
             cursor: not-allowed !important;
          }",

          "#ss-connect-dialog {
             background: {{background}} !important;
             color: {{colour}} !important;
             width: {{width}}px !important;
             margin-left: -{{width/2}}px !important;
             font-size: {{font}}px !important;
             position: fixed !important;
             top: 50px !important;
             bottom: auto !important;
             left: 50% !important;
             padding: 1em 1.5em !important;
             text-align: center !important;
             height: auto !important;
             opacity: 1 !important;
             z-index: 99999 !important;
             border-radius: 3px !important;
             box-shadow: rgba(0, 0, 0, 0.3) 3px 3px 10px !important;
          }",

          "#ss-connect-dialog::before { content: '{{text}}' }",

          "#ss-connect-dialog label { display: none !important; }",

          "#ss-connect-dialog a {
             display: {{ if (refresh == '') 'none' else 'block' }} !important;
             font-size: 0 !important;
             margin-top: {{font}}px !important;
             font-weight: normal !important;
          }",

          "#ss-connect-dialog a::before {
            content: '{{refresh}}';
            font-size: {{font}}px;
          }"
        )
      )
    )
  )
}

getLocalTags <- function() {
  if (!isLocal()) {
    return(NULL)
  }

  htmltools::tagList(
    htmltools::tags$script(paste0(
      "$(function() {",
      "  $(document).on('shiny:disconnected', function(event) {",
      "    $('#ss-connect-dialog').show();",
      "    $('#ss-overlay').show();",
      "  })",
      "});"
    )),
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
