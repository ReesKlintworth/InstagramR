library(rCharts)
library(shiny)

shinyUI(fluidPage(
  titlePanel("InstagramR"),
  
  sidebarPanel(
    textInput("username", "Instagram Username:", "rkade93"),
    numericInput("picture_number", "How many pictures?", 20, min=1, max=33),
    submitButton("Submit")
  ),
  
  mainPanel(
    showOutput("plot", "highcharts")
  )
))