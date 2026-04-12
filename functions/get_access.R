# --------------- Get the access and refresh token ---------------

# Get an access_token (reuse the refresh_token we got earlier)
# FLOW: Use Client Secret & Client ID from .Renv 
# and most recent refresh_token from .strava_refresh_token to get an access_token 
# The access_token will allow us to retrieve activities data 


get_access <- function() {

  client_id <- Sys.getenv("CLIENT_ID")
  client_secret <- Sys.getenv("CLIENT_SECRET")
  refresh_token <- readLines(".strava_refresh_token")

  auth_url <- "https://www.strava.com/oauth/token" #The OAuth endpoint

  auth_res <- POST(url=auth_url, 
                 body=list(client_id=client_id, #Client ID provided by Strava app page
                        client_secret=client_secret, #Client Secret provided by Strava app page
                        refresh_token=refresh_token, #authentication code provided by url (after clicking authorize)
                        grant_type="refresh_token"), 
                  encode="form")

  auth <- fromJSON(rawToChar(auth_res$content))

  access_token  <- auth$access_token # Access token used for API calls futher down
  refresh_token <- auth$refresh_token # Refresh token stored for the next call to the auth api

  writeLines(refresh_token, ".strava_refresh_token")
  return(access_token)
  
}
