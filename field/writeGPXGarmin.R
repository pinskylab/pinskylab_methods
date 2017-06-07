#' Write GPX
#'
#' This function allows you to write GPX format given the header and the data from readGPXGarmin_2013_06_01.R
#' @param outfile The file name of the output
#' @param filename The name of the input
#' @keywords gpx
#' @export
#' @examples
#' writeGPX(outfile, filename)


writeGPX = function(outfile, filename){
	con = file(filename, open = 'wt')
	cat(header, file=con) # write the same header

	# add the data
	
	for(i in 1:nrow(outfile)){
		cat('<trkpt lat="', file=con)
		cat(outfile$lat[i], file=con)
		cat('" lon="', file=con)
		cat(outfile$lon[i], file=con)
		cat('"><ele>', file=con)
		cat(outfile$elev[i], file=con)
		cat('</ele><time>', file=con)
		cat(str_sub(outfile$time[i],1,10), file=con)
		cat("T", file = con)
		cat(str_sub(outfile$time[i],12,19), file=con)
		cat('Z</time></trkpt>', file=con)
	}

	# finish up the file
	cat('</trkseg></trk></gpx>', file=con)

	# close up
	close(con)
}
