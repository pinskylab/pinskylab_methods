## Read Arlequin .arp file
## Assumes data are DNA sequences without a haplotype definition block
## Assumes that frequency of each sequence is 1

infile = file("AncModEPacATown070418.arp", open = "r", blocking = FALSE)

# Find NbSamples
k = FALSE
j = 0
while(k == FALSE){
	j = j+1
	line = readLines(infile, n = 1)
	k = any(grep("NbSamples", line))
	}
str = unlist(strsplit(as.character(line), split = ""))
k = grep("=",str)	
NbSamples = as.integer(paste(str[(k+1):(length(str))], collapse=""))

# Set up list to hold data
popdata = list(Pop = list(character()), Size = list(integer()), Name = list(matrix()), Seq= list(matrix()))

for(i in 1:NbSamples){
	# Find sample name
	k = FALSE
	while(k == FALSE){
		j = j+1
		line = readLines(infile, n = 1)
		k = any(grep("SampleName", line))
		}
	str = unlist(strsplit(as.character(line), split = ""))
	k = grep("\"",str)	
	samplename = paste(str[(k[1]+1):(k[2]-1)], collapse = "")
	popdata$Pop[i] = samplename
	
	# Find sample size	
	k = FALSE
	while(k == FALSE){
		j = j+1
		line = readLines(infile, n = 1)
		k = any(grep("SampleSize", line))
		}
	str = unlist(strsplit(as.character(line), split = ""))
	k = grep("=",str)	
	samplesize = as.integer(paste(str[(k+1):(length(str))], collapse=""))
	popdata$Size[i] = samplesize

	# Find first haplotype
	k = FALSE
	while(k == FALSE){
		j = j+1
		line = readLines(infile, n = 1)
		k = any(grep("SampleData", line))
		}	
	popdata$Name[i] = list(x = character(samplesize))
	popdata$Seq[i] = list(x = character(samplesize))
	for(m in 1:samplesize){
		line = readLines(infile, n = 1)
		str = unlist(strsplit(as.character(line), split = ""))
		k = grep(" ",str)
		name = paste(str[1:(k[1]-1)], collapse="") 
		popdata$Name[[i]][m] = name
		seq = paste(str[(k[length(k)]+1):length(str)], collapse="")
		popdata$Seq[[i]][m] = seq
	}
} 
	
close(infile)