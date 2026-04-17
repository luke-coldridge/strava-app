library(httr) #read the libray httr
library(jsonlite)

library(httr2)
library(dplyr)
library(hms)
library(DBI)
source("load_functions.R")

activities_url <- "https://www.strava.com/api/v3/athlete/activities"
details_url <- "https://www.strava.com/api/v3/activities/" # NOTE the difference is 'athlete' isn't in the URL

# --------------- Get an access and a refresh token ---------------
access_token <- get_access()

# --------------- Get the activities in the last 24 hours ---------------
today <- Sys.Date()
yesterday <- today - 1

after <- as.numeric(as.POSIXct(paste(yesterday, "22:00:01"))) # We only want the data after 10PM yesterday
before <- as.numeric(as.POSIXct(paste(today, "22:00:00"))) # ...and before 10pm today

activities <- request(activities_url) %>% # hand httr2 the url
req_auth_bearer_token(access_token) %>% # authorize with the access_token
    req_url_query(after=after, # Only pull the activities X : after <= x <= before
                  before=before) %>% # add optional extras 
        req_perform() %>% # ping the API
            resp_body_json() # Handle the response

runs <- Filter(function(activity) activity$sport_type == "Run", activities)
rm(activities)

new_runs <- lapply(runs, function(run) # For each run in runs list, select the following columns:
    list(
        id=as.character(run$id), # Convert the IDs to character
        start_dt=as.POSIXct(run$start_date_local, format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
        name=run$name,
        distance=run$distance/1000, # Convert the distance from m to km
        moving_time=hms::as_hms(run$moving_time), # convert the times to hh:mm:ss
        elapsed_time=hms::as_hms(run$elapsed_time),
        elevation=run$total_elevation_gain,
        avg_hr=run$average_heartrate,
        max_hr=run$max_heartrate,
        kudos=run$kudos_count,
        flagged=run$flagged, # We'll keep the flagged flag so we can drop out any flagged runs
        location_city=run$location_city,
        location_country=run$location_country
    )) %>% 
    dplyr::bind_rows()

# Append any new runs to the master table
DBI::dbWriteTable(
    con,
    name=DBI::Id(schema="strava", table="runs_meta"),
    value=new_runs,
    append=TRUE
)

# Now get the details of those new runs:

