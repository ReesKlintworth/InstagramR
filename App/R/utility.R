
get_locations <- function(recent_posts){
  names <- list()
  latitudes <- vector()
  longitudes <- vector()
  urls <- vector()
  for (i in 1:length(recent_posts))
  {
    if (!is.null(recent_posts[[i]]$location))
    {
      names <- c(names, recent_posts[[i]]$location$name)
      latitude <- recent_posts[[i]]$location$latitude
      longitude <- recent_posts[[i]]$location$longitude
      latitudes <- c(latitudes, latitude)
      longitudes <- c(longitudes, longitude)
      urls <- c(urls, paste0('<div><a href="',recent_posts[[i]]$link,'" target="_blank">View image</a></div>'))
    }
  }
  locations <- data.frame(unlist(names), latitudes, longitudes, urls)
  colnames(locations) <- c("Name", "Latitude", "Longitude", "url")
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
  print(unique_location_information)
  unique_location_information
}