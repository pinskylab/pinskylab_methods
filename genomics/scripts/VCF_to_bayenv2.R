# read VCF and turn into bayenv2 format with separate locus identifier file

setwd('/Users/mpinsky/Documents/Princeton/Anemonefish RNAseq')

# get the header
vcflines <- readLines(con = "Aardema/2016-10 STRUCTURE/output.hicov2.snps.only.vcf")
headerline <-  grepl('#CHROM', vcflines) # has field names
header <- vcflines[headerline]
header <- unlist(strsplit(header, split='\t'))
rm(vcflines)

# read in the file
vcf <- read.table("Aardema/2016-10 STRUCTURE/output.hicov2.snps.only.vcf", comment.char = "#", sep='\t')
dim(vcf) # 5729 x 34
names(vcf) <- header

# get locus names
locs <- vcf[,c(1,2)]

# trim to individuals
cols <- grepl('[NPJ][[:digit:]]', names(vcf))
vcf <- vcf[,cols]
dim(vcf) # 5729 x 25

# remove extra information
for(i in 1:ncol(vcf)){
	vcf[,i] <- gsub(pattern=":.*", "", vcf[,i]) # trim out all after the first :
}

# find columns for each population
pcols <- grepl('^P[[:digit:]]', names(vcf))
jcols <- grepl('^J[[:digit:]]', names(vcf))
ncols <- grepl('^N[[:digit:]]', names(vcf))

# count 0s and 1s by population
count01s <- function(x){
	als <- unlist(strsplit(split='/', fixed=TRUE, as.character(x))) # get alleles
	out <- c(sum(als==0), sum(als==1))
	return(out)
}

jals <- apply(vcf[,jcols], MARGIN=1, FUN=count01s) # count for japan
pals <- apply(vcf[,pcols], MARGIN=1, FUN=count01s) # for philippines
nals <- apply(vcf[,ncols], MARGIN=1, FUN=count01s) # for indonesia

# transform to 3-column bayenv2 format for output
# uses 1:n indexing to turn allele counts from 2xnloci matrices to nloci*2 vectors
be <- data.frame(J=jals[1:length(jals)], N=nals[1:length(nals)], P=pals[1:length(pals)])
dim(be) # 11458 x 3
summary(be)

# write out
write.table(be, file= "Hoey/output.hicov2.snps.only.txt", sep='\t', col.names=FALSE, row.names=FALSE)

write.table(locs, file= "Hoey/output.hicov2.snps.only_locnames.txt", sep='\t', col.names=FALSE, row.names=FALSE, quote=FALSE)


# make version with ONLY polymorphic SNPs
rownames(be) <- rep(1:nrow(locs), rep(2,nrow(locs))) + rep(c(0.1, 0.2), nrow(locs))
rownames(locs) <- 1:nrow(locs)

monos <- which(rowSums(be) == 0) # find rows with all zeros
for(i in 1:length(monos)){
	if(monos[i] %% 2 == 0){ # if even, add the line before as well (all loci start on odd lines)
		if(!((monos[i]-1) %in% monos)){
			monos <- c(monos, monos[i]-1)
		}
	} else { # else add line after
		if(!((monos[i]+1) %in% monos)){
			monos <- c(monos, monos[i]+1)
		}
	}
}
monos <- sort(monos)

be[monos,] # examine

bepoly <- be[!((1:nrow(be)) %in% monos),]
locspoly <- locs[!((1:nrow(locs)) %in% (monos[monos %% 2 == 0]/2)),] # just use the second of each pair (the even numbers) for locs, and divde by two

nrow(bepoly)
nrow(bepoly)/2
nrow(locspoly)


# write out polymorphic snps
write.table(bepoly, file= "Hoey/output.hicov2.snps.only.poly.txt", sep='\t', col.names=FALSE, row.names=FALSE)

write.table(locspoly, file= "Hoey/output.hicov2.snps.only.poly_locnames.txt", sep='\t', col.names=FALSE, row.names=FALSE, quote=FALSE)




# compare to Katelyn's VQSR_PASS_SNPS_CONVERTED3.txt 
old <- read.table("/local/home/malinp/Documents/MolEcol2015/VQSR_PASS_SNPS_CONVERTED3.txt", sep='\t')

dim(old) #  264057
dim(be) # 264354

jcomp <- c(old[,1], rep(-1,nrow(be)-nrow(old))) == be[,1] # find first mismatch. also catches lines reversed


benew <- be # version of be that I can re-order to match old
oldnew <- old # version that I can pad to match be

	# add rows that were missing
oldnew <- rbind(old[1:45,], c(0,0,0), old[46:nrow(old),])
oldnew <- rbind(oldnew[1:140,], c(0,0,0), oldnew[141:nrow(oldnew),])
oldnew <- rbind(oldnew[1:142,], c(0,0,0), oldnew[143:nrow(oldnew),])
oldnew <- rbind(oldnew[1:487,], c(0,0,0), oldnew[488:nrow(oldnew),])

rownames(oldnew) <- 1:nrow(oldnew)

	# compare
for(i in seq(1,nrow(oldnew), by=2)) {
	if(any(oldnew[i,] != benew[i,] | oldnew[i+1,] != benew[i+1,])){ # if mismatching
		if(all(oldnew[i,] == benew[i+1,] & oldnew[i+1,] == benew[i,])){ # if lines reversed
			benew[i,] = be[i+1,]
			benew[i+1,] = be[i,]
		} else {
			stop(paste("mismatch at", i))
		}
	}
}

jcomp <- c(old[,1], rep(-1,nrow(benew)-nrow(old))) == benew[,1] # find first mismatch. also catches lines reversed
inds <- 43:48
inds<- 139:146
inds<- 485:496
benew[inds,]
oldnew[inds,]


which(!jcomp)[1] # 11
old[11:16,]
be[11:16,]

