library(httr) #read the libray httr
library(jsonlite)
library(dplyr)
library(hms)
source("load_functions.R")

client_id <- Sys.getenv("CLIENT_ID")
client_secret <- Sys.getenv("CLIENT_SECRET")
refresh_token <- readLines(".strava_refresh_token")

athlete_url <- "https://www.strava.com/api/v3/athlete"
activities_url <- "https://www.strava.com/api/v3/athlete/activities"
details_url <- "https://www.strava.com/api/v3/activities/"

# --------------- Get an access and a refresh token ---------------
access_token <- get_access() 

# --------------- Get the athlete info  ---------------
athlete_res <- GET(url=athlete_url, 
                 config=add_headers("Authorization"=paste("Basic Authorization: Bearer", access_token, sep= ' ')))

athlete <- fromJSON(rawToChar(athlete_res$content))
print(names(athlete))

print(c(athlete$firstname, athlete$lastname, athlete$updated_at))




# ids<-activities$id #Get a vector of all activity IDs

# #Get activity details for one activity (need to loop over the vector):
# details <- GET(url=paste(details_url, ids[14], sep=''),
#                 config=add_headers("Authorization"=paste("Basic Authorization: Bearer", access_token, sep= ' '))) 

# single_details<-fromJSON(rawToChar(details$content))
# print(single_details)

# best_efforts<-single_details$best_efforts
# best_efforts$moving_time <- hms::as_hms(best_efforts$moving_time) %>% print() #Edit the moving time field to hours:minutes:seconds rather than just seconds

