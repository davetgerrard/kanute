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



# could write generic function that take result from above as argument or that can accept all the data and run the above too.
# Current version take library of test results from compileTestResults()
#
compareTests <- function(x, sofwares=names(x), versions=lapply(x, names),  ref.software = NULL, ref.versions =NULL, mapped.tests=NULL, show.all.tests=is.null(mapped.tests))  {
    # test each versions results against the reference
    #print(ref.software)
    #print(ref.version)
    # compile a table/matrix with test names in first column (can't always use row.names)
    # and remaining columns for different versions.
    results <- list() 
    
    if(show.all.tests) {    # compare tests WITHIN each software.
        cat("Comparing test results within each software")
        for(thisSoftware in softwares)  {
            ref.software <- thisSoftware
            # if no reference version given in list
            if(is.null(ref.versions)) {
                ref.versions = list()        
            } 
            #if no reference given for this software.
            if(is.null(ref.versions[[thisSoftware]])) {
                ref.versions[[thisSoftware]] <- versions[[thisSoftware]][1]
            }
            #ref.version <- 
            #results[thisSoftware] <- data.frame(test=tests)
            ref.version <- ref.versions[[thisSoftware]]
            
            #ref.results <- 
            results[[thisSoftware]] <- data.frame()
            
            for(thisVersion in versions[[thisSoftware]])  {
                tests <- names(x[[thisSoftware]][[thisVersion]])
                #print(tests)
                versionData <- data.frame(test=tests, result= as.character(x[[thisSoftware]][[thisVersion]][tests]) ==  as.character(x[[ref.software]][[ref.version ]][tests]))
                names(versionData) <- c("test", thisVersion)
                if(nrow(results[[thisSoftware]]) == 0)  {
                    results[[thisSoftware]] <- versionData
                } else {
                    results[[thisSoftware]] <- merge(results[[thisSoftware]], versionData,  by="test", all=TRUE)
                }
                #for(thisTest in tests)  {
                #    versionVec[thisTest] <- x[[thisSoftware]][[thisVersion]][[thisTest]]  == x[[thisSoftware]][[ref.version]][[thisTest]]    
                #}
                
                
                #results[[thisSoftware]][,thisVersion] <- versionVec
                # need to speed this up
            }
        }
        
        if(!is.null(mapped.tests))  {   # compare tests BETWEEN sofwares.
            cat("Comparing tests BETWEEN softwares")
        }
    }
    return(results)
    
}
