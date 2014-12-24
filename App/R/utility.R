
get_locations <- function(recent_posts){
  names <- list()
  latitudes <- vector()
  longitudes <- vector()
  urls <- vector()
  for (i in 1:length(recent_posts))
  {
    if (!is.null(recent_posts[[i]]$location) && !is.null(recent_posts[[i]]$location$name))
    {
      names <- c(names, recent_posts[[i]]$location$name)
      latitude <- recent_posts[[i]]$location$latitude
      longitude <- recent_posts[[i]]$location$longitude
      latitudes <- c(latitudes, latitude)
      longitudes <- c(longitudes, longitude)
      urls <- c(urls, paste0('<div><a href="',recent_posts[[i]]$link,'" target="_blank">View image</a></div>'))
    }
  }
  locations <- data.frame(Name=unlist(names), Latitude=latitudes, Longitude=longitudes, Url=urls)
  if(nrow(locations) == 0){
    return(NULL)
  }
  unique_locations <- as.list(levels(unique(locations$Name)))
  
  unique_location_information <- as.data.frame(t(sapply(unique_locations, function(unique_location){
    text <- ""
    name <- unique_location
    latitude <- NULL
    longitude <- NULL
    apply(locations, 1, function(location){
      if (as.character(location[1]) == as.character(unique_location))
      {
        if (is.null(latitude) || is.null(longitude)){
          latitude <<- location[2]
          longitude <<- location[3]
        }
        text <<- paste0(text, location[4])
      }
    })
    row <- list(Name=name, Latitude=latitude, Longitude=longitude, Text=text)
    row
  })), stringsAsFactors=FALSE)
  unique_location_information
}