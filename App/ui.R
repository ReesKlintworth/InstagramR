library(rCharts)
library(shiny)

shinyUI(fluidPage(
  sidebarPanel(
    textInput("username", "Instagram Username:", "rkade93"),
    submitButton("Submit")
  ),
  
  mainPanel(
    showOutput("plot", "highcharts")
  )
))