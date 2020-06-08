library(shinydisconnect)

ui <- fluidPage(
  disconnectMessage(),
  actionButton("disconnect", "Disconnect the app")
)

server <- function(input, output, session) {
  observeEvent(input$disconnect, {
    session$close()
  })
}

shinyApp(ui, server)
