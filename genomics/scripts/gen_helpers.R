# helper functions for working with this repository
library(dplyr)
library(tidyr)
library(stringr)

# read_genepop ####
#' read a genepop generated for ONE population
#' @export
#' @name read_genepop
#' @author Michelle Stuart
#' @param x = filename
#' @examples 
#' genedf <- read_genepop("data/seq17_03_58loci.gen")

# only works if Genepop has loci listed in 2nd line (separated by commas), has individual names separated from genotypes by a comma, and uses spaces between loci
# return a data frame: col 1 is individual name, col 2 is population, cols 3 to 2n+2 are pairs of columns with locus IDs
read_genepop <-  function(filename){
  # get all of the data
  dat <- read.table(filename, skip = 2, sep = " ", stringsAsFactors = F, colClasses = "character") 
  
  # get the header info
  info <- readLines(filename, n = 2) 
  
  # define the loci names
  loci <- unlist(strsplit(info[2], split=','))    
  
  # rename the dat columns
  names(dat) <- c("names", loci)
  
  # if there is a comma, remove it
  dat$names <- str_replace(dat$names, ",", "")
  
  return(dat)	
}


# samp_from_lig ####
#' find sample id from ligation id
#' @export
#' @name samp_from_lig
#' @author Michelle Stuart
#' @param x = table_name where ligation ids are located
#' @examples 
#' c5 <- samp_from_lig(genedf)


samp_from_lig <- function(table_name){
  
  lab <- read_db("Laboratory")
  
  # connect ligation ids to digest ids
  lig <- lab %>% 
    tbl("ligation") %>% 
    collect() %>% 
    filter(ligation_id %in% table_name$ligation_id) %>% 
    select(ligation_id, digest_id)
    
  # connect digest ids to extraction ids
  dig <- lab %>% 
    tbl("digest") %>% 
    collect() %>% 
    filter(digest_id %in% lig$digest_id) %>% 
    select(extraction_id, digest_id)
    
  extr <- lab %>% 
    tbl("extraction") %>% 
    collect() %>% 
    filter(extraction_id %in% dig$extraction_id) %>% 
    select(extraction_id, sample_id)
    
  mid <- left_join(lig, dig, by = "digest_id")
  samp <- left_join(extr, mid, by = "extraction_id") %>% 
    select(sample_id, ligation_id)
  
  return(samp)
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

# lig_from_samp ####
#' views all of the fish recaptured at a given site
#' @export
#' @name lig_from_samp
#' @author Michelle Stuart
#' @param x = list of sample_ids
#' @examples 
#' fish <- lig_from_samp(c("APCL13_516", "APCL13_517"))

lig_from_samp <- function(sample_ids){
  
  lab <- read_db("Laboratory")
  
  extr <- lab %>% 
    tbl("extraction") %>% 
    filter(sample_id %in% sample_ids) %>% 
    select(sample_id, extraction_id) %>% 
    collect()
  
  dig <- lab %>% 
    tbl("digest") %>% 
    filter(extraction_id %in% extr$extraction_id) %>%
    select(extraction_id, digest_id) %>% 
    collect()
  
  lig <- lab %>% 
    tbl("ligation") %>% 
    filter(digest_id %in% dig$digest_id) %>%
    select(ligation_id, digest_id) %>% 
    collect()
  
  mid <- left_join(extr, dig, by = "extraction_id")
  lig <- left_join(mid, lig, by = "digest_id") 
  
  return(lig)
}


# samp_to_site ####
#' find site for a sample 
#' @export
#' @name samp_to_site
#' @author Michelle Stuart
#' @param x = sample_id
#' @examples 
#' new <- samp_to_site(sample)

samp_to_site <- function(sample) {
  leyte <- read_db("Leyte")
  fish <- leyte %>% 
    tbl("clownfish") %>% 
    filter(sample_id %in% sample) %>% 
    select(sample_id, anem_table_id) %>% 
    collect()
  anem <- leyte %>% 
    tbl("anemones") %>% 
    filter(anem_table_id %in% fish$anem_table_id) %>% 
    select(anem_table_id, anem_id, dive_table_id) %>% 
    collect()
  fish <- left_join(fish, anem, by = "anem_table_id")
  rm(anem)
  dive <- leyte %>% 
    tbl("diveinfo") %>% 
    filter(dive_table_id %in% fish$dive_table_id) %>% 
    select(dive_num, dive_table_id, site) %>% 
    collect()
  fish <- left_join(fish, dive, by = "dive_table_id")
  rm(dive)
  return(fish)
  
}

# lig_from_samp ####
#' views all of the fish recaptured at a given site
#' @export
#' @name lig_from_samp
#' @author Michelle Stuart
#' @param x = list of sample_ids
#' @examples 
#' fish <- lig_from_samp(c("APCL13_516", "APCL13_517"))

lig_from_samp <- function(sample_ids){
  
  lab <- read_db("Laboratory")
  
  extr <- lab %>% 
    tbl("extraction") %>% 
    filter(sample_id %in% sample_ids) %>% 
    select(sample_id, extraction_id) %>% 
    collect()
  
  dig <- lab %>% 
    tbl("digest") %>% 
    filter(extraction_id %in% extr$extraction_id) %>%
    select(extraction_id, digest_id) %>% 
    collect()
  
  lig <- lab %>% 
    tbl("ligation") %>% 
    filter(digest_id %in% dig$digest_id) %>%
    select(ligation_id, digest_id) %>% 
    collect()
  
  mid <- left_join(extr, dig, by = "extraction_id")
  lig <- left_join(mid, lig, by = "digest_id") 
  
  return(lig)
}

anemid_latlong <- function(anem.table.id, latlondata) { #anem.table.id is one anem_table_id value, latlondata is table of GPX data from database (rather than making the function call it each time); will need to think a bit more clearly about how to handle different locations read for different visits to the same anem_id (or different with same anem_obs); for now, just letting every row in anem.Info get a lat-long
  
  #find the dive info and time for this anem observation
  dive <- leyte %>%
    tbl("anemones") %>%
    select(anem_table_id, obs_time, dive_table_id, anem_id) %>%
    collect() %>%
    filter(anem_table_id %in% anem.table.id)
  
  # find the date info and gps unit for this anem observation
  date <- leyte %>% 
    tbl("diveinfo") %>% 
    select(dive_table_id, date, gps, site) %>% 
    collect() %>% 
    filter(dive_table_id %in% dive$dive_table_id)
  
  #join with anem info, format obs time
  anem <- left_join(dive, date, by = "dive_table_id") %>% 
    separate(obs_time, into = c("hour", "minute", "second"), sep = ":") %>% #this line and the next directly from Michelle's code
    mutate(gpx_hour = as.numeric(hour) - 8)
  
  # find the lat long for this anem observation
  latloninfo <- latlondata %>%
    filter(date %in% anem$date) %>% 
    separate(time, into = c("hour", "minute", "second"), sep = ":") %>% 
    filter(as.numeric(hour) == anem$gpx_hour & as.numeric(minute) == anem$minute) 
  
  latloninfo$lat <- as.numeric(latloninfo$lat)
  latloninfo$lon <- as.numeric(latloninfo$lon)
  
  #often get multiple records for each anem_table_id (like if sit there for a while) - so multiple GPS points for same visit to an anemone, not differences across visits
  dups_lat <- which(duplicated(latloninfo$lat)) #vector of positions of duplicate values
  dups_lon <- which(duplicated(latloninfo$lon))
  
  #either take the mean of the lat/lon readings or the duplicated values, depending if there are duplicate points
  if(length(dups_lat) == 0) { #if all latitude points are different
    anem$lat <- round(mean(latloninfo$lat), digits = 5) #take the mean of the latitude values (digits = 5 b/c that is what Michelle had)
    anem$lon <- round(mean(latloninfo$lon), digits = 5) #take the mean of the longitude values
    #lat <- round(mean(latloninfo$lat), digits = 5) 
    #lon <- round(mean(latloninfo$lon), digits = 5)
  }else{
    anem$lat <- latloninfo$lat[dups_lat[1]] #if are duplicates, take the value of the first duplicated point
    anem$lon <- latloninfo$lon[dups_lon[1]]
    #lat <- latloninfo$lat[dups_lat[1]] #if are duplicates, take the value of the first duplicated point
    #lon <- latloninfo$lon[dups_lon[1]]
  }
  
  return(anem)
  
}

