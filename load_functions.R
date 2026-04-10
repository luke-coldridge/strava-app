# ---------- Load all the custom functions in the folder -----------

path <- paste(getwd(),"/functions", sep='') # The path will be the PROJECT-FOLDER/functions

files <- list.files(path, pattern="\\.R$", full.names=TRUE) # Get a list of every R program inside it
for (f in files) source(f) # loop over the list and run each file 
  