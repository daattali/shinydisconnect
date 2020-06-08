library(shiny)

share <- list(
  title = "shinydisconnect package",
  url = "https://daattali.com/shiny/shinydisconnect-demo/",
  image = "https://daattali.com/shiny/img/shinydisconnect.png",
  description = "Show a nice message when a shiny app disconnects or errors",
  twitter_user = "daattali"
)

fluidPage(
  title = paste0(share$title, " ", as.character(packageVersion("shinydisconnect"))),
  tags$head(
    includeCSS(file.path('www', 'style.css')),
    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="https://daattali.com/shiny/img/favicon.ico"),
    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = share$title),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),

    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),
  tags$a(
    href="https://github.com/daattali/shinydisconnect",
    tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
             src="github-green-right.png",
             alt="Fork me on GitHub")
  ),

  shinydisconnect:::getLocalTags(),

  div(
    id = "header",
    div(id = "pagetitle", share$title),
    div(id = "subtitle", share$description),
    div(id = "subsubtitle",
        "Created by",
        tags$a(href = "https://deanattali.com/", "Dean Attali"),
        HTML("&bull;"),
        "Available",
        tags$a(href = "https://github.com/daattali/shinydisconnect", "on GitHub"),
        HTML("&bull;"),
        tags$a(href = "https://daattali.com/shiny/", "More apps"), "by Dean"
    )
  ),

  fluidRow(column(
    width = 6, offset = 3,
    div(
      id = "main-row",
      actionButton("show", "Simulate a disconnect", icon("play"), class = "btn-success"),
      br(), br()
    )
  )),
  fluidRow(
    column(
      3,
      h3("Text"),
      textInput("text", "Message", "An error occured. Please refresh the page and try again."),
      checkboxInput("show_refresh", "Show a refresh button?", TRUE),
      conditionalPanel(
        "input.show_refresh",
        textInput("refresh", "Refresh text", "Refresh")
      )
    ),
    column(
      3,
      h3("Style"),
      colourpicker::colourInput("background", "Message background", "white", showColour = "background", allowTransparent = TRUE),
      colourpicker::colourInput("colour", "Message text colour", "#444444", showColour = "background"),
      conditionalPanel(
        "input.show_refresh",
        colourpicker::colourInput("refreshColour", "Refresh text colour", "#337ab7", showColour = "background")
      ),
      sliderInput("size", "Font size", min = 10, max = 50, value = 22)
    ),
    column(
      3,
      h3("Overlay"),
      checkboxInput("show_overlay", "Add an overlay on the page?", TRUE),
      conditionalPanel(
        "input.show_overlay",
        colourpicker::colourInput("overlayColour", "Overlay colour", "black", showColour = "background"),
        sliderInput("overlayOpacity", "Overlay transparency", min = 0, max = 1, value = 0.6)
      )
    ),
    column(
      3,
      h3("Position"),
      checkboxInput("full_width", "Full width?", FALSE),
      conditionalPanel(
        "!input.full_width",
        numericInput("width", "Width", min = 0, value = 450)
      ),
      checkboxInput("center", "Vertically centered?", FALSE),
      conditionalPanel(
        "!input.center",
        numericInput("top", "Distance from top of page", min = 0, value = 50)
      )
    )
  ),

  fluidRow(
    column(
      12,
      h3("Generated code"),
      verbatimTextOutput("code")
    )
  )
)
