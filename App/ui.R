library(rCharts)
library(shiny)

textInputRow<-function (inputId, label, value = "") 
{
  div(style="display:inline-block",
      tags$label(label, `for` = inputId), 
      tags$input(id = inputId, type = "text", value = value, class="input-medium"))
}

numericInputRow <- function (inputId, label, value, min)
{
  div(style="display:inline-block",
      tags$label(label, `for` = inputId),
      tags$input(id = inputId, type="number", value=value, min = min, step=1, class="input-small"))
}

shinyUI(fluidPage(
  titlePanel("InstagramR"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("User",
        textInputRow("username", "Instagram Username:", "rkade93"),
        numericInputRow("picture_number", "How many pictures?", 20, min=1),
        submitButton("Submit"),
        tags$div(style="margin-bottom:15px;"),
        tabsetPanel(
          tabPanel("Plot", showOutput("plot", "highcharts")),
          tabPanel("User Map", showOutput("map", "leaflet"))
        )
      ),
      tabPanel("Hashtag", showOutput("map2", "leaflet"))
    ), width=12
  )
))