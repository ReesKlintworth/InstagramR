shinyUI(fluidPage(
  titlePanel("InstagramR"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("User",
        textInputRow("username", "Instagram Username:", "rkade93"),
        numericInputRow("picture_number", "How many pictures?", 20, min=1),
        actionButtonSeparateRow("update_user_data", "Update Data"),
        tags$div(style="margin-bottom:15px;"),
        tabsetPanel(
          tabPanel("Plot", showOutput("user_chart", "highcharts")),
          tabPanel("User Map", showOutput("user_map", "leaflet"))
        )
      ),
      tabPanel("Hashtag",
        textInputRow("hashtag", "Hashtag:", "RkadeKicks"),
        actionButtonSeparateRow("update_hashtag_data", "Update Data"),
        tags$div(style="margin-bottom:15px;"),
        showOutput("map2", "leaflet"))
    ), width=12
  )
))