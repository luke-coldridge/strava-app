library(httr) #read the libray httr
library(jsonlite)
library(dplyr)
library(hms)
source("load_functions.R")

activities_url <- "https://www.strava.com/api/v3/athlete/activities"

# --------------- Get an access and a refresh token ---------------
access_token <- get_access()

# --------------- Get the activities in the last 24 hours ---------------
today <- Sys.Date()
yesterday <- today - 1

after <- as.numeric(as.POSIXct(paste(yesterday, "22:00:01"))) # We only want the data after 10PM yesterday
before <- as.numeric(as.POSIXct(paste(today, "22:00:00"))) # ...and before 10pm today


# NOTE: CONVERT THIS TO HTTR2
activities_res<-GET(url=activities_url, 
                    config=add_headers("Authorization"=paste("Basic Authorization: Bearer", access_token, sep= ' ')),
                    query=list(
                        after=after,
                        before=before
                 ))


activities<-fromJSON(rawToChar(activities_res$content))

# FILTER TO JUST RUNS

# IF THERE'S A NEW RUN, APPEND IT TO THE MASTER TABLE
