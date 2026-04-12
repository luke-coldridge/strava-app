# # ****** NOTE *******
# THIS IS A ONE-TIME USE TO GET ALL HISTORIC RUN DETAILS INTO SQL


ids<-runs_meta$id #Get a vector of all activity IDs

#Get activity details for one activity (need to loop over the vector):
details <- GET(url=paste(details_url, ids[14], sep=''),
                config=add_headers("Authorization"=paste("Bearer", access_token, sep= ' '))) 

single_details<-fromJSON(rawToChar(details$content))
print(single_details)

best_efforts<-single_details$best_efforts
best_efforts$moving_time <- hms::as_hms(best_efforts$moving_time) %>% print() #Edit the moving time field to hours:minutes:seconds rather than just seconds
