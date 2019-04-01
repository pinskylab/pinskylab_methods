# This script is written to take the filtered genepop file from dDocent and 1) strip any named samples down to pure ligation number, 2) identify and remove re-genotyped samples based on number of loci (SNPs), 3) generate a new genepop file to be fed to cervus for identification of recaptures.


# 0) Set up working directory ---------------------------------------------

# # Mr. Whitmore
# setwd('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/rosetta stone genepop')
# source('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/code/readGenepop_space.R')

# Lightning
setwd("/Users/macair/Documents/Philippines/Genetics/")
source("code/old/Genetics/src/readGenepop_space.R")
source("code/old/Genetics/src/writeGenepop.R")

# 1) Strip down to Ligation ID --------------------------------------------

# locate the genepop file and read as data frame
genfile <- "seq03_16_DP10g95maf40.genepop"
genedf <- readGenepop(genfile)
genedf[,1] <- NULL # remove the pop column from the data file
# TEST - make sure the first 2 columns are names and a contig and get number of rows
names(genedf[,1:2]) # [1] "names" "dDocent_Contig_107_30"
nrow(genedf) # 1651

# Strip out the ligation ID
for(a in 1:nrow(genedf)){
	genedf$lig[a] <- substr(genedf$names[a],11,15)
}
# TEST - make sure samples were renamed properly
genedf$lig[1:5] # "L1733" "L2552" "L2553" "L2344" "L2463"

# open the laboratory database to retrieve sample info
library(googlesheets)
# gs_auth(new_user = TRUE) # run this if having authorization problems
mykey <- '1Rf_dFJ5WK-vTTsIT_kHHOcFrKzQtMFtKiuXiFw1lh9Y' # for Sample_Data file
lab <-gs_key(mykey)
# If this doesn't output Auto-refreshing stale OAuth token.
# Sheet successfully identified: "Sample_Data"
# Then use the #gs_auth above
lig <-gs_read(lab, ws='Ligations')
dig <- gs_read(lab, ws='Digests')
extr <- gs_read(lab, ws="Extractions")
# sample <- gs_read(lab, ws="Samples")

# merge the two dataframes so that lig IDs match up
largedf <- merge(genedf, lig[,c('Ligation_ID', 'Digest_ID')], by.x = "lig", by.y = "Ligation_ID", all.x = T)

# TEST - check the last 2 column names and that the number of rows hasn't changed
p <- ncol(largedf)
names(largedf[,(p-1):p]) # "dDocent_Contig_256998_105" "Digest_ID"
nrow(genedf) == nrow(largedf) # should be TRUE

# add extraction IDs
largedf <- merge(largedf, dig[,c("Digest", "Extraction_ID")], by.x = "Digest_ID", by.y = "Digest", all.x = T)
# TEST - check the last 2 column names and that the number of rows hasn't changed
p <- ncol(largedf)
names(largedf[,(p-1):p]) # "dDocent_Contig_256998_105" "Extraction_ID"
nrow(genedf) == nrow(largedf) # should be TRUE

# add sample ID's
largedf <- merge(largedf, extr[,c("Extract", "Sample_ID")], by.x = "Extraction_ID", by.y = "Extract", all.x = T)
# TEST - check the last 2 column names and that the number of rows hasn't changed
p <- ncol(largedf)
names(largedf[,(p-1):p]) # " dDocent_Contig_256998_105" "Sample_ID" 
nrow(genedf) == nrow(largedf) # should be TRUE
# look for missing names
setdiff(genedf$names, largedf$names) # should be character(0)


# Remove regenotyped samples ----------------------------------------------

# make a list of all of the sample ID's that have duplicates (some on this list occur more than once because there are 3 regenos)
regeno_match <- largedf$Sample_ID[duplicated(largedf$Sample_ID)]
# TEST - make sure a list was generated
k <- length(regeno_match) # 82

##### calculate the number of genotyped loci for each sample #####

# convert 0000 to NA in the genepop data
largedf[largedf == "0000"] = NA
# TEST - make sure there are no "0000" left
which(largedf == "0000") # should return integer(0)

# count the number of loci per individual
for(h in 1:nrow(largedf)){
	largedf$numloci[h] <- sum(!is.na(largedf[h,]))
}
# TEST - make sure all of the numloci were populated
which(is.na(largedf$numloci)) # should return integer(0)
largedf$drop <- NA # place holder
#run through all of the SampleIDs that are found more than once and keep the one with the most loci
for(b in 1:k){
  # regeno_drop is the line number from largedf that matches an ID in the regeno_match list
  regeno_drop <- which(largedf$Sample_ID == regeno_match[b]) 
	df <- largedf[c(regeno_drop[1],regeno_drop[2],regeno_drop[3],regeno_drop[4]),]  # df is the data frame that holds all of the regenotyped versions of the sample, pulled from largedf
	p <- ncol(df)
	keep <- which.max(df[,p-1]) # the row number of df with the largest number of loci
	c <- regeno_drop[keep]
	df$drop[keep] <- "KEEP"
	largedf$drop[c] <- "KEEP"
	for(e in 1:nrow(df)){
	if(is.na(df$drop[e])){
		f <-regeno_drop[e]
		largedf$drop[f] <- "DROP"
	}
	}
}
# TEST - take a look at the largedf$drop field

length(which(largedf$drop == "KEEP")) == length(regeno_match)
length(which(largedf$drop == "DROP")) == length(regeno_match)


# convert all of the KEEPs to NAs 
for(g in 1:nrow(largedf)){
	if(!is.na(largedf$drop[g]) && largedf$drop[g]=="KEEP"){
		largedf$drop[g] <- NA
	}
}

# create a new data frame with none of the "DROP" rows
noregeno <- largedf[is.na(largedf$drop),]
# TEST - make sure no drop rows made it
which(noregeno$drop == "DROP") # should return integer(0)
# TEST - check to see if there are any regenos that were missed
noregeno_match <- noregeno$Sample_ID[duplicated(noregeno$Sample_ID)]
noregeno_match # should return character(0)  
# If it doesn't, look deeper: noregeno[which(noregeno$SampleID == "APCL15_403"),], largedf[which(largedf$Sample_ID == "APCL15_403"),]

# remove the extra columns from noregeno
noregeno [,c("Extraction_ID")] <- NULL
noregeno [,c("Digest_ID")] <- NULL
noregeno [,c("names")] <- NULL
noregeno [,c("Sample_ID")] <- NULL
noregeno [,c("numloci")] <- NULL
noregeno [,c("drop")] <- NULL

# convert all the NA genotypes to 0000
noregeno[is.na(noregeno)] = "0000"
# TEST - make sure there are no NA's left
which(noregeno == NA) # should return integer(0)

# TEST - compare the length of noregeno to the length of largedf
nrow(noregeno) == nrow(largedf) - k # 1569

# 3) Remove samples with known issues ----------------------------------------

# to remove samples with known issues, pull the data from the known issues google sheet

mykey <- "1GPRbH8TaujXWK4reuuD_zN29Mwxm302DDMKUW66otxY"
meg <-gs_key(mykey)
iss <-gs_read(meg, ws='Known Issues')

# change the lig_ID for known issue samples to NA for easy removal
for (i in 1:nrow(iss)){
  j <- which(noregeno$lig == iss$Ligation_ID[i])
  noregeno$lig[j] <- NA
}
# the number of IDs that matched (not necessarily the length of the iss table)
m <- length(which(is.na(noregeno$lig))) 

# remove the samples with issues from the noregeno table
inds <- !is.na(noregeno$lig)
noregeno <- noregeno[inds,]

# TEST - make sure that the new noregeno table has the same number of rows as the original genepop minus the regenotyped samples and the known issue samples that were found in this dataset
nrow(noregeno) == nrow(largedf) - k - m # should return TRUE


# 4) Output genepop file --------------------------------------------------

# Build the genepop components
msg <- c("This genepop file was generated using a script called process_genepop.R written by Michelle Stuart with help from Malin Pinsky")

loci <- paste(names(noregeno[,2:ncol(noregeno)]), collapse =",")

gene <- vector()
sample <- vector()
for (i in 1:nrow(noregeno)){
		gene[i] <- paste(noregeno[i,2:ncol(noregeno)], collapse = " ")
	sample[i] <- paste(noregeno[i,1], gene[i], sep = ", ")
}

out <- c(msg, loci, 'pop', sample)

write.table(out, file = paste(Sys.Date(), 'noregeno.genepop', sep = '_'), row.names=FALSE, quote=FALSE, col.names=FALSE) # won't let me use header=FALSE - use col.names instead of header


