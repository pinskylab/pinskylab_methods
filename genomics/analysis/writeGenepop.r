# Outputs a Genepop-format file for Genepop or LDNE
# geno: dataframe of locus IDs: rows are individuals, pairs of columns are loci
# loci: vector of locus names
# pops: population name for each row of geno
# nms: names for each individual. Defaults to the name of the population.

writeGenepop = function(file = 'out.gen', header='', geno, loci=paste('L', 1:(ncol(geno)/2)), pops = rep(0,nrow(geno)), nms = pops){

	if(ncol(geno) %% 2 != 0) stop('Need 2 columns for every locus')
		
	# Open the file
	genpopfile = file(file)
	open(genpopfile, "w")

	# Basic info
	poplist = sort(unique(pops))

	# Header
	cat(paste("Title line: ", header, sep=""), file= genpopfile, sep=",", append=FALSE)
	cat("\n", file= genpopfile, append=TRUE)
	cat(paste(loci, collapse="\n"), file= genpopfile, append=TRUE)
	cat("\n", file= genpopfile, append=TRUE)

	for(j in 1:length(poplist)){
		k = which(pops==poplist[j])
		if(length(k)>0){
			cat("Pop", file= genpopfile, sep="", append=TRUE)
			cat("\n", file= genpopfile, append=TRUE)
		
			# collapse locus alleles with ""
			out = paste("     ", nms[k], ",", sep="") # name each indiv according to population name
			for(c in seq(1,ncol(geno), by=2)){
				als1 = geno[k,c]
				als2 = geno[k,c+1]
				als1[is.na(als1)] = '000' # turn NAs to 000
				als2[is.na(als2)] = '000' 
				out = cbind(out, paste(formatC(als1, width=3, flag="0"), formatC(als2, width=3, flag="0"), sep=""))
			}
			for(c in 1:nrow(out)){
				cat(paste(out[c,], collapse=" "), file=genpopfile, append=TRUE)
				cat("\n", file= genpopfile, append=T)
			}
		}
	}
	close(genpopfile)	

}