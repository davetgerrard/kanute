#' scanTestDir
#' 
#' scanTestDir for tests
#' 
#' Scans the testdir for tests. Runs \code{\link{findTestOutputs}} on each software sub-folder of tests
#' 
#' @param softwares vector of softwares to include
#' @param testDirTop location of testDir
#' 
#' @return a list of results.
#' 
#' @export
scanTestDir <- function(softwares, testDirTop)  {
    result.list <- list()
    for(thisSoftware in softwares)  {
        testDir <- paste(testDirTop, thisSoftware,sep="/")
        result.list[[thisSoftware]][['outputs']] <- findTestOutputs(testDir)
        versions.file <- paste(testDir, paste(thisSoftware, "versions", sep="."),sep="/")
        result.list[[thisSoftware]][['versions.info']] <- try(read.delim(versions.file, header=F))
    }
    return(result.list)
    
}