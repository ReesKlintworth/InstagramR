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
  
  output$plot <- renderChart({
    username <- input$username
    user_url <- paste0("https://api.instagram.com/v1/users/search?q=", username, "&access_token=", token)
    user_info <- fromJSON(getURL(user_url), unexpected.escape="keep")
  
    user_profile <- user_info$data[[1]]
  
    user_id <- user_profile$id
    
    picture_number <- input$picture_number
    if (picture_number > 33)
    {
      picture_number <- 33
    }
  
    recent_url = paste0("https://api.instagram.com/v1/users/", user_id, "/media/recent/?client_id=", client_id, "&count=", picture_number)
    recent_posts <- rev(fromJSON(getURL(recent_url), unexpected.escape="keep")$data)
    
    likes_comments_df = data.frame( number=1:length(recent_posts))
    
    for (i in 1:length(recent_posts))
    {
      likes_comments_df$comments[i] = recent_posts[[i]]$comments$count
      likes_comments_df$likes[i] = recent_posts[[i]]$likes$count
      likes_comments_df$date[i] <- toString(as.POSIXct(as.numeric(recent_posts[[i]]$created_time), origin="1970-01-01"))
    }
    
    h1 <- Highcharts$new()
    h1$set(dom="plot")
    h1$chart(type="spline")
    h1$title(text="Likes and Comments")
    h1$subtitle(text=paste0(picture_number, " Most Recent Posts by ", username))
    h1$series(data=likes_comments_df$likes,name="Likes")
    h1$series(data=likes_comments_df$comments,name="Comments")
    h1$yAxis(title = list(text="Number of Interactions"))
    h1$xAxis(title = list(text="Individual Posts"))
    
    return(h1)
  })
  
  output$map <- renderMap({
    username <- input$username
    user_url <- paste0("https://api.instagram.com/v1/users/search?q=", username, "&access_token=", token)
    user_info <- fromJSON(getURL(user_url), unexpected.escape="keep")
    
    user_profile <- user_info$data[[1]]
    
    user_id <- user_profile$id
    
    picture_number <- input$picture_number
    if (picture_number > 33)
    {
      picture_number <- 33
    }
    
    recent_url = paste0("https://api.instagram.com/v1/users/", user_id, "/media/recent/?client_id=", client_id, "&count=", picture_number)
    recent_posts <- rev(fromJSON(getURL(recent_url), unexpected.escape="keep")$data)
    
    map <- Leaflet$new()
    for (i in 1:length(recent_posts))
    {
      if (!is.null(recent_posts[[i]]$location))
      {
        latitude <- recent_posts[[i]]$location$latitude
        longitude <- recent_posts[[i]]$location$longitude
        map$setView(c(latitude, longitude), zoom=4)
        map$marker(c(latitude, longitude), bindPopup = paste0('<a href="',recent_posts[[i]]$link,'" target="_blank">View image</a>'))
      }
      else
      {
        map$setView(c(0,0), zoom=1)
      }
    }
    map
  })
  
  output$map2 <- renderMap({
    tag <- "rkadekicks"
    recent_url <- paste0("https://api.instagram.com/v1/tags/", tag, "/media/recent?access_token=", token)
    
    recent_posts <- rev(fromJSON(getURL(recent_url), unexpected.escape="keep")$data)
    
    map <- Leaflet$new()
    for (i in 1:length(recent_posts))
    {
      if (!is.null(recent_posts[[i]]$location))
      {
        latitude <- recent_posts[[i]]$location$latitude
        longitude <- recent_posts[[i]]$location$longitude
        map$setView(c(latitude, longitude), zoom=4)
        map$marker(c(latitude, longitude), bindPopup = paste0('<a href="',recent_posts[[i]]$link,'" target="_blank">View image</a>'))
      }
      else
      {
        map$setView(c(0,0), zoom=1)
      }
    }
    map
  })
})