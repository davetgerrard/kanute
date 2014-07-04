#
# creates a list of lists (of lists)
#[[library]][[software]][[version]][[test]]
#  names must be vector of 
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



## try to find expected output from test files.
# in bash, should use the TEST_OUT_NAME variable.
findTestOutputs <- function(testDir)  {
    tests <- dir(testDir, pattern="test.sh")
    outputs <- character()
    for(thisTest in tests)  {
        fileLines <- scan(paste(testDir, thisTest, sep="/"), what="character")
        outLine <- grep("TEST_OUT_NAME=", fileLines, value=T)
        outFile <- unlist(strsplit(outLine, '='))[2]
        outFile <- gsub("'", "", outFile) # remove quotes from ends if there
        outputs[thisTest] <- outFile
    }
    return(outputs)
}