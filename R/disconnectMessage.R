#' Show a nice message when a shiny app disconnects or errors
#'
#' A shiny app can disconnect for a variety of reasons: an unrecoverable error occurred in
#' the app, the server went down, the user lost internet connection, or any other reason
#' that might cause the shiny app to lose connection to its server.\cr\cr
#' Call `disonnectMessage()`
#' anywhere in a Shiny app's UI to add a nice message when this happens. Works
#' locally (running Shiny apps within RStudio) and on Shiny servers (such as shinyapps.io,
#' RStudio Connect, Shiny Server Open Source, Shiny Server Pro).\cr\cr
#' See the [demo Shiny app](https://daattali.com/shiny/shinydisconnect-demo/) online for examples.\cr\cr
#' Note that it's not possible to distinguish between errors and timeouts - they will both
#' show the same message.
#'
#' You can also use [`disconnectMessage2()`] to use a pre-set combination of parameters
#' that produces a large centered message.
#'
#' @param text The text to show in the message.
#' @param refresh The text to show in a link that allows the user to refresh the page.
#' Use `refresh = ""` if you don't want to show a refresh link.
#' @param width The width of the message box. Must be either an integer, or the string
#' `"full"` to make the message take up the entire page width.
#' @param top The distance from the message to the top of the page. Must be either
#' an integer, or the string `"center"` to make the box vertically centered.
#' @param size The font size of the text. (integer).
#' @param background The background colour of the message box.
#' @param colour The colour of the text of the message box.
#' @param overlayColour The colour of the overlay to draw on the page behind the message box.
#' An overlay is used to "grey out" the application and draw attention to the message. Use
#' `overlayOpacity = 0` to disable the overlay.
#' @param overlayOpacity The opacity of the overlay, from 0 (fully transparent/not visible) to 1
#' (fully opaque). Use `overlayOpacity = 0` to disable the overlay.
#' @param refreshColour The colour of the refresh text link
#' @param css Any additional CSS rules to apply to the message box. For example,
#' `css = "padding: 0 !important; border: 3px solid red;"` will remove padding and add a border.
#' Note that you may need to use the `!important` rule to override default styles.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       disconnectMessage(),
#'       actionButton("disconnect", "Disconnect the app")
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$disconnect, {
#'         session$close()
#'       })
#'     }
#'   )
#' }
#' @export
disconnectMessage <- function(
  text = "An error occurred. Please refresh the page and try again.",
  refresh = "Refresh",
  width = 450,
  top = 50,
  size = 22,
  background = "white",
  colour = "#444444",
  overlayColour = "black",
  overlayOpacity = 0.6,
  refreshColour = "#337ab7",
  css = ""
) {

  checkmate::assert_string(text, min.chars = 1)
  checkmate::assert_string(refresh)
  checkmate::assert_numeric(size, lower = 0)
  checkmate::assert_string(background)
  checkmate::assert_string(colour)
  checkmate::assert_string(overlayColour)
  checkmate::assert_number(overlayOpacity, lower = 0, upper = 1)
  checkmate::assert_string(refreshColour)
  checkmate::assert_string(css)

  if (width == "full") {
    width <- "100%"
  } else if (is.numeric(width) && width >= 0) {
    width <- paste0(width, "px")
  } else {
    stop("disconnectMessage: 'width' must be either an integer, or the string \"full\".", call. = FALSE)
  }

  if (top == "center") {
    top <- "50%"
    ytransform <- "-50%"
  } else if (is.numeric(top) && top >= 0) {
    top <- paste0(top, "px")
    ytransform <- "0"
  } else {
    stop("disconnectMessage: 'top' must be either an integer, or the string \"center\".", call. = FALSE)
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
             width: {{width}} !important;
             transform: translateX(-50%) translateY({{ytransform}}) !important;
             font-size: {{size}}px !important;
             top: {{top}} !important;
             position: fixed !important;
             bottom: auto !important;
             left: 50% !important;
             padding: 0.8em 1.5em !important;
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
             color: {{refreshColour}} !important;
             font-size: 0 !important;
             margin-top: {{size}}px !important;
             font-weight: normal !important;
          }",

          "#ss-connect-dialog a::before {
            content: '{{refresh}}';
            font-size: {{size}}px;
          }",

          "#ss-connect-dialog { {{ htmltools::HTML(css) }} }"
        )
      )
    )
  )
}

#' Show a nice message when a shiny app disconnects or errors
#'
#' This function is a version of [`disconnectMessage()`] with a pre-set combination
#' of parameters that results in a large centered message.
#' @export
disconnectMessage2 <- function() {
  disconnectMessage(
    text = "Your session has timed out.",
    refresh = "",
    size = 70,
    colour = "white",
    background = "rgba(64, 64, 64, 0.9)",
    width = "full",
    top = "center",
    overlayColour = "#999",
    overlayOpacity = 0.7,
    css = "padding: 15px !important; box-shadow: none !important;"
  )
}
