library(httpuv)
library(httr)
library(rCharts)
library(rjson)
library(RCurl)
library(shiny)

shinyServer(function(input, output){
  app_name <- "Media and User Analysis"
  client_id <- "432555bd340f486281d3a28bd4bd3a9a"
  client_secret <- "33220c4d9e9d4e8ab513b21fd842f06e"
  scope <- "basic"
  token <- "13705907.432555b.4ab9b08b546546dfa7cdd0342dcc5842"
  
#   instagram <- oauth_endpoint(
#     authorize="https://api.instagram.com/oauth/authorize",
#     access="https://api.instagram.com/oauth/access_token",)
#   my_app <- oauth_app(app_name, client_id, client_secret)
#   
#   ig_oauth <- oauth2.0_token(instagram, my_app, scope="basic",  type="application/x-www-form-urlencoded", cache=FALSE)
#   tmp <- strsplit(toString(names(ig_oauth$credentials)), '"')
#   token <- tmp[[1]][4]
  
  output$plot <- renderChart({
    user_url <- paste0("https://api.instagram.com/v1/users/search?q=", input$username, "&access_token=", token)
    user_info <- fromJSON(getURL(user_url), unexpected.escape="keep")
  
    user_profile <- user_info$data[[1]]
  
    user_id <- user_profile$id
    
    picture_number <- input$picture_number
    if (picture_number > 33)
    {
      picture_number <- 33
    }
  
    recent_url = paste0("https://api.instagram.com/v1/users/", user_id, "/media/recent/?client_id=", client_id, "&count=", picture_number)
    recent_posts <- fromJSON(getURL(recent_url), unexpected.escape="keep")$data
    
    likes_comments_df = data.frame( number=1:length(recent_posts))
    
    for (i in 1:length(recent_posts))
    {
      likes_comments_df$comments[i] = recent_posts[[i]]$comments$count
      likes_comments_df$likes[i] = recent_posts[[i]]$likes$count
      likes_comments_df$date[i] <- toString(as.POSIXct(as.numeric(recent_posts[[i]]$created_time), origin="1970-01-01"))
    }
    
    m1 <- mPlot(x = "date", y = c("likes", "comments"), type = "Line", data = likes_comments_df)
    h1 <- Highcharts$new()
    h1$set(dom="plot")
    h1$chart(type="spline")
    h1$title(text="Likes and Comments")
    h1$subtitle(text=paste0(picture_number, " Most Recent Posts"))
    h1$series(data=likes_comments_df$likes,name="Likes")
    h1$series(data=likes_comments_df$comments,name="Comments")
    
    return(h1)
  })
})