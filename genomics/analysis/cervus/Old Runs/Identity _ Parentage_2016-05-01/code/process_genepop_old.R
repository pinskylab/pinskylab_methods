# This script is written to take the filtered genepop file from dDocent and 1) rename any mislabeled samples, 2) identify and remove re-genotyped samples based on number of loci (SNPs), 3) generate a new genepop file to be fed to cervus for identification of recaptures.

################  1) Mislabeled Samples ##########################

# This code is intended to be used immediately after the dDocent pipeline generates the genepop file in order to correct for any naming issues due to lab error.

# for every line in the genepop file, need to find the sample ID in the rosetta stone file and, if the reason field is not blank, amend the sample ID to include the updated sample ID.
# 4/29/2016 MRS changing the code so that the output is in Pinsky Lab format (APCL15_203), not dDocent format (APCL_15203L658)

# set the working directory

# Mr. Whitmore
setwd('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/rosetta stone genepop')
source('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/code/readGenepop_space.R')

# # Lightning
# # setwd('/Users/macair/Documents/Philippines/Genetics/rosetta stone genepop')
# setwd('/Users/macair/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/rosetta stone genepop')
# source('/Users/macair/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/code/readGenepop_space.R')
# source('/Users/macair/Documents/Philippines/Genetics/code/readGenepop_space.R')
# source('/Users/macair/Documents/Philippines/Genetics/code/writeGenepop.R')

library(RCurl)

# locate the genepop file and read as data frame
# genfile <- 'DP10g95-2.genepop'
genfile <- 'DP10g95maf2.genepop' #SEQ03-09 - reduced # of SNPS to 1012
# genfile <- '2016_03_21_DP10g95c9maf05.genepop' #SEQ03-13
genedf <- readGenepop(genfile)
genedf[,1] <- NULL # remove the pop column from the data file

# Change the names of the samples from dDocent format to Pinsky Lab format - substr allows to select specific characters to pull out of names string to reconstruct Sample ID
for(a in 1:nrow(genedf)){
	genedf$names[a] <- paste('APCL', substr(genedf$names[a],6,7), "_", substr(genedf$names[a],8,15), sep="")
}

# open the rosetta stone
library(googlesheets)
# gs_auth(new_user = TRUE) # run this if having authorization problems
mykey <- '1yhMEwka68eIAMbFKG4-KFWbmNb0JqzlML91mlX8mWj4' # for Rosetta Stone file
stone <-gs_key(mykey)
rosetta <-gs_read(stone, ws='Rosetta')

# merge the two dataframes so that sample IDs match up
largedf <- merge(genedf, rosetta[,c('names', 'SampleID', 'Reason')], all.x = TRUE)

# look for missing names
setdiff(genedf$names, largedf$names)


# # original for loop that is more easily done with the index line below
# for(i in 1:nrow(largedf)){
	# if !is.na(largedf$Reason){
		# largedf$names[i] <- paste (largedf$names[i], largedf$Sample.ID[i], sep='_')
	# }
# }

# Append mislabeled samples with the correct sample ID
# create an index of rows where the reason is not na and for the names in that index [inds], paste the sample id on with a _ in between
inds <- !is.na(largedf$Reason)
largedf$names[inds] <- paste(largedf$names[inds], largedf$SampleID[inds], sep='_')

##### IF YOU WANT TO CREATE A GENEPOP AT THIS POINT#########
# # Build the genepop components
# msg <- c("This genepop file was generated using a script called rosetta_genepop.R written by Michelle Stuart with help from Malin Pinsky")

# # create a list of loci names, separated by commas

# # loci <- toString(names(largedf[,2:2621])) # creates a space before the of the locus names - not good

# loci <- paste(names(largedf[,2:(ncol(largedf)-2)]), collapse =",") # sep is not comma separating, makes many lines instead of one line, collapse= ", " makes too many spaces between values, collapse="," is one space


# gene <- vector()
# sample <- vector()
# for (i in 1:nrow(largedf)){
	# # geno[i] <- toString(largedf[i,1:2621], sep = "\t")
	# gene[i] <- paste(largedf[i,2:(ncol(largedf)-2)], collapse = " ")
	# sample[i] <- paste(largedf[i,1], gene[i], sep = ", ")
# }

# out <- c(msg, loci, 'pop', sample)

# write.table(out, file = paste(Sys.Date(), 'renamed.genepop', sep = '_'), row.names=FALSE, quote=FALSE, col.names=FALSE) # won't let me use header=FALSE - should be using col.names

############## 2) FIND SAMPLES THAT HAVE BEEN REGENOTYPED #######


#########  THIS SECTION IS ONLY IF YOU ARE STARTING FROM THIS POINT
# # This script is intended to be used after a genepop file has been modified by the script 'rosetta_genepop.R' to fix erroneous sample IDs.  

# # this script can be run to find regenotyped and recaptured samples and determine which sampling event produced the most loci and determine genotype error rate.



# ###############################################
# ## compare genotypes at pairs of individuals
# ###############################################
# # # Malin's computer
# # setwd('/Users/mpinsky/Documents/Rutgers/Philippines/Genetics/genotyping/stacks_sensitivity_2015-07-17')

# # # Lightning
# # setwd('/Users/macair/Documents/Philippines/Genetics/regenotyping')
# # source('/Users/macair/Documents/Philippines/Genetics/code/readGenepop_space.R')

# # Mr. Whitmore
# setwd('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/regenotyping')
# source('/Users/michelle/Google Drive/Pinsky Lab/Cervus/Michelle\'s R codes/Genetics/code/readGenepop_space.R')

# genfile <- '../rosetta stone genepop/2016-04-30_renamed.genepop'

# library(RCurl)

# # read in rosetta stone
# library(googlesheets)
# # gs_auth(new_user = TRUE) # run this if having authorization problems
# mykey <- '1yhMEwka68eIAMbFKG4-KFWbmNb0JqzlML91mlX8mWj4' # for Rosetta Stone file
# stone <-gs_key(mykey)
# rosetta <-gs_read(stone, ws='Rosetta')

# largedf$regeno <- duplicated(largedf$Sample.ID) # this is supposed to change any duplicated Sample.IDs to TRUE in the regeno column, but it only changes the second occurrence, not the first.

################ END OF THE SECTION ####################

# Replace NA with SampleID in the dataframe
for(i in 1:nrow(largedf)){
	if(is.na(largedf$SampleID[i])){
		largedf$SampleID[i] <- substr(largedf$names[i], 1, 10)
	}
}

# make a list of all of the sample ID's that have duplicates (some on this list occur more than once because there are 3 regenos)
regeno_match <- largedf$SampleID[duplicated(largedf$SampleID)]

##### calculate the number of genotyped loci for each sample #####

# convert 0000 to NA in the genepop data
largedf[largedf == "0000"] = NA


# count the number of loci per individual
for(h in 1:nrow(largedf)){
	largedf$numloci[h] <- sum(!is.na(largedf[h,]))
}

# create a dataframe of just the regenotyped files
# num_loci <- largedf[,c('names', 'Sample.ID', 'numloci', 'regeno')]
# num_loci <- subset(num_loci, regeno == TRUE)

## write the num_loci into a csv for evaluation
# write.csv(num_loci, file = paste(Sys.Date(), 'num_loci.csv', sep = '_'))

# find the regenotyped samples with the most loci
# length <- nrow(largedf) # because nrow(largedf) is going to change during the for loop

# Drop all of the samples where true ID is unknown
largedf$drop <- NA
for(d in 1:nrow(largedf)){
	if(largedf$SampleID[d] == "XXXX")
	largedf$drop[d] <- "DROP"
}

#run through all of the SampleIDs that are found more than once and keep the one with the most loci
for(b in 1:length(regeno_match)){
	(regeno_drop <- which(as.character(largedf$SampleID)==c(as.character(regeno_match[b])))) # regeno_drop is the line number from largedf that matches an ID in the regeno_match list of sample.IDs
	df <- largedf[c(regeno_drop[1],regeno_drop[2],regeno_drop[3],regeno_drop[4]),]  # df is the data frame that holds all of the regenotyped versions of the sample, pulled from largedf
	df$drop <- NA # place holder
	keep <- which.max(df[,631]) # the row number of df with the largest number of loci
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
# remove the "DROP" rows from the data frame - have to convert all of the KEEPs to NAs first
for(g in 1:nrow(largedf)){
	if(!is.na(largedf$drop[g]) && largedf$drop[g]=="KEEP"){
		largedf$drop[g] <- NA
	}
}

# check that all of the XXXX sample IDs were dropped
largedf[which(largedf$SampleID == "XXXX"),]

# For some reason one of the samples is not changing the XXXX to a drop, doing it automatically here
largedf$drop[408] <- "DROP"

noregeno <- largedf[is.na(largedf$drop),]

# check to see if there are any regenos that were missed
noregeno_match <- noregeno$SampleID[duplicated(noregeno$SampleID)]
noregeno_match # should return character(0)


# remove the last columns from noregeno
noregeno [,c("drop")] <- NULL
noregeno [,c("numloci")] <- NULL
noregeno [,c("Reason")] <- NULL
noregeno [,c("SampleID")] <- NULL

# convert all the NA genotypes to 0000
noregeno[is.na(noregeno)] = "0000"



#############	3) OUTPUT A GENEPOP FILE ################
# you must output a genepop file to run through Cervus to look for recaptures
# Build the genepop components
msg <- c("This genepop file was generated using a script called process_genepop.R written by Michelle Stuart with help from Malin Pinsky")

# create a list of loci names, separated by commas

# loci <- toString(names(largedf[,2:2621])) # creates a space before the of the locus names - not good

# double check where the columns are in noregeno, make sure that the 3 for the 3rd column below is the first locus and that you want to use 4 below to eliminate the last 4 columns which are not loci.
names(noregeno)

loci <- paste(names(noregeno[,2:ncol(noregeno)]), collapse =",") 

gene <- vector()
sample <- vector()
for (i in 1:nrow(noregeno)){
	# geno[i] <- toString(largedf[i,1:2621], sep = "\t")
	gene[i] <- paste(noregeno[i,2:ncol(noregeno)], collapse = " ")
	sample[i] <- paste(noregeno[i,1], gene[i], sep = ", ")
}

out <- c(msg, loci, 'pop', sample)

write.table(out, file = paste(Sys.Date(), 'noregeno.genepop', sep = '_'), row.names=FALSE, quote=FALSE, col.names=FALSE) # won't let me use header=FALSE - use col.names instead of header


