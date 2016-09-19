# This is a reference sheet of example codes you could find useful when accessing the database 
# through R using the dplyr package.  Please let me know if you need to perform a repetitive
# task not listed here and I will add it.

# Connect to the databse - replace user & password with your own info, create = F for false, if true, will create a new database
suppressMessages(library(dplyr))
labor <- src_mysql(dbname = "Laboratory", host = "amphiprion.deenr.rutgers.edu", user = "your_user_name", password = "your_password", port = 3306, create = F)

# Add sample IDs to ligation numbers
c1 <- labor %>% tbl("extraction") %>% select(extraction_ID, sample_ID) # creates a connection to all extract and sample IDs in extraction table
c2 <- labor %>% tbl("digest") %>% select(digest_ID, extraction_ID) # creates a connection to all extract and digest IDs in digest table
c3 <- left_join(c2, c1, by = "extraction_ID") # links the extraction and digest table by extraction ID
c4 <- labor %>% tbl("ligation") %>% select(ligation_ID, digest_ID) # creates a connection to all ligation and digest IDs in ligation table
c5 <- data.frame(left_join(c4, c3, by = "digest_ID")) # connects the previous table to the ligation table through digest ID, dataframe imports the data to current R session
