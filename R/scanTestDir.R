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