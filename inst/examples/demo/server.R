function(input, output, session) {
  code <- reactive({
    code <- paste0(
      'disconnectMessage(\n',
      '  text = "', input$text, '",\n',
      '  refresh = "', if (input$show_refresh) input$refresh else "", '",\n',
      '  background = "', input$background, '",\n',
      '  colour = "', input$colour, '",\n'
    )

    if (input$show_refresh) {
      code <- paste0(
        code,
        '  refreshColour = "', input$refreshColour, '",\n'
      )
    }

    if (input$show_overlay) {
      code <- paste0(
        code,
        '  overlayColour = "', input$overlayColour, '",\n',
        '  overlayOpacity = ', input$overlayOpacity, ',\n'
      )
    } else {
      code <- paste0(
        code,
        '  overlayOpacity = 0,\n'
      )
    }

    if (input$full_width) {
      width <- "\"full\""
    } else {
      width <- input$width
    }

    if (input$center) {
      top <- "\"center\""
    } else {
      top <- input$top
    }

    code <- paste0(
      code,
      '  width = ', width, ',\n',
      '  top = ', top, ',\n',
      '  size = ', input$size,  '\n',
      ')'
    )

    code
  })

  output$code <- renderText({
    paste0(
      "library(shiny)\nlibrary(shinydisconnect)\n\n",
      "ui <- fluidPage(\n  ",
      gsub("\n", "\n  ", code()),
      ",\n  actionButton('disconnect', 'Disconnect the app')\n)\n\n",
      "server <- function(input, output, session) {\n",
      "  observeEvent(input$disconnect, {\n    session$close()\n  })",
      "\n}\n\nshinyApp(ui, server)"
    )
  })

  observeEvent(input$show, {
    tag <- eval(parse(text = paste0("shinydisconnect::", code())))
    insertUI("body", "beforeEnd", tag, immediate = TRUE)
    session$close()
  })
}
