# This is a reference sheet of example codes you could find useful when accessing the database 
# through R using the dplyr package.  Please let me know if you need to perform a repetitive
# task not listed here and I will add it.

# Connect to the databse - replace user & password with your own info, create = F for false, if true, will create a new database
suppressMessages(library(dplyr))
labor <- src_mysql(dbname = "Laboratory", host = "amphiprion.deenr.rutgers.edu", user = "your_user_name", password = "your_password", port = 3306, create = F)

# the above method for connecting to the database is not a secure way to share code.  Instead you should make a configuration file and refer to that configuration file in your code:
leyte <- src_mysql(dbname = "Leyte", default.file = path.expand("~/myconfig.cnf"), port = 3306, create = F, host = NULL, user = NULL, password = NULL)


# Add sample IDs to ligation numbers or use the function sampfromlig.R stored here: https://github.com/stuartmichelle/Genetics/tree/master/code
c1 <- labor %>% tbl("extraction") %>% select(extraction_ID, sample_ID) # creates a connection to all extract and sample IDs in extraction table
c2 <- labor %>% tbl("digest") %>% select(digest_ID, extraction_ID) # creates a connection to all extract and digest IDs in digest table
c3 <- left_join(c2, c1, by = "extraction_ID") # links the extraction and digest table by extraction ID
c4 <- labor %>% tbl("ligation") %>% select(ligation_ID, digest_ID) # creates a connection to all ligation and digest IDs in ligation table
c5 <- data.frame(left_join(c4, c3, by = "digest_ID")) # connects the previous table to the ligation table through digest ID, dataframe imports the data to current R session

# The following lines are for direct sql queries conducted within sequel pro or by using the dplyr code sql("")
select * from digest where extraction_ID = "E0226";
select * from ligation where digest_ID = "D0439";

select * from ligation where ligation_ID = "L0425";
select * from digest where digest_ID = "D0428";
select * from extraction where extraction_ID = "E0226";

select * from digest
where date = "2016-09-18"
and DNA_ng < 100;
