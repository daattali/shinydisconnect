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
      '  size = ', input$size, ',\n',
      '  css = "', input$css, '"\n',
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

  observeEvent(input$set1, {
    updateTextInput(session, "text", value = "An error occured. Please refresh the page and try again.")
    updateCheckboxInput(session, "show_refresh", value = TRUE)
    updateTextInput(session, "refresh", value = "Refresh")
    colourpicker::updateColourInput(session, "background", value = "white")
    colourpicker::updateColourInput(session, "colour", value = "#444444")
    colourpicker::updateColourInput(session, "refreshColour", value = "#337ab7")
    updateSliderInput(session, "size", value = 22)
    updateCheckboxInput(session, "show_overlay", value = TRUE)
    colourpicker::updateColourInput(session, "overlayColour", value = "black")
    updateSliderInput(session, "overlayOpacity", value = 0.6)
    updateCheckboxInput(session, "full_width", value = FALSE)
    updateNumericInput(session, "width", value = 450)
    updateCheckboxInput(session, "center", value = FALSE)
    updateNumericInput(session, "top", value = 50)
    updateTextAreaInput(session, "css", value = "")
  })

  observeEvent(input$set2, {
    updateTextInput(session, "text", value = "Your session has timed out.")
    updateCheckboxInput(session, "show_refresh", value = FALSE)
    colourpicker::updateColourInput(session, "background", value = "rgba(64, 64, 64, 0.9)")
    colourpicker::updateColourInput(session, "colour", value = "white")
    colourpicker::updateColourInput(session, "refreshColour", value = "#337ab7")
    updateSliderInput(session, "size", value = 70)
    updateCheckboxInput(session, "show_overlay", value = TRUE)
    colourpicker::updateColourInput(session, "overlayColour", value = "#999")
    updateSliderInput(session, "overlayOpacity", value = 0.7)
    updateCheckboxInput(session, "full_width", value = TRUE)
    updateCheckboxInput(session, "center", value = TRUE)
    updateTextAreaInput(session, "css", value = "padding: 15px !important; box-shadow: 0 !important;")
  })
}
