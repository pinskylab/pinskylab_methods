# lab helpers - helper functions for lab work
library(dplyr)

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

# write_db ####
#' access db with intent to change it
#' @export
#' @name write_db
#' @author Michelle Stuart
#' @param x = which db?
#' @examples 
#' db <- write_db("Leyte")

write_db <- function(db_name){
  library(RMySQL)
  db <- dbConnect(MySQL(), dbname = db_name, default.file = path.expand("~/myconfig.cnf"), port = 3306, create = F, host = NULL, user = NULL, password = NULL)
  return(db)
}


# plate_from_db ####
#' recreate a plate map from info in the db
#' @export
#' @name plate_from_db
#' @author Michelle Stuart
#' @param x = the table of samples to turn into a plate
#' @param y = the sample identifier you want to use
#' @examples 
#' plate <- plate_from_db(fish, extraction_id)

plate_from_db <- function(table_name, id_type){
  # split the well out into row and column 
  table_name$row <- substr(table_name$well, 1, 1)
  table_name$col <- as.numeric(substr(table_name$well, 2, 3))
  
  # select columns for plate 
  if (id_type == "extraction_id"){
    table_name <- table_name %>% 
      select(row, col, extraction_id) %>% #keep row & col, identifier
      arrange(row, col)
  }
  if (id_type == "sample_id"){
    table_name <- table_name %>% 
      select(row, col, sample_id) %>% #keep row & col, identifier
      arrange(row, col)
  }
  if (id_type == "digest_id"){
    table_name <- table_name %>% 
      select(row, col, digest_id) %>% #keep row & col, identifier
      arrange(row, col)
  }
  if (id_type == "ligation_id"){
    table_name <- table_name %>% 
      select(row, col, ligation_id) %>% #keep row & col, identifier
      arrange(row, col)
  }

  table_name <- as.data.frame(table_name)
  
  # make map
  platemap <<- as.matrix(reshape2::acast(table_name,table_name[,1] ~ table_name[,2]))
  return(table_name)
}


# make_plate_with_negs ####
#' turn a table into plates with negative controls
#' @export
#' @name make_plate_with_negs
#' @author Michelle Stuart
#' @param x = list of ids
#' @param y = id_type
#' @examples 
#' plate <- make_plate_with_negs(fish)

make_plate_with_negs <- function(list_of_ids, id_type){
  # make a dataframe of the list_of_ids
  ids <- data.frame(list_of_ids, stringsAsFactors = F)
 
  # how many rows are in the table (how many samples)?
  y <- nrow(ids)

  # how many plates would these make, 94 samples plus 2 blanks per plate
  (nplates <- floor(y/94)) # extra parenthesis are to print

  # define wells
  well <- 1:(96*nplates)

  # insert the negative controls and set up the plate
  plate <- data.frame() # blank data frame to build upon
  for (i in 1:nplates){
    c <- 96*i-95 # well 1 on a plate
    d <- 96*i-85 # 11
    e <- 96*i-84 # 12 negative control well
    f <- 96*i-83 # 13
    g <- 96*i-36 # 60
    h <- 96*i-35 # 61 negative control well
    j <- 96*i-34 # 62
    k <- 96*i-2  # 94
    l <- 96*i - 37 # 59
    m <- 96*i #96
    str1 <- as.data.frame(cbind(well[c:d], ids[c:d,])) # 1:11
    names(str1) <- c("well", "id_type")
    str2 <- as.data.frame(cbind(well[e], "XXXX")) # because the first blank is in the 12th position
    names(str2) <- c("well", "id_type")
    str3 <- as.data.frame(cbind(well[f:g], ids[e:l,])) #13:60 in plate, 12:59 in list
    names(str3) <- c("well", "id_type")
    str4 <- as.data.frame(cbind(well[h], "XXXX")) # because the 2nd blank is in the 61st position
    names(str4) <- c("well", "id_type")
    str5 <- as.data.frame(cbind(well[j:k], ids[g:k,]))# 62:96 in plate, 60:94 in list
    names(str5) <- c("well", "id_type")
    
    # and stick all of the rows together
    temp <- data.frame(rbind(str1, str2, str3, str4, str5))
    temp$row <- rep(LETTERS[1:8], 12)
    temp$col <- unlist(lapply(1:12, rep, 8))
    temp$plate <- paste("plate", i, sep = "")
    plate <- rbind(plate, temp)
    
  }
  
  # put the samples in order of id (with negative controls inserted)
  plate <- arrange(plate, plate, Col, Row)
  
  return(plate)
}


# make_platemap ####
#' turn a table into plates with negative controls
#' @export
#' @name make_plate
#' @author Michelle Stuart
#' @param x = tble
#' @examples 
#' plate <- make_plate(fish$extr_id)

make_platemap <- function(tble){
  plate <- tble %>% 
    select(contains("id"), well) %>% 
    mutate(row = substr(well, 1, 1), 
      col = as.numeric(substr(well, 2, 3)))
  plate <- plate %>% 
    select(row, col, contains("id"))
  platemap <<- as.matrix(reshape2::acast(plate, plate$row ~ plate$col))
}



# remove_rows ####
#' remove rows that won't fit on a plate or data set size, id column must be first column
#' @export
#' @name remove_rows
#' @author Michelle Stuart
#' @param x = table_name
#' @param y = how_many_wells
#' @
#' @examples 
#' ligate <- remove_rows(ligate, 96)

remove_rows <- function(table_name, how_many_wells){
  x <- nrow(table_name) %% how_many_wells # get the remainder after dividing by 48
  table_name <- table_name %>% 
    select(1) %>% 
    arrange() %>% 
    slice(1:(nrow(table_name) - x))
  
}

# lig_ng ####
#' figure out how many ng to use in making pools for ligations
#' @export
#' @name lig_ng
#' @author Michelle Stuart
#' @param x = digest table
#' @examples 
#' ligs <- lig_ng(dig)
lig_ng <- function(dig, regeno) {
  out <- data.frame() # make a blank data frame to write to
  y <- nrow(dig) # get the number of beginning rows
  for(i in c(200, 150, 100, 75, 50)){
    if (nrow(out) < y){ # if we haven't placed all of the candidates yet
      # define the samples that can be ligated at the current ng
      ng <- dig %>%
        mutate(uL_in = round(i/quant, 1)) %>% # round to 1 decimal point
        filter(uL_in < 22.2 & uL_in > 0.5) %>%
        mutate(water = round(22.2-uL_in, 1), 
          DNA = i)
      
      # define regenos that can be licated at the current ng
      reg <- regeno %>%
        mutate(uL_in = round(i/quant, 1)) %>% # round to 1 decimal point
        filter(uL_in < 22.2 & uL_in > 0.5) %>%
        mutate(water = round(22.2-uL_in, 1), 
          DNA = i)
      # end regenos section
      
      # pull out  pools
      # 47 samples from this pool are new, the 48th is a regenotype, that is why this number is 47.  You can change the number to whatever your pool size is, as long as you also change the slice row.
      while (nrow(ng) >= 47){
        while(nrow(reg) >= 1){
        pool <- ng %>% 
          slice(1:47)
       # add in regeno sample
         re <- reg %>%
          slice(1)
         #to make a total pool size of 48
         
         # remove the assigned pool from the ng table
        ng <- anti_join(ng, pool, by ="digest_id")
        
        # remove the assigned regenos from the regeno table
        reg <- anti_join(reg, re, by = "digest_id")
        
        # save the assigned samples to the out file
        out <- rbind(out, pool, re)
        
        # remove the assigned samples from the dig table
        dig <- anti_join(dig, ng, by = "digest_id")
        # remove the assigned samples from the regeno table
        regeno <- anti_join(regeno, ng, by = "digest_id")
      }
      }
    }
  }
  return(out)
}

# make_plate ####
#' make a plate from a list of sample_ids, extraction_ids, etc.
#' @export
#' @name make_plate
#' @author Michelle Stuart
#' @param x = list of ids
#' @examples 
#' test <- make_plate(lig_ids)

make_plate <- function(list_of_ids){
  # make a dataframe of the list_of_ids
  ids <- as.data.frame(list_of_ids)
  
  # how many rows are in the table (how many samples)?
  y <- nrow(ids)
  
  if (y >= 96){
    
  # how many plates would these make
  (nplates <- floor(y/96)) # extra parenthesis are to print
  
  # remove those rows that don't fit into plates
  ids <- remove_rows(ids, 96)
  
  # define wells
  well <- 1:(96*nplates)
  
  # set up the plate
  plate <- data_frame()
  for (i in 1:nplates){
    a <- 96*i-95 # position 1
    b <- 96*i     # position 96
    temp <- cbind(well[a:b], as.data.frame(ids[a:b, ]))
    temp$row <- rep(LETTERS[1:8], 12)
    temp$col = unlist(lapply(1:12, rep, 8))
    temp$plate = paste("plate", i, sep = "")
    plate <- rbind(plate, temp)
  }
  
  # put plate in order
  plate <- arrange(plate, plate, col, row)
  
  }else{
    plate <- data.frame( Row = rep(LETTERS[1:8], 12), Col = unlist(lapply(1:12, rep, 8)))
    plate <- plate[1:y,]
    plate <- cbind(plate, ids)
    plate$plate <- "shortplate1"
    }
    
  return(plate)
}

# change_rows ####
#' once rows have been changed remove them from table and add them back in
#' @export
#' @name change_rows
#' @author Michelle Stuart
#' @param x = whole table
#' @param y = the changed rows
#' @param z = identifying co
#' @examples 
#' deer <- change_rows(deer, change)

change_rows <- function(table, change, identifier){
  table <- anti_join(table, change, by = identifier)
  table <- rbind(table, change)
  return <- table
}

# assign_mek_loc ####
#' assign a location on the robot table for a destination or source plate
#' @export
#' @name assign_mek_loc
#' @author Michelle Stuart
#' @param x = plate_names - a table of plates 
#' @param y = table that contains the data
#' @param z = dest_or_source
#' @param a = identifier
#' @examples 
#' source <- assign_mek_loc(dig_plates, source, "source", "digest_id")

assign_mek_loc <- function(plate_names, table, dest_or_source, identifier){
  for (i in 1:nrow(plate_names)){
    if (dest_or_source == "dest"){
      change <- table %>% 
        filter(plate == plate_names$plate[i]) %>% 
        mutate(dest = mek_loc[length(mek_loc)])
      mek_loc <<- mek_loc[1:length(mek_loc)-1]
      table <- change_rows(table, change, identifier)
    }else{
      change <- table %>% 
        filter(plate == plate_names$plate[i]) %>% 
        mutate(source = mek_loc[length(mek_loc)])
      mek_loc <<- mek_loc[1:length(mek_loc)-1]
      table <- change_rows(table, change, identifier)
    }
    
  }
  return(table)
  
  
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

# heatmap ####
#' plot a plate map with color
#' @export
#' @name heatmap
#' @author Michelle Stuart
#' @param x = table_name where ids are located
#' @param y = identifier
#' @examples 
#' sample_map <- heatmap(plate_as_long_table)

heatmap <- function(plate_as_long_table, id){
  map <- plate_as_long_table  %>% 
    mutate(row = substr(well, 1, 1),
      row = factor(row, levels = c("H", "G", "F", "E", "D", "C", "B", "A")), 
      col = substr(well, 2, 3),
           col = factor(col, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12))) %>% 
    select(row, col, contains("id"), pull)
  
  plateheatmap <- ggplot(map, aes(x=col, y=row, fill= pull)) + 
    geom_tile()
  
  z <- plateheatmap + 
    geom_text(aes(col, row, label = map[,3]), color = "black", size = 4) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid.major = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      axis.ticks = element_blank())
  return(z)
  
}

# work_history ####
#' get the work history for samples
#' @export
#' @name work_history
#' @author Michelle Stuart
#' @param x = table_where_ids_are
#' @param y = column_of_ids - must be sample_id, extraction_id, digest_id, or ligation_id
#' @examples 
#' history <- work_history(table,column)
 
# check the work history of those sample_ids
work_history <- function(table, column){
  library(dplyr)
  lab <- read_db("Laboratory")
  if(column == "sample_id"){
    hist <- lab %>% 
      tbl("extraction") %>% 
      filter(sample_id %in% table$sample_id) %>% 
      select(sample_id, extraction_id) %>% 
      collect()
    
    dig <- lab %>% 
      tbl("digest") %>% 
      filter(extraction_id %in% hist$extraction_id) %>% 
      select(extraction_id, digest_id) %>% 
      collect()
    hist <- left_join(hist, dig, by = "extraction_id")
    rm(dig)
    
    lig <- lab %>% 
      tbl("ligation") %>% 
      filter(digest_id %in% hist$digest_id) %>% 
      select(ligation_id, digest_id) %>% 
      collect()
    hist <- left_join(hist, lig, by = "digest_id")
    rm(lig)
    return(hist)
  }
    
    if(column == "ligation_id"){
      hist <- lig <- lab %>% 
        tbl("ligation") %>% 
        filter(ligation_id %in% table$ligation_id) %>% 
        select(ligation_id, digest_id) %>% 
        collect()
      
      dig <- lab %>% 
        tbl("digest") %>% 
        filter(digest_id %in% hist$digest_id) %>% 
        select(extraction_id, digest_id) %>% 
        collect()
      hist <- left_join(hist, dig, by = "digest_id")
      rm(dig)
      
      extr <- lab %>% 
        tbl("extraction") %>% 
        filter(extraction_id %in% hist$extraction_id) %>% 
        select(extraction_id, sample_id) %>% 
        collect()
      hist <- left_join(hist, extr, by = "extraction_id")
        rm(extr)
      return(hist)
  }  
}




