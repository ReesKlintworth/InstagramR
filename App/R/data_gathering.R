app_name <- "Media and User Analysis"
client_id <- "432555bd340f486281d3a28bd4bd3a9a"
client_secret <- "33220c4d9e9d4e8ab513b21fd842f06e"
scope <- "basic"
token <- "13705907.432555b.4ab9b08b546546dfa7cdd0342dcc5842"

recent_pictures_for_user <- function(input){
  username <- input$username
  user_url <- paste0("https://api.instagram.com/v1/users/search?q=", username, "&access_token=", token)
  user_info <- fromJSON(getURL(user_url), unexpected.escape="keep")
  
  user_profile <- user_info$data[[1]]
  
  user_id <- user_profile$id
  
  picture_number <- input$picture_number
  
  urls <- ceiling(picture_number / 20)
  
  next_url <- paste0("https://api.instagram.com/v1/users/", user_id, "/media/recent/?client_id=",client_id)
  
  recent_pictures <- list()
  counter = 0
  for(counter in 1:urls)
  {
    if (!is.null(next_url))
    {
      if (counter == urls && picture_number%%20 != 0)
      {
        next_url <- paste0(next_url, "&count=", picture_number%%20)
      }
      recent_posts <- fromJSON(getURL(next_url), unexpected.escape="keep")
      recent_pictures <- append(recent_pictures, recent_posts$data)
      next_url <- recent_posts$pagination$next_url
    }
  }
  recent_pictures <- rev(recent_pictures)
}

recent_pictures_for_hashtag <- function(input){
  tag <- input$hashtag
  recent_url <- paste0("https://api.instagram.com/v1/tags/", tag, "/media/recent?access_token=", token)
  recent_posts <- rev(fromJSON(getURL(recent_url), unexpected.escape="keep")$data)
}