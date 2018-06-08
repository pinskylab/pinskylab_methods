# helper scripts for field work
library(dplyr)
library(lubridate)
# read_db ####
#' views all of the fish recaptured at a given site
#' @export
#' @name read_db
#' @author Michelle Stuart
#' @param x = which db?
#' @examples 
#' db <- read_Db("Leyte")

read_db <- function(db_name){
  
  db <- src_mysql(dbname = db_name, default.file = path.expand("~/myconfig.cnf"), port = 3306, create = F, host = NULL, user = NULL, password = NULL)
  return(db)
}

# anem_date ####
#' allows you to find the date based on the anem_table_id
#' @param x = anem_table_id - Where are the anem_table_id's located?
#' @keywords 
#' @export
#' @examples
#' anem_date(anem_table_id)
#' anem_date(2206)

anem_date <- function(anem_tbl_id){
  leyte <- read_db("Leyte")
  anem <- leyte %>% 
    tbl("anemones") %>% 
    filter(anem_table_id %in% anem_tbl_id) %>% 
    select(dive_table_id, anem_table_id) %>% 
    collect()
  
  day <- leyte %>% 
    tbl("diveinfo") %>%
    select(date, dive_table_id) %>%
    collect() %>% 
    filter(dive_table_id %in% anem$dive_table_id)
  
  day <- left_join(day, anem, by ="dive_table_id")
  return(day)
}

# fish_date ####
#' allows you to find the date based on the fish_table_id
#' @param x = fish_table_id - Where are the fish_table_ids's located?
#' @keywords 
#' @export
#' @examples
#' fish_date(anem_table_id)
#' fish_date(2206)

fish_date <- function(fish_tbl_id){
  leyte <- read_db("Leyte")
  fish <- leyte %>% 
    tbl("clownfish") %>% 
    filter(fish_table_id %in% fish_tbl_id) %>% 
    select(fish_table_id, anem_table_id) %>% 
    collect()
  anem <- leyte %>% 
    tbl("anemones") %>% 
    filter(anem_table_id %in% fish$anem_table_id) %>% 
    select(anem_table_id, dive_table_id) %>% 
    collect()
  anem <- left_join(fish, anem, by = "anem_table_id") 
  
  day <- leyte %>% 
    tbl("diveinfo") %>%
    select(date, dive_table_id) %>%
    collect() %>% 
    filter(dive_table_id %in% anem$dive_table_id)
  
  day <- left_join(day, anem, by ="dive_table_id")
  return(day)
}

# anem_site ####
#' return a table of anem_id and site
#' @export
#' @name read_db
#' @author Michelle Stuart
#' @param x = anem_id
#' @examples 
#' sites <- anem_site(anems)

anem_site <- function(anem_table_with_dive_ids){
  x <- leyte %>% 
    tbl("diveinfo") %>% 
    filter(dive_table_id %in% anem_table_with_dive_ids$dive_table_id) %>% 
    select(dive_table_id, site) %>% 
    collect()
  anems <- left_join(anem_table_with_dive_ids, x, by = "dive_table_id")
  return(anems)
}

# anem_latlong ####
anem_latlong <- function(anem_table_with_dive_ids){
  library(tidyr)
  library(lubridate)
  anem <- anem_table_with_dive_ids %>% 
    filter(!is.na(anem_id)) %>% 
    separate(obs_time, into = c("hour", "minute", "second"), sep = ":") %>% 
    mutate(gpx_hour = as.numeric(hour) - 8) %>% 
    mutate(minute = as.numeric(minute))
  
  dive <- leyte %>%
    tbl("diveinfo") %>%
    filter(dive_table_id %in% anem$dive_table_id) %>%
    select(dive_table_id, date, site, gps) %>%
    collect()

    anem <- left_join(anem, dive, by = c("dive_table_id", "date"))
    anem <- rename(anem, unit = gps)

  # fix date if gpx hour is less than 0
  test <- anem %>% 
    filter(gpx_hour < 0)
  
  if (nrow(test) > 0){
    anem <- anem %>%
      mutate(gpx_date = date) # create a new gpx date column
    
    other <- anem %>% 
      filter(gpx_hour < 0) 
    
    # remove from anem table
    anem <- anti_join(anem, other)
    
    # subtract date
    other <- other %>% 
      mutate(gpx_date = as.character(ymd(date) - days(1))) %>% 
      mutate(gpx_hour = gpx_hour + 24)
    
    # rejoin rows
    anem <- rbind(anem, other)
    
  }else{
    anem <- anem %>% mutate(gpx_date = date)
  }
  
  # find the lat long for this anem
  lat <- leyte %>%
    tbl("GPX")  %>% 
    mutate(gpx_date = date(time)) %>%
    filter(gpx_date %in% anem$gpx_date) %>% 
    mutate(gpx_hour = hour(time)) %>%
    mutate(minute = minute(time)) %>%
    mutate(second = second(time)) %>%
    select(-time, -second)%>%
    collect(n=Inf) 
  
  sum_lat <- lat %>%
    group_by(unit, gpx_date, gpx_hour, minute) %>% 
    summarise(lat = mean(as.numeric(lat)),
      lon = mean(as.numeric(lon)))
  
  anem <- left_join(anem, sum_lat, by = c("unit", "gpx_date", "gpx_hour", "minute"))
  return(anem)
}

# -------------------------------------------------------------------
#   Field functions - functions used while working in the Philippines
# -------------------------------------------------------------------
library(dplyr)
# excl ####
#'is a function to read any excel sheet "x", into R with the defined col_types "y", if you don't want to define you col_types, you must enter NULL. 
#' @export
#' @name excl
#' @author Michelle Stuart
#' @param x = sheet name in quotes
#' @param y = col_types in a list 
#' @examples 
#' surv <- excl("diveinfo", NULL)
#' 
#' clowncol <- c("text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text", "text")
#' clown <- excl("clownfish", clowncol)

excl <- function(sheet_name_in_quotes, list_of_col_types) {
  excl <- readxl::read_excel(excel_file, sheet = x, col_names = T, col_types = y)
  return(excl)
}


# comparedives #### 
#' is a function that compares the anem ids on the clownfish sheet to the anem ids on the anemone sheet by dive number for the 2017 field season.
#' @export
#' @name compare_dives
#' @author Michelle Stuart
#' @param x = clowndive - a list of dive numbers found on the clownfish sheet
#' @examples 
#' bad <- comparedives(clowndive)

compare_dives <- function(list_of_dive_nums) {
  for (i in 1:length(list_of_dive_nums)){
    fishanem <- filter(clown, dive_num == list_of_dive_nums[i]) # for one dive at a time in the fish table
    anemanem <- filter(anem, dive_num == list_of_dive_nums[i]) # and the anem table
    good <- filter(fishanem, anemid %in% anemanem$anemid) # find all of the anems that are in the anem table
    bad <- anti_join(fishanem, good) # and those anems that aren't
    bad <- filter(bad, anemid != "????") # except for any with an unknown anem 
    return(bad)
  }
}


# from_scanner #### 
#' is a function that reads the pit scanner text file into R.
#' @export
#' @name from_scanner
#' @author Michelle Stuart
#' @param x = pitfile (the path to the pit scanner file)
#' @examples 
#' pit <- from_scanner(pitfile)

from_scanner <- function(pitfile) {
  library(readr)
  library(tibble)
  library(tidyr)
  pit <- readr::read_csv(pitfile,
    col_names = c("city", "tagid", "date", "time"), 
    col_types = cols(
      city = col_character(),
      tagid = col_character(),
      date = col_character(), # have to specify as string  
      time = col_character() # have to specify as string
    )
  )
  pit <- pit %>% 
    distinct() %>% 
    as_tibble() %>% 
    unite(scan, city, tagid, sep = "")
  return(pit)
}

# name_gps ####
#' is a function that names all of our gps units.  Sure, 5 isn't that many right now but as they fail and we buy more it will help to have a function that does this for us. 
#' @export
#' @name name_gps
#' @author Michelle Stuart
#' @param 
#' @examples 
#' gps <- name_gps()
name_gps <- function() {
  gps <- c()
  for (i in 1:7){ # because we have 7 gps units
    x <- paste("gps", i, sep = "")
    gps <- c(gps, x)
  }
  return(gps)
}


# used_gps ####
#' is a function that checks the folders of all of the gps units and determines which contain data. 
#' @export
#' @name used_gps
#' @author Michelle Stuart
#' @param 
#' @examples 
#' gps <- used_gps(gps)

used_gps <- function(gps) {
  for (i in 1:length(gps)){
    test <- list.files(path = paste("data/", gps[i], sep = ""), pattern = "*Track*")
    if (length(test) == 0){
      gps[[i]] <- NA
    }
  }
  gps <- gps[!is.na(gps)]
  return(gps)
}


# index_line ####
#' a function that reads through each line of an index and writes an output file in gpx format
#' @export
#' @name index_line
#' @author Michelle Stuart
#' @param x = one line of an index
#' @param y = one track file
#' @param dat = a table of gpx data
#' @examples 
#' index_line(inds[j, ], files[i])

index_line <- function(x, y, dat){
  # if no pause
  if(is.na(x$paust)){
    # find the GPX points that fit within the survey
    track <- dat %>%
      filter(time >= x$start & time <= x$end) %>% 
      mutate(
        lat = as.character(lat),
        lon = as.character(lon),
        elev = as.character(elev),
        time = as.character(time)
      )
    writeGPX(filename = str_c("data/gpx_trimmed/GPS", track$unit[1], "_", x$dive_num, "_", y, sep=""), outfile = track)
  }
  # account for a pause if need be
  if(!is.na(x$paust)){
    track1 <- dat %>%
      filter(time >= x$start & time <= x$paust) %>% 
      mutate(
        lat = as.character(lat),
        lon = as.character(lon),
        elev = as.character(elev),
        time = as.character(time)
      )
    track2 <- dat %>%
      filter(time >= x$pausend & time <= x$end) %>% 
      mutate(
        lat = as.character(lat),
        lon = as.character(lon),
        elev = as.character(elev),
        time = as.character(time)
      )
    if (nrow(track2) > 0){
      # write as two tracks
      writeGPX(filename = paste("data/gpx_trimmed/GPS", track1$unit[1], "_",x$dive_num, "_", y, '_1.gpx', sep=''), outfile = track1) 
      writeGPX(filename = paste("data/gpx_trimmed/GPS", track2$unit[1], "_",x$dive_num, "_", y, '_2.gpx', sep=''), outfile = track2)  
    }else{
      # debugonce(writeGPX)
      writeGPX(filename = str_c("data/gpx_trimmed/GPS", track1$unit[1], "_", x$dive_num, "_", y, sep=""), outfile = track1)
    }
    
  }
  
}

# read_db ####
#' views all of the fish recaptured at a given site
#' @export
#' @name read_db
#' @author Michelle Stuart
#' @param x = which db?
#' @examples 
#' db <- read_Db("Leyte")

read_db <- function(db_name){
  
  db <- src_mysql(dbname = db_name, default.file = path.expand("~/myconfig.cnf"), port = 3306, create = F, host = NULL, user = NULL, password = NULL)
  return(db)
}

#' Read GPX Garmin
#'
#' This function allows you to read gpx files generated on the Garmin GPS unit.
#' @param filename What gpx file would you like to read?
#' @keywords gpx
#' @export
#' @examples
#' readGPXGarmin(filename)

# Read a .gpx file and return a dataframe of time, lat, long, and elevation, as well as the header data
# Treats the file as only one trkseg (and may not work on files with multiple trksegs)

readGPXGarmin <- function(filename){
  library(stringr)
  
  infile <- readr::read_file(filename) 
  
  # infile <- readLines(filename, warn=FALSE)
  lines <- strsplit(infile, split="<trkpt", fixed=TRUE)[[1]] # split into each point
  header <- lines[1]
  lines <- lines[2:length(lines)]
  
  
  lat <- lines %>% 
    str_extract_all("lat=\"\\d+\\.\\d+\"") %>% 
    str_replace_all("lat=\"","") %>% 
    str_replace_all("\"", "")
  
  lon <- lines %>% 
    str_extract_all("lon=\"\\d+\\.\\d+\"") %>% 
    str_replace_all("lon=\"","") %>% 
    str_replace_all("\"", "")
  
  
  elev <- lines %>% 
    str_extract_all("ele>\\d+\\.\\d+") %>% 
    str_replace_all("ele>","")
  
  
  time <- lines %>% 
    str_extract_all("time>\\d+-\\d+-\\d+T\\d+:\\d+:\\d+Z</time></t") %>% 
    str_replace_all("time>", "") %>% 
    str_replace_all("T", " ") %>% 
    str_replace_all("Z</</t", "")
  
  
  data <- data.frame(lat, lon, elev, time)
  
  
  out <- list(header=header, data=data)
  
  return(out)
}

#' Write GPX
#'
#' This function allows you to write GPX format given the header and the data from readGPXGarmin_2013_06_01.R
#' @param outfile The file name of the output
#' @param filename The name of the input
#' @keywords gpx
#' @export
#' @examples
#' writeGPX(outfile, filename)


writeGPX = function(outfile, filename){
  con = file(filename, open = 'wt')
  cat(header, file=con) # write the same header
  
  # add the data
  
  for(i in 1:nrow(outfile)){
    cat('<trkpt lat="', file=con)
    cat(outfile$lat[i], file=con)
    cat('" lon="', file=con)
    cat(outfile$lon[i], file=con)
    cat('"><ele>', file=con)
    cat(outfile$elev[i], file=con)
    cat('</ele><time>', file=con)
    cat(str_sub(outfile$time[i],1,10), file=con)
    cat("T", file = con)
    cat(str_sub(outfile$time[i],12,19), file=con)
    cat('Z</time></trkpt>', file=con)
  }
  
  # finish up the file
  cat('</trkseg></trk></gpx>', file=con)
  
  # close up
  close(con)
}



#' get_from_google
#'
#' This function pulls both the clownfish and diveinfo from the google spreadsheet 2018_clownfish_data_entry
#' @keywords 
#' @export
#' @examples
#' get_from_google()

get_from_google <- function(){
  # if data is accessible in google sheets:
  library(googlesheets)
  library(stringr)
  # gs_auth(new_user = TRUE) # run this if having authorization problems
  mykey <- '1symhfmpQYH8k9dAvp8yV_j_wCTpIT8gO9No4s2OIQXo' # access the file
  entry <-gs_key(mykey)
  clown <<-gs_read(entry, ws='clownfish') %>% 
    mutate(obs_time = as.character(obs_time))
  dive <<- gs_read(entry, ws="diveinfo")
  
  # save data in case network connection is lost
  clownfilename <- str_c("data/google_sheet_backups/clown_", Sys.time(), ".Rdata", sep = "")
  divefilename <- str_c("data/google_sheet_backups/dive_", Sys.time(), ".Rdata", sep = "")
  save(clown, file = clownfilename)
  save(dive, file = divefilename)
}

# assign_gpx_field ####
#' assign lat lons to a table from field data (directory of gpx files)
#' @export
#' @name assign_gpx
#' @author Michelle Stuart
#' @param id_table = a table that contains an id, gps_unit, and date_time in UTC
#' @examples 
#' result <- assign_gpx_field(anem_table)
assign_gpx_field <- function(id_table){
  
  # need to be able to compare dates and times
  id_table <- id_table %>% 
    mutate(obs_time = force_tz(ymd_hms(str_c(date, obs_time, sep = " ")), tzone = "Asia/Manila"), 
      gps = as.character(gps))
  
  # convert to UTC
  id_table <- id_table %>% 
    mutate(obs_time = with_tz(obs_time, tzone = "UTC"), 
      id = 1:nrow(id_table))
  
  id_table <- id_table %>% 
    mutate(month = month(obs_time), 
      day = day(obs_time), 
      hour = hour(obs_time), 
      min = minute(obs_time), 
      sec = second(obs_time), 
      year = year(obs_time))
  
  # create table of lat lon data ####
  # make an empty data frame for later
  gpx <- data.frame()
  
  # define the list of gps units
  gps <- name_gps()
  
  # determine which gps units have data & remove empties
  gps <- used_gps(gps)
  
  for (l in 1:length(gps)){
    files <- list.files(path = paste("data/",gps[l], sep = ""), pattern = "*Track*")
    for(i in 1:length(files)){ # for each file
     # parse the gpx into useable data
        infile <- readGPXGarmin(paste("data/", gps[l], "/", files[i], sep="")) # list of 2 itmes, header and data
        header <<- infile$header
        dat <- infile$data
        dat$time <- ymd_hms(dat$time)
        instarttime <<-  dat$time[1] # start time for this GPX track
        inendtime <<- dat$time[nrow(dat)] # end time for this GPX track
        dat$elev <- 0 # change elevation to zero
        dat$unit <- substr(gps[l],4,4)
    
      gpx <- rbind(gpx, dat)
    }
  }
  
  gpx <- gpx %>%
    mutate(month = month(time), 
      day = day(time), 
      hour = hour(time), 
      min = minute(time), 
      sec = second(time), 
      year = year(time), 
      lat = as.character(lat), # to prevent from importing as factors
      lon = as.character(lon), 
      time = as.character(time)) %>% 
    rename(gps = unit)
  
  
  
  # find matches for times to assign lat long - there are more than one set of seconds (sec.y) that match
  id_table <- left_join(id_table, gpx, by = c("gps", "month", "day", "hour", "min", "year")) %>% 
    mutate(lat = as.numeric(lat), 
      lon = as.numeric(lon)) # need to make decimal 5 digits - why? because that is all the gps can hold
  
  # calculate a mean lat lon for each anem observation
  coord <- id_table %>%
    group_by(id) %>% # id should be referring to one row of the data
    summarise(mlat = mean(lat, na.rm = TRUE),
      mlon = mean(lon, na.rm = T))
  
  # drop all of the unneccessary columns from anem and join with the coord
  id_table <- id_table %>% 
    select(gps, dive_num, obs_time, ends_with("id"), anem_spp)
  
  id_table <- left_join(coord, id_table, by = "id") %>% 
    rename(lat = mlat, 
      lon = mlon) %>% 
    distinct()
  return(id_table)
}

# get_data_no_net ####
#' get the data when no network is present
#' @export
#' @name get_data_no_net
#' @author Michelle Stuart
#' @examples 
#' get_data_no_net()

get_data_no_net <- function(){
  # load data from saved if network connection is lost ####
  # get list of files
  clown_files <- sort(list.files(path = "data/google_sheet_backups/", pattern = "clown_201*"), decreasing = T)
  dive_files <- sort(list.files(path = "data/google_sheet_backups/", pattern = "dive_201*"), decreasing = T)
  clown_filename <<- paste("data/google_sheet_backups/", clown_files[1], sep = "")
  dive_filename <<- paste("data/google_sheet_backups/", dive_files[1], sep = "")
  
}

assign_db_gpx <- function() {
  # get past data  - in the lab ####
  leyte <- read_db("Leyte")
  anem <- leyte %>% 
    tbl("anemones") %>% 
    select(anem_table_id, dive_table_id, obs_time, old_anem_id, anem_id, anem_obs, anem_spp) %>% 
    filter(!is.na(anem_id)) %>% 
    collect()
  
  # assign gps from db ####
  # need date and gps unit - in the lab ####
  dive <- leyte %>% 
    tbl("diveinfo") %>% 
    select(dive_table_id, date, gps) %>% 
    filter(dive_table_id %in% anem$dive_table_id) %>% 
    collect()
  
  anem_dive <- left_join(anem, dive, by = "dive_table_id")
  
  # need to be able to compare dates and times
  anem_dive <- anem_dive %>% 
    mutate(obs_time = force_tz(ymd_hms(str_c(date, obs_time, sep = " ")), tzone = "Asia/Manila"), 
      gps = as.integer(gps))
  
  # convert to UTC
  anem_dive <- anem_dive %>% 
    mutate(obs_time = with_tz(obs_time, tzone = "UTC"), 
      id = 1:nrow(anem_dive))
  
  anem_dive <- anem_dive %>% 
    mutate(month = month(obs_time), 
      day = day(obs_time), 
      hour = hour(obs_time), 
      min = minute(obs_time), 
      sec = second(obs_time), 
      year = year(obs_time))
  
  # get table of lat lon data ####
  gpx <- leyte %>% 
    tbl("GPX") %>% 
    filter(unit %in% anem_dive$gps) %>% 
    collect(n = Inf) %>% 
    mutate(month = month(time), 
      day = day(time), 
      hour = hour(time), 
      min = minute(time), 
      sec = second(time), 
      year = year(time), 
      lat = as.character(lat), # to prevent from importing as factors
      lon = as.character(lon), 
      time = as.character(time)) %>% 
    rename(gps = unit)
  
  #### WAIT ####
  
  # find matches for times to assign lat long - there are more than one set of seconds (sec.y) that match
  anem_dive <- left_join(anem_dive, gpx, by = c("gps", "month", "day", "hour", "min", "year")) %>% 
    mutate(lat = as.numeric(lat), 
      lon = as.numeric(lon)) %>% 
    select(-contains("sec"))
  # need to make decimal 5 digits - why? because that is all the gps can hold
  
  # calculate a mean lat lon for each anem observation (currently there are 4 because a reading was taken every 15 seconds)
  coord <- anem_dive %>%
    group_by(id) %>% # id should be referring to one row of the data
    summarise(mlat = mean(lat, na.rm = TRUE),
      mlon = mean(lon, na.rm = T))
  
  # drop all of the unneccessary columns from anem and join with the coord
  anem_gpx <- anem_dive %>% 
    select(old_anem_id, anem_id, anem_obs, id, anem_spp)
  
  db_anem_gpx <- left_join(coord, anem_gpx, by = "id") %>% 
    rename(lat = mlat, 
      lon = mlon) %>% 
    distinct() %>% 
    select(-id) %>% 
    mutate(era = "past")
  return(db_anem_gpx)
}


assign_db_gpx_field <- function() {
  # get past data  - in the field ####
  load("data/db_backups/anemones_db.Rdata")
  anem <- anem %>% 
    select(anem_table_id, dive_table_id, obs_time, old_anem_id, anem_id, anem_obs, anem_spp) %>% 
    filter(!is.na(anem_id))
  
  
  # assign gps from db ####
  # need date and gps unit - in the field ####
  load("data/db_backups/diveinfo_db.Rdata")
  dive <- dive %>% 
    select(dive_table_id, date, gps) %>% 
    filter(dive_table_id %in% anem$dive_table_id)
  
  anem_dive <- left_join(anem, dive, by = "dive_table_id")
  
  # need to be able to compare dates and times
  anem_dive <- anem_dive %>% 
    mutate(obs_time = force_tz(ymd_hms(str_c(date, obs_time, sep = " ")), tzone = "Asia/Manila"), 
      gps = as.integer(gps))
  
  # convert to UTC
  anem_dive <- anem_dive %>% 
    mutate(obs_time = with_tz(obs_time, tzone = "UTC"), 
      id = 1:nrow(anem_dive))
  
  anem_dive <- anem_dive %>% 
    mutate(month = month(obs_time), 
      day = day(obs_time), 
      hour = hour(obs_time), 
      min = minute(obs_time), 
      sec = second(obs_time), 
      year = year(obs_time))
  
  # get table of lat lon data ####
  load("data/db_backups/gpx_db.Rdata")
  
  gpx <- gpx %>%
    filter(unit %in% anem_dive$gps) %>% 
    mutate(month = month(time), 
      day = day(time), 
      hour = hour(time), 
      min = minute(time), 
      sec = second(time), 
      year = year(time), 
      lat = as.character(lat), # to prevent from importing as factors
      lon = as.character(lon), 
      time = as.character(time)) %>% 
    rename(gps = unit)
  
  #### WAIT ####
  
  # find matches for times to assign lat long - there are more than one set of seconds (sec.y) that match
  anem_dive <- left_join(anem_dive, gpx, by = c("gps", "month", "day", "hour", "min", "year")) %>% 
    mutate(lat = as.numeric(lat), 
      lon = as.numeric(lon)) %>% 
    select(-contains("sec"))
  # need to make decimal 5 digits - why? because that is all the gps can hold
  
  # calculate a mean lat lon for each anem observation (currently there are 4 because a reading was taken every 15 seconds)
  coord <- anem_dive %>%
    group_by(id) %>% # id should be referring to one row of the data
    summarise(mlat = mean(lat, na.rm = TRUE),
      mlon = mean(lon, na.rm = T))
  
  # drop all of the unneccessary columns from anem and join with the coord
  anem_gpx <- anem_dive %>% 
    select(old_anem_id, anem_id, anem_obs, id, anem_spp)
  
  db_anem_gpx <- left_join(coord, anem_gpx, by = "id") %>% 
    rename(lat = mlat, 
      lon = mlon) %>% 
    distinct() %>% 
    select(-id) %>% 
    mutate(era = "past")
  return(db_anem_gpx)
}
