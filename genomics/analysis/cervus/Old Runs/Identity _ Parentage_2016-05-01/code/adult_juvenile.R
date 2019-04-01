# This script is for creating adult/juvenile files for Cervus - Michelle Stuart 2/17/2016
#As of 4/12/2016 the definition of adult is any fish that is >7cm or a tail color of YP, YE, YPO, OP, or OR
# Output the results into the cervus folder on google docs

# Mr. Whitmore
setwd('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Identity & Parentage_2016-05-01')
source('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/code/readGenepop_space.R')
genfile <- '/Users/michelle/Google Drive/Pinsky Lab/Cervus/Identity & Parentage_2016-05-01/2016-05-01_norecap.genepop'

# # Lightning
# setwd('/Users/macair/Documents/Philippines/Genetics/parentage')
# source('/Users/macair/Documents/Philippines/Genetics/code/readGenepop_space.R')
#genfile <- '../identity/2016-02-17_norecaps.genepop'

library(RCurl)
dat <- readGenepop(genfile)

# insert sample ID to match with samples sheet
for(i in 1:nrow(dat)){
	if(nchar(dat$names[i]) == 15){
		dat$SampleID[i] <- substr(dat$names[i], 1, 10)
	}
	else{
		dat$SampleID[i] <- substr(dat$names[i], 17, 26)
	}
}

library(googlesheets)
# gs_auth(new_user = TRUE) # run this if having authorization problems
mykey <- '1Rf_dFJ5WK-vTTsIT_kHHOcFrKzQtMFtKiuXiFw1lh9Y' # for Sample_Data sheet
gssampdat <- gs_key(mykey)
sampledata <- gs_read(gssampdat, ws='Samples')

age <- merge(dat[,c('names', 'SampleID')], sampledata[,c('Sample_ID', 'Age')], by.x = "SampleID", by.y = "Sample_ID")


# ############# TO GENERATE A JUVENILE FILE #####################

juveniles <- age$names[is.na(age$Age)]

write.table(juveniles, file=(paste(Sys.Date(), 'juveniles.csv', sep = '_')), row.names = FALSE, col.names = FALSE, quote = FALSE)


############### TO GENERATE AN ADULT FILE ########################

adults <- age$names[!is.na(age$Age)]

write.table(adults, file=(paste(Sys.Date(), 'adults.csv', sep = '_')), row.names = FALSE, col.names = FALSE, quote = FALSE)

