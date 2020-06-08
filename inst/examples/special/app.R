library(shinydisconnect)

ui <- fluidPage(
  disconnectMessage(
    text = "Your session has timed out.",
    refresh = "",
    background = "#aaa",
    size = 36,
    width = "full",
    top = "center",
    colour = "white",
    overlayColour = "#999",
    overlayOpacity = 0.4
  ),
  actionButton("disconnect", "Disconnect the app")
)

server <- function(input, output, session) {
  observeEvent(input$disconnect, {
    session$close()
  })
}

shinyApp(ui, server)
