n = 5 # number of quadrats per transect
tx = 36 # number of transects


allocs = matrix(NA, nrow=tx, ncol=5)
for(i in 1:tx){
	locs = sort(floor(runif(n, 0,25)))
	while(any(diff(locs) == 0)){
		locs = sort(floor(runif(n, 0,25)))
	}

	allocs[i,] = locs
}
allocs
