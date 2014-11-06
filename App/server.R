shinyServer(function(input, output){
  
  observe({
    if(input$update_user_data == 0 && !initial_user) {
      return()
    }
    isolate({
      initial_user = FALSE
      username <- input$username
      recent_pictures <- recent_pictures_for_user(input)
      picture_number <- length(recent_pictures)
      output$user_chart <- renderChart({
        likes_comments_df = data.frame( number=1:length(recent_pictures))
        
        for (i in 1:length(recent_pictures))
        {
          likes_comments_df$comments[i] = recent_pictures[[i]]$comments$count
          likes_comments_df$likes[i] = recent_pictures[[i]]$likes$count
          likes_comments_df$date[i] <- toString(as.POSIXct(as.numeric(recent_pictures[[i]]$created_time), origin="1970-01-01"))
        }
        
        h1 <- Highcharts$new()
        h1$set(dom="user_chart")
        h1$chart(type="spline")
        h1$title(text="Likes and Comments")
        h1$subtitle(text=paste0(picture_number, " Most Recent Posts by ", username))
        h1$series(data=likes_comments_df$likes,name="Likes")
        h1$series(data=likes_comments_df$comments,name="Comments")
        h1$yAxis(title = list(text="Number of Interactions"))
        h1$xAxis(title = list(text="Individual Posts"))
        h1
      })
      
      output$user_map <- renderMap({
        map <- Leaflet$new()
        
        for (i in 1:length(recent_pictures))
        {
          if (!is.null(recent_pictures[[i]]$location))
          {
            latitude <- recent_pictures[[i]]$location$latitude
            longitude <- recent_pictures[[i]]$location$longitude
            map$setView(c(latitude, longitude), zoom=4)
            map$marker(c(latitude, longitude), bindPopup = paste0('<a href="',recent_pictures[[i]]$link,'" target="_blank">View image</a>'))
          }
          else
          {
            map$setView(c(0,0), zoom=1)
          }
        }
        map
      })
    })
  })
  
  observe({
    if (input$update_hashtag_data == 0 && !initial_hashtag)
    {
      return()
    }
    
    isolate({
      initial_hashtag = FALSE
      recent_pictures <- recent_pictures_for_hashtag(input)
      output$map2 <- renderMap({
        map <- Leaflet$new()
        for (i in 1:length(recent_pictures))
        {
          if (!is.null(recent_pictures[[i]]$location))
          {
            latitude <- recent_pictures[[i]]$location$latitude
            longitude <- recent_pictures[[i]]$location$longitude
            map$marker(c(latitude, longitude), bindPopup = paste0('<a href="',recent_pictures[[i]]$link,'" target="_blank">View image</a>'))
          }
        }
        map$setView(c(0,0), zoom=1)
        map
      })
    })
  })
})