#
# 
#[[library]][[software]][[version]][[test]]
#  names must be vector of 
#' compileTestResults
#' 
#' Compiles test results. 
#' 
#' creates a list of lists (of lists) [[library]][[software]][[version]][[test]]
#' 
#' @param softwareList list of softwares
#' @param outputsDirTop top of output dirs
#' 
#' @return a list of lists of lists [[library]][[software]][[version]][[test]]
#' 
#' @export
compileTestResults <- function(softwareList,  outputsDirTop)  {
    result.list <- list()
    
    #thisName <- names[1]  # expand later to multi-tests
    for(thisSoftware in names(softwareList))  {
        result.list[[thisSoftware]] <- list()
        outputsDir <- paste(outputsDirTop, thisSoftware,sep="/")
        versions <- as.character(softwareList[[thisSoftware]][['versions.info']][, 1])
        outputs <- softwareList[[thisSoftware]][['outputs']]
        tests <- names(outputs)
        for(thisVersion in versions)  {
            result.list[[thisSoftware]][[thisVersion]] <- list()
            thisOutDir <- paste(outputsDir,  thisVersion, sep="/")
            for(thisTest in tests)  {
                
                thisOutFile <- paste(thisOutDir, outputs[thisTest], sep="/")
                md5.call <- paste("md5sum", thisOutFile) 
                this.md5 <- try(system(md5.call, intern=T, ignore.stderr = TRUE))
                result.list[[thisSoftware]][[thisVersion]][[thisTest]] <- unlist(strsplit(this.md5, ' '))[1]
            }
        }   
    }
    return(result.list)
}