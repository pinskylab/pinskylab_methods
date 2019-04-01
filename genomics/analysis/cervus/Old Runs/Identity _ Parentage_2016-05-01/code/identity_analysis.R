# This script is written to take the csv produced by Cervus Identity Analysis and assist in finding true matches vs. errors.  1) plot the data and determine which outliers can be eliminated immediately - change parameters of cervus?

# Remember that the plot axes matter - as you get closer and closer to great, the cloud of results can look scattered as the axes zoom in, be wary of that

# 2) change ID's to sample.ID and import relevant data (site, lat, lon, etc)

# 3) find distances between samples

# 4) find samples that are not at the same site

# 5) add truely matching samples to the match log


############# 1) Plot the results to see how many outliers exist ##############
# Mr. Whitmore
setwd('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/identity')
source('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/code/readGenepop_space.R')

# # Lightning
# setwd('/Users/macair/Documents/Philippines/Genetics/identity')

# idcsv <- read.csv('DP20edited_ID.csv', stringsAsFactors=FALSE)
# nrow(idcsv) # 101 - DP20edited - the Cervus ID from Jan 7, 2016

# idcsv <- read.csv('25MAR16_ID.csv', stringsAsFactors=FALSE)
# nrow(idcsv) # 48 - 25MAR16_ID

idcsv <- read.csv('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Identity_2016-05-01/2016-05-01_ID.csv', stringsAsFactors = FALSE)
nrow(idcsv)  # 27 



# add mismatch rate
idcsv$Mismatch.prop <- idcsv$Mismatching.loci/idcsv$Matching.loci
	
# order by number of matching loci
idcsv <- idcsv[order(idcsv $Matching.loci),]

plot(idcsv$Matching.loci, idcsv$Mismatch.prop)
abline(h=0.015)

################## 2) add field data ###############
# create a column to allow matching of sample id from idcsv with sample ID from samples spreadsheet
idcsv$First.SampleID <- NA
for(i in 1:nrow(idcsv)){
	if(!is.na(idcsv$First.ID[i]) && nchar(idcsv$First.ID[i]) == 15){
		idcsv$First.SampleID[i] <- substr(idcsv$First.ID[i], 1,10)
	}
	else{
		idcsv$First.SampleID[i] <- substr(idcsv$First.ID[i],17,26)
	}
}

idcsv$Second.SampleID <- NA
for(i in 1:nrow(idcsv)){
	if(!is.na(idcsv$Second.ID[i]) && nchar(idcsv$Second.ID[i]) == 15){
		idcsv$Second.SampleID[i] <- substr(idcsv$Second.ID[i], 1, 10)
	}
	else{
		idcsv$Second.SampleID[i] <- substr(idcsv$Second.ID[i],17,26)
	}
}

# add lat/lons, anem, size and tail color for all samples
library(googlesheets)
# gs_auth(new_user = TRUE) # run this if having authorization problems
mykey <- '1Rf_dFJ5WK-vTTsIT_kHHOcFrKzQtMFtKiuXiFw1lh9Y' # for Sample_Data sheet
gssampdat <- gs_key(mykey)
sampledata <- gs_read(gssampdat, ws='Samples')
m1 <- sampledata
names(m1) <- paste('First.', names(m1), sep='')
idmeg <- merge(idcsv, m1, by.x='First.SampleID', by.y = 'First.Sample_ID', all.x=TRUE)
m2 <- sampledata
names(m2) <- paste('Second.', names(m2), sep='')
idmeg <- merge(idmeg, m2, by.x='Second.SampleID', by.y = 'Second.Sample_ID', all.x=TRUE)

# clean up unneccessary columns
idmeg [,c("Second.Extracted?")] <- NULL
idmeg [,c("Second.mass_g")] <- NULL
idmeg [,c("Second.Notes")] <- NULL
idmeg [,c("Second.Collector")] <- NULL
idmeg [,c("Second.Sex")] <- NULL
idmeg [,c("Second.Size_type")] <- NULL
idmeg [,c("First.mass_g")] <- NULL
idmeg [,c("First.Notes")] <- NULL
idmeg [,c("First.Collector")] <- NULL
idmeg [,c("First.Sex")] <- NULL
idmeg [,c("First.Size_type")] <- NULL
idmeg$First.Lon <- as.numeric(idmeg$First.Lon)
idmeg$First.Lat <- as.numeric(idmeg$First.Lat)
idmeg$Second.Lon <- as.numeric(idmeg$Second.Lon)
idmeg$Second.Lat <- as.numeric(idmeg$Second.Lat)

# # add site data
# mykey = '1GPRbH8TaujXWK4reuuD_zN29Mwxm302DDMKUW66otxY' # for Mega Analysis file
# sites <- gs_key(mykey)

# ######### THIS IS NOT IMPORTING SITE NAMES, JUST MAKING MANY INVISIBLE COLUMNS
# # sites_2012 <- gs_read(sites, ws='2012_site_data')
# # s1 <- sites_2012
# # s1$First.Anem_ID <- s1[,c("AnemID")]
# # s1$First.Site <- s1[,c("Name")]
# # idmeg <- merge(idmeg, s1[,c("First.Anem_ID", "First.Site")], by.x="First.Anem_ID", all.x=TRUE)
# # s2 <- sites_2012
# # s2$Second.Anem_ID <- s2[,c("AnemID")]
# # s2$Second.Site <- s2[,c("Name")]
# # idmeg <- merge(idmeg, s2[,c("Second.Anem_ID", "Second.Site")], by.x="Second.Anem_ID", all.x=TRUE)

# # sites_2013 <- gs_read(sites, ws = 'Copy of 2013_site_data')
# # s3 <- sites_2013
# # s3$First.Anem_ID <- s3[,c("AnemID")]
# # s3$First.Site <- s3[,c("Name")]
# # idmeg <- merge(idmeg, s3[,c("First.Anem_ID", "First.Site")], by.x="First.Anem_ID", by.y="First.Anem_ID", all.x=TRUE)
# # s2 <- sites_2013
# # s2$Second.Anem_ID <- s2[,c("AnemID")]
# # s2$Second.Site <- s2[,c("Name")]
# # idmeg <- merge(idmeg, s2[,c("Second.Anem_ID", "Second.Site")], by.x="Second.Anem_ID", by.y="Second.Anem_ID", all.x=TRUE)


# # sites_2014 <- gs_read(sites, ws = 'Copy of 2014_site_data')
# # s3 <- sites_2014
# # s3$First.Anem_ID <- s3[,c("AnemID")]
# # s3$First.Site <- s3[,c("Name")]
# # idmeg <- merge(idmeg, s3[,c("First.Anem_ID", "First.Site")], by.x="First.Anem_ID", by.y="First.Anem_ID", all.x=TRUE)
# # s2 <- sites_2014
# # s2$Second.Anem_ID <- s2[,c("AnemID")]
# # s2$Second.Site <- s2[,c("Name")]
# # idmeg <- merge(idmeg, s2[,c("Second.Anem_ID", "Second.Site")], by.x="Second.Anem_ID", by.y="Second.Anem_ID", all.x=TRUE)

# # sites_2015 <- gs_read(sites, ws = '2015_site_data')
# # s3 <- sites_2015
# # s3$First.Anem_ID <- s3[,c("AnemID")]
# # s3$First.Site <- s3[,c("Name")]
# # idmeg <- merge(idmeg, s3[,c("First.Anem_ID", "First.Site")], by.x="First.Anem_ID", by.y="First.Anem_ID", all.x=TRUE)
# # s2 <- sites_2015
# # s2$Second.Anem_ID <- s2[,c("AnemID")]
# # s2$Second.Site <- s2[,c("Name")]
# # idmeg <- merge(idmeg, s2[,c("Second.Anem_ID", "Second.Site")], by.x="Second.Anem_ID", by.y="Second.Anem_ID", all.x=TRUE)


##################### 3) determine distance between samples ############

library(fields)
# source('greatcircle_funcs.R') # alternative, probably faster
alldists <- rdist.earth(as.matrix(idmeg[,c('First.Lon', 'First.Lat')]), as.matrix(idmeg[,c('Second.Lon', 'Second.Lat')]), miles=FALSE, R=6371) # see http://www.r-bloggers.com/great-circle-distance-calculations-in-r/ # slow because it does ALL pairwise distances, instead of just in order
idmeg$distkm <- diag(alldists)

################### 4) examine the number of loci for pairs that are less than 250m apart and keep the one with the most loci (or if equal, then the newest)

idmeg$drop <- NA # placeholder
for(i in 1:nrow(idmeg)){
	if(!is.na(idmeg$distkm[i]) && 0.250 <= idmeg$distkm[i]){
		idmeg$drop[i] <- "DROP"
	}
}

# create a list of IDs to drop because they are recaptures
for(i in 1:nrow(idmeg)){
	if(is.na(idmeg$drop[i]) && idmeg$Loci.typed[i] > idmeg$Loci.typed.1[i]){
		idmeg$drop[i] <- idmeg$Second.ID[i]
	}
	if(is.na(idmeg$drop[i]) && idmeg$Loci.typed[i] > idmeg$Loci.typed.1[1]){
		idmeg$drop[i] <- idmeg$First.ID[i]
	}
}

#################### 5) import the genepop file and remove the recaptured # samples


# Currently not working, going to remove the samples by hand from the genepop using text editor

# library(RCurl)
# genfile <- '/Users/michelle/Google Drive/Pinsky Lab/Cervus/Identity_2016-05-01/2016-05-01_noregeno.genepop'
# genedf <- readGenepop(genfile)


# which(genedf$names == idmeg$drop) 



############# FUTURE - drop into database ########################

############ current - write the output to csv ###############
write.csv(idmeg, file= paste(Sys.Date(), '_identity_dist.csv', sep=''))