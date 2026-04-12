# ****** NOTE *******
# THIS WAS A ONE-TIME USE TO GET ALL HISTORIC DATA INTO SQL. I'M SAVING IT BECAUSE IT'S PRETTY


library(httr) # currently needed for get_access(), will convert to httr2
library(jsonlite) # currently needed for get_access(), will convert to httr2

library(httr2) # for api interactions
library(dplyr) # for %>% and bind_rows
library(hms) # for conversions to hh:mm:ss
library(DBI) # for connection to the Database
library(RPostgres) # for interactions with postgres

source("load_functions.R")
options(scipen=999)

activities_url <- "https://www.strava.com/api/v3/athlete/activities"

# --------------- Get an access and a refresh token ---------------
access_token <- get_access() 


# --------------- Get all activities  ---------------

# Loop through max 200 activities at a time and append 
i <- 1
repeat {
  activities <- request(activities_url) %>% # hand httr2 the url
    req_auth_bearer_token(access_token) %>% # authorize with the access_token
        req_url_query(page=i,
                      per_page=200) %>% # add optional extras 
            req_perform() %>% # ping the API
                resp_body_json() # Handle the response


    some_runs <- Filter(function(activity) activity$sport_type == "Run", activities)  # Filter to just runs
    rm(activities) # Delete the whole activities table
  
    # if there are no more runs then stop
    if (length(some_runs) == 0) break
  
    runs <- c(runs, some_runs)
    i <- i+1
}
rm(some_runs)

# str(runs[[1]]) # Show the STRucture of one of the nested tables 

runs_meta <- lapply(runs, function(run) # For each run in runs list, select the following columns:
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

# --------------- convert the dataframe to an SQL table  ---------------

  dbWriteTable(
    con, # use the connection details created by the 'Connections' tab
    name = DBI::Id(schema = "strava", table = "runs_meta"), # Specifically put the table inside the strava schema
    value = runs_meta, # write the runs_meta df
    overwrite = TRUE 
)
