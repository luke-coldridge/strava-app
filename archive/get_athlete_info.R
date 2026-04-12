library(httr) #read the libray httr
library(jsonlite)

source("load_functions.R")

client_id <- Sys.getenv("CLIENT_ID")
client_secret <- Sys.getenv("CLIENT_SECRET")
refresh_token <- readLines(".strava_refresh_token")

access_token <- get_access()

athlete_url <- "https://www.strava.com/api/v3/athlete"
# --------------- Get the athlete info  ---------------

athlete_res <- GET(url=athlete_url, 
                 config=add_headers("Authorization"=paste("Bearer", access_token, sep= ' ')))

athlete <- fromJSON(rawToChar(athlete_res$content)) # Convert the JSON response to an R list

# print(names(athlete))

# print(c(athlete$firstname, athlete$lastname, athlete$updated_at))
