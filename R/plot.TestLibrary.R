# not yet fully functional.
# ... pass variables to compareTests()
#' plot.testLibrary
#' 
#' Plot all tests in test.library
#' 
#' Not yet implemented
#' 
#' @param x param description
#' @param softwares param description
#' @param versions param description
#' @param ref.software param description
#' @param ref.versions param description
#' @param mapped.tests param description
#' @param show.all.tests param description
#' 
#' 
#' @export
plot.testLibrary <- function(x=test.library, softwares=names(x), versions=lapply(x, names),  ref.software = NULL, ref.versions =NULL, mapped.tests=NULL, show.all.tests=is.null(mapped.tests), ...)  {
  
  
  test.results <- compareTests(x, softwares=softwares, version=versions, ref.software=ref.software, ref.versions=ref.versions, mapped.tests=mapped.tests, show.all.tests=show.all.tests)
  thisSoftware <- softwares[1]
  versions <- setdiff(names(test.results[[thisSoftware]]), "test")
  matrix <- as.matrix(test.results[[thisSoftware]][, versions])
  par(mar=c(4,15,4,4))
  image(t(matrix), col=c("grey", "white"), xaxt="n", yaxt="n", xlab="version")
  #, xlab=versions, ylab=test.results[[thisSoftware]]$test
  grid(nx=ncol(matrix), ny=nrow(matrix))
  box()
  mtext(versions, side=1, at= seq(0, 1, length.out=length(versions)), adj=1)
  mtext(test.results[[thisSoftware]]$test, side=2, at= seq(0, 1, length.out=length(test.results[[thisSoftware]]$test)), adj=1, las=2)
}

# 
# plot.testLibrary(test.library)
