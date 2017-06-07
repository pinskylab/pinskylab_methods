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
