# only works if Genepop has loci listed in 2nd line (separated by commas), has individual names separated from genotypes by a comma, and uses tabs between loci
# return a data frame: col 1 is individual name, col 2 is population, cols 3 to 2n+2 are pairs of columns with locus IDs
readGenepop = function(filename){
	lines = readLines(filename, n= -1)
	header = lines[1]
	loci = unlist(strsplit(lines[2], split=','))
	lines = lines[3:length(lines)]
	popstarts = grep('pop', lines)
	if(length(popstarts)>1){
		popends = c(popstarts[2:length(popstarts)], length(lines)+1)
	} else {
		popends = length(lines)+1
	}
	npops = length(popstarts)
	out = data.frame(names = character(0), pop = numeric(0)) # dataframe to hold the output
	for(i in 1:length(loci)) out[[loci[i]]] = character(0) # create columns for loci
	for(i in 1:npops){
		theselines = seq(popstarts[i]+1, popends[i]-1) # the lines for this population
		dat = unlist(strsplit(lines[theselines], split=',|,\t'))
		nms = dat[seq(1, 2*(popends[i] - popstarts[i]-1), by=2)] # extract the individual ids
		genos = dat[seq(2, 2*(popends[i] - popstarts[i]-1), by=2)] # extract the genotypes from the individual ids
		genos = strsplit(genos, '\t') # break every locus apart
		temp = data.frame(t(genos[[1]]), stringsAsFactors=FALSE)
		temp = temp[rep('1', length(genos)),] # allocate dataframe to hold genotypes
		for(j in 2:length(genos)) temp[j,] = t(genos[[j]])
		names(temp) = loci
		temp$names = nms
		temp$pop = i
		out = rbind(out, temp) # inefficient
	}

	out = out[,c('pop', 'names', loci)] # re-order columns
	rownames(out) = 1:nrow(out)

	return(out)	
}