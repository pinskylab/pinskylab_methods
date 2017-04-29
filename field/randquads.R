n = 5

allocs = matrix(NA, nrow=12, ncol=5)
for(i in 1:12){
	locs = sort(floor(runif(n, 0,25)))
	while(any(diff(locs) == 0)){
		locs = sort(floor(runif(n, 0,25)))
	}

	allocs[i,] = locs
}
allocs