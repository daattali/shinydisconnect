#' use stopApp() to test
#' refresh = "" fo no button
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
    if (Sys.getenv("SHINY_PORT", "") == "")
      htmltools::tagList(
        htmltools::tags$script("
                               $(function() {
$(document).on('shiny:disconnected', function(event) {
$('#ss-connect-dialog').show();
$('#ss-overlay').show();
})
});
                               "),
        htmltools::tags$div(id="ss-connect-dialog", style="display: none;",
                            htmltools::tags$a("zzz",id="ss-reload-link", href="#", onclick="window.location.reload(true);")),
        htmltools::tags$div(id="ss-overlay", style="display: none;")
      )
    else
      NULL,

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
          "#ss-connect-dialog::before { content: '{{text}}'}",
          "#ss-connect-dialog label {
            display: none !important;
          }
          #ss-connect-dialog a {
            display: {{ if (refresh == '') 'none' else 'block' }} !important;
            font-size: 0 !important;
            margin-top: {{font}}px !important;
            font-weight: normal !important;
          }
          #ss-connect-dialog a::before {
            content: '{{refresh}}';
            font-size: {{font}}px;
          }
          "
        )
      )
    )
  )
}
