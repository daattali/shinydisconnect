library(shiny)
library(shinydisconnect)

ui <- fluidPage(
  disconnectMessage(
    text = "Your session timed out, reload the application.",
    refresh = "Reload now",
    background = "#f89f43",
    colour = "white",
    overlayColour = "grey",
    overlayOpacity = 0.3,
    refreshColour = "brown"
  ),
  actionButton("disconnect", "Disconnect the app")
)

server <- function(input, output, session) {
  observeEvent(input$disconnect, {
    session$close()
  })
}

shinyApp(ui, server)
