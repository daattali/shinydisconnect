# shinydisconnect - Show a nice message when a Shiny app disconnects or errors

[![CRAN
version](https://www.r-pkg.org/badges/version/shinydisconnect)](https://cran.r-project.org/package=shinydisconnect)

> Copyright 2020 [Dean Attali](https://deanattali.com). Licensed under the MIT license.

## Overview

A shiny app can disconnect for a variety of reasons: an unrecoverable error occurred in the app, the server went down, the user's internet connection died, or any other reason that might cause the shiny app to lose connection to its server.

`shinydisconnect` allows you to add a nice message to the user when the app disconnects.  The message works both locally (running Shiny apps within RStudio) and on Shiny servers (such as shinyapps.io, RStudio Connect, Shiny Server Open Source, Shiny Server Pro).

**If you find shinydisconnect useful, please consider supporting my work\!**

<p align="center">

<a style="display: inline-block;" href="https://paypal.me/daattali">
<img height="35" src="https://camo.githubusercontent.com/0e9e5cac101f7093336b4589c380ab5dcfdcbab0/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f74776f6c66736f6e2f70617970616c2d6769746875622d627574746f6e40312e302e302f646973742f627574746f6e2e737667" />
</a>
<a style="display: inline-block; margin-left: 10px;" href="https://github.com/sponsors/daattali">
<img height="35" src="https://i.imgur.com/034B8vq.png" /> </a>

</p>

## Installation

The package is not yet on CRAN, so to install use these comments:

```
install.packages("remotes")
remotes::install_github("daattali/shinydisconnect")
```

## How to use

Call `disonnectMessage()` anywhere in a Shiny app's UI to add a nice message when this happens.

Without using this package, a shiny app that disconnects will either just show a greyed out screen if running locally (with no message), or will show a small message in the bottom-left corner that you cannot modify when running in a server.

Example basic usage:

```
shinyApp(
  ui = fluidPage(
    disconnectMessage(),
    actionButton("disconnect", "Disconnect the app")
  ),
  server = function(input, output) {
    observeEvent(input$disconnect, {
      session$close()
    })
  }
)
```

![basic screenshot](inst/img/basic.PNG)

Example parameters:

```
shinyApp(
  ui = fluidPage(
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
  ),
  server = function(input, output) {
    observeEvent(input$disconnect, {
      session$close()
    })
  }
)
```

![advanced screenshot](inst/img/advanced.PNG)

Example with full width and vertically centered message:

```
shinyApp(
  ui = fluidPage(
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
  ),
  server = function(input, output) {
    observeEvent(input$disconnect, {
      session$close()
    })
  }
)
```

![full screenshot](inst/img/full.PNG)
