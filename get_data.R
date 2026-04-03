library(httr) #read the libray httr
library(jsonlite)

client_id<-Sys.getenv("CLIENT_ID")
client_secret<-Sys.getenv("CLIENT_SECRET")
refresh_token <- readLines(".strava_refresh_token")


athlete_url<-"https://www.strava.com/api/v3/athlete"
activities_url<-"https://www.strava.com/api/v3/athlete/activities"
auth_url<-"https://www.strava.com/oauth/token" #The OAuth endpoint

# Get an access_token (reuse the refresh_token we got earlier)
# FLOW: Use Client Secret & Client ID from .Renv 
# and most recent refresh_token from .strava_refresh_token to get an access_token 
# The access_token will allow us to retrieve activities data 

auth_res<-POST(url=auth_url, 
              body=list(client_id=client_id, #Client ID provided by Strava app page
                        client_secret=client_secret, #Client Secret provided by Strava app page
                        refresh_token=refresh_token, #authentication code provided by url (after clicking authorize)
                        grant_type="refresh_token"), 
                encode="form")

auth <- fromJSON(rawToChar(auth_res$content))

access_token  <- auth$access_token
refresh_token <- auth$refresh_token

writeLines(refresh_token, ".strava_refresh_token")

print(access_token)

athlete_res<-GET(url=athlete_url, config=add_headers("Authorization"=paste("Basic Authorization: Bearer", access_token, sep= ' ')))
print(athlete_res)

athlete<-fromJSON(rawToChar(athlete_res$content))
print(names(athlete))

print(c(athlete$firstname, athlete$lastname, athlete$updated_at))


activities_res<-GET(url=activities_url, add_headers("Authorization"=paste("Basic Authorization: Bearer", access_token, sep= ' ')))
print(activities_res) #confirm the 200 response

activities<-fromJSON(rawToChar(activities_res$content))
print(activities)






# print(res)




# 18c519cb56497e0be0976fc89624862f661971fe