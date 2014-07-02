
###


# Test functionality of software as per unit tests.
# Compare functionality between versions of same software.
# Compare functionality between different software (given mapping of functionality).


# testFolder/inputs   small units of test data
# testFolder/outputs    # results from tests, stored in sub-directories by software, then version.
# testFolder/tests      # scripts defining inputs -> outputs. Enough post-processing to give consistent output (e.g. sorting, filenames?).
# testFolder/func_maps  # lists linking tests performed in one software/version with another software/version.

# Allow for 'generic' tests where different versions of the same software should be able to run the same test and produce the same output but 

# This is NOT performance benchmarking.
# This is to check for consistency in results e.g. PASS/FAIL for comparison of different versions of software or between different software applied to the same inputs.


# Allows users to run new results for all tests or only a subset (might be useful if tests are slow or if worried that testing framework may become broken.). 

# Allow users to manually add in custom outputs so they can test software against results generated on another system. 
# This software should be able to run the tests, but also just compile results based on pre-run outputs. (separate run-tests from report-tests)

#MD5SUM for file comparison? Do filenames matter?

# Ideally, folder stucture and run-tests framework should NOT be R specific, could write port for python etc. But test scripts should work on current OS using system.calls.
# Report-tests then written in R, python (bash?) etc.

# make one of the generic tests a --version call - this should always fail to give same results between software versions.

# PROBLEM: how to know if a test has been properly run and output freshly generated?  make?


# Allow self-tests, whereby new-results are compared with old results.  Does this require an archive? Or just make a copy of the software-version directory.

# Test comparison is pairwise. If multiple versions, user selects a reference (e.g. most recent) or first listed is taken. 
# Perhaps give list of versions to consider in tests or outputs folders.

# allow arbitrary folder depth for test results and lists of outputs directories (with some naming), so that equivalent folders can be compared across systems (e.g. server-1 vs. server-2).


########### Reading testing results produced elsewhere (no local testing, only comparison).

testingFolder <- "C:/Users/Dave/HalfStarted/Kanute/TestFolder"


name <- "bowtie2"
testDir <- paste(testingFolder, "tests", name,sep="/")
outputsDir <- paste(testingFolder, "outputs", name,sep="/")

versions.file <- paste(testDir, paste(name, "versions", sep="."),sep="/")
versions.info <- read.delim(versions.file, header=F)

tests <- dir(testDir, pattern="test.sh")
# using filenames should ensure unique names for tests (?)


## try to find expected output from test files.
# in bash, should use the TEST_OUT_NAME variable.
outputs <- character()
for(thisTest in tests)  {
    fileLines <- scan(paste(testDir, thisTest, sep="/"), what="character")
    outLine <- grep("TEST_OUT_NAME=", fileLines, value=T)
    outFile <- unlist(strsplit(outLine, '='))[2]
    outFile <- gsub("'", "", outFile) # remove quotes from ends if there
    outputs[thisTest] <- outFile
}


# probably should define some list structure to hold tests


thisTest <- tests[1]
thisTest <- tests[2]


refVersion <- "2.2.3"
thisVersion <- "2.2.0"

thisName <- name

refOutDir <- paste(outputsDir,  refVersion, sep="/")
thisOutDir <- paste(outputsDir,  thisVersion, sep="/")

refOutFile <- paste(refOutDir,  outputs[thisTest], sep="/")
thisOutFile <- paste(thisOutDir, outputs[thisTest], sep="/")

md5.call <- paste("md5sum", refOutFile) 
ref.md5 <- try(system(md5.call, intern=T, ignore.stderr = TRUE))
md5.call <- paste("md5sum", thisOutFile) 
this.md5 <- try(system(md5.call, intern=T, ignore.stderr = TRUE))


compileTestResults <- function(names, versions, tests, outputsDir)  {
    result.list <- list()
    thisName <- names[1]  # expand later to multi-tests
    
    for(thisVersion in versions)  {
        result.list[[thisVersion]] <- list()
        thisOutDir <- paste(outputsDir,  thisVersion, sep="/")
        for(thisTest in tests)  {
            
            thisOutFile <- paste(thisOutDir, outputs[thisTest], sep="/")
            md5.call <- paste("md5sum", thisOutFile) 
            this.md5 <- try(system(md5.call, intern=T, ignore.stderr = TRUE))
            result.list[[thisVersion]][[thisTest]] <- unlist(strsplit(this.md5, ' '))[1]
        }
    }   
    return(result.list)
}



test.library <- compileTestResults(names="bowtie2", versions=as.character(versions.info[,1]), tests=tests, outputsDir=outputsDir)




# could write generic function that take result from above as argument or that can accept all the data and run the above too.
# Current version take library of test results from compileTestResults()
compareTests <- function(test.library, versions=as.character(versions.info[,1]), tests, ref.version=versions[1])  {
    # test each versions results against the reference
    print(ref.version)
    # compile a table/matrix with test names in first column (can't always use row.names)
    # and remaining columns for different versions.
    results <- data.frame(test=tests)
    for(thisVersion in versions)  {
        versionVec <- logical()
        for(thisTest in tests)  {
            versionVec[thisTest] <- test.library[[thisVersion]][[thisTest]]  == test.library[[ref.version]][[thisTest]]
            
        }
        results[,thisVersion] <- versionVec
        # need to speed this up
    }
    
    return(results)
    
}


test.results <- compareTests(test.library, versions=as.character(versions.info[,1]), tests)



# TODO: combine/compare tests across softwares (e.g. TopHat vs STAR)
#   requires test/function mapping
#  e.g. tophat_alignSimplePair.test  vs STAR_alignSimplePair.test.
#  Tests need to be properly set up so that they produce same output (sorted reads, no random-ness). 
#  Could do with a facility to test if a single test produces consistent results across numerous runs.







