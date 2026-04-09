library(DBI)
library(RPostgres)

# Create a schema (think of it like a caslib)
# DBI::dbExecute(con, "CREATE SCHEMA IF NOT EXISTS strava;")

# Create a blank table inside the schema (with 2 columns)
# DBI::dbExecute(con, "
#   CREATE TABLE strava.names (
#     id SERIAL PRIMARY KEY,
#     name TEXT
#   );
# ")

# Add a row to the table 

DBI::dbExecute(con, "
  INSERT INTO strava.names (name) 
  VALUES 
    ('Luke'),
    ('Monika'),
    ('Zuzia');
")