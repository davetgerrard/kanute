# plot an individual test comparison result from compareTests()
#' plot.versionTest 
#' 
#' plot.versionTest 
#' 
#' Plots the results of compareTests() for an individual piece of software.
#' 
#' @param x a data frame of the type returned by compareTests()
#' @param versions  Which software versions to include (default is all).
#' 
#' 
#' @export
plot.versionTest <- function(x, versions = setdiff(names(x), "test"))  {
  
  matrix <- as.matrix(x[, versions])
  par(mar=c(4,15,4,4))
  image(t(matrix), col=c("grey", "white"), xaxt="n", yaxt="n", xlab="version")
  grid(nx=ncol(matrix), ny=nrow(matrix))
  box()
  mtext(versions, side=1, at= seq(0, 1, length.out=length(versions)), adj=1)
  mtext(x$test, side=2, at= seq(0, 1, length.out=length(x$test)), adj=1, las=2)
  
}

# plot.versionTest(test.results[['bowtie']])