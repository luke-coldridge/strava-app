# THIS WAS A SINGLE TIME USE TO GET A REFRESH TOKEN

library(httr) 
library(jsonlite)

client_id<-Sys.getenv("CLIENT_ID")
client_secret<-Sys.getenv("CLIENT_SECRET")

oauth_token<-"XXXXXX" #single-time use - got from url after clicking 'authorize'



auth_url<-"https://www.strava.com/oauth/token" #The OAuth endpoint
auth_res<-POST(url=auth_url, 
              body=list(client_id=client_id, #Client ID provided by Strava app page
                        client_secret=client_secret, #Client Secret provided by Strava app page
                        code=oauth_token, #authentication code provided by url (after clicking authorize)
                        grant_type="authorization_code"), 
                encode="form")

auth<-fromJSON(rawToChar(auth_res$content)) #Convert the response (JSON) to a dataframe
refresh_token<-auth$refresh_token
print(refresh_token)