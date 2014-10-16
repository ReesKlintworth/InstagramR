library(rCharts)
library(shiny)

shinyUI(fluidPage(
  sidebarPanel(
    textInput("username", "Instagram Username:", "rkade93")
  ),
  
  mainPanel(
    showOutput("plot", "highcharts")
  )
))