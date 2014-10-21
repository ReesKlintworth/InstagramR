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
    tabsetPanel(
      tabPanel("User Plot", showOutput("plot", "highcharts")),
      tabPanel("User Map", showOutput("map", "leaflet")),
      tabPanel("Hashtag Map", showOutput("map2", "leaflet"))
    )
  )
))