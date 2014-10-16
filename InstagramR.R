# Instagram Analysis
# Rees Klintworth
# Created 10-14-14

# Packages
require(httpuv)
require(httr)
require(rCharts)
require(rjson)
require(RCurl)

## Uncomment the following four lines to determine the callback URL to register with Instagram
# full_url <-oauth_callback()
# full_url <- gsub("(.*localhost:[0-9]{1,5}/).*", x=full_url, replacement="\\1")
# print(full_url)

app_name <- "Media and User Analysis"
client_id <- "432555bd340f486281d3a28bd4bd3a9a"
client_secret <- "33220c4d9e9d4e8ab513b21fd842f06e"
scope = "basic"

instagram <- oauth_endpoint(
  authorize="https://api.instagram.com/oauth/authorize",
  access="https://api.instagram.com/oauth/access_token")
my_app <- oauth_app(app_name, client_id, client_secret)

ig_oauth <- oauth2.0_token(instagram, my_app, scope="basic",  type="application/x-www-form-urlencoded", cache=FALSE)
tmp <- strsplit(toString(names(ig_oauth$credentials)), '"')
token <- tmp[[1]][4]

username <- "rkade93"
user_url <- paste0("https://api.instagram.com/v1/users/search?q=", username, "&access_token=", token)
user_info <- fromJSON(getURL(user_url), unexpected.escape="keep")

user_profile <- user_info$data[[1]]

user_id <- user_profile$id

recent_url = paste0("https://api.instagram.com/v1/users/", user_id, "/media/recent/?access_token=", token)
recent_posts <- fromJSON(getURL(recent_url), unexpected.escape="keep")$data

likes_comments_df = data.frame( number=1:length(recent_posts))

for (i in 1:length(recent_posts))
{
  likes_comments_df$comments[i] = recent_posts[[i]]$comments$count
  likes_comments_df$likes[i] = recent_posts[[i]]$likes$count
  likes_comments_df$date[i] <- toString(as.POSIXct(as.numeric(recent_posts[[i]]$created_time), origin="1970-01-01"))
}

#m1 <- mPlot(x = "date", y = c("likes", "comments"), type = "Line", data = likes_comments_df)

h1 <- Highcharts$new()
h1$chart(type="spline")
h1$series(data = likes_comments_df$likes)
h1$series(data = likes_comments_df$comments)
print(h1)