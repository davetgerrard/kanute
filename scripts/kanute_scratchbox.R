
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




#####################################

# Folder and test set-up

# Folders for each software follow the same format
# single test creates a single output file.
# Software version list given in <software>.versions file 
# Where specific versions are not given, put test results in a folder 'current'




########### Reading testing results produced elsewhere (no local testing, only comparison).

testingFolder <- "C:/Users/Dave/HalfStarted/Kanute/TestFolder"
testDirTop <- paste(testingFolder, "tests",sep="/")
outputsDirTop <- paste(testingFolder, "outputs",sep="/")
source('C:/Users/Dave/HalfStarted/Kanute/scripts/kanute_funcs.R')




softwares <- c("bowtie", "bowtie2")

testing.list <- scanTestDir(softwares=softwares, testDirTop=testDirTop)



test.library <- compileTestResults(testing.list, outputsDirTop)



test.results <- compareTests(test.library)

# created a tab-delim file called test.mappings in top of tests/ folder
# mapping.name software1 software1.testA software2   software2.testA TRUE
# the final column is TRUE if expect results to be the same, FALSE if not or NA if unknown.
# May need to be 1/0 instead of TRUE/FALSE

test.mappings <- read.delim(paste(testDirTop, "test.mappings", sep="/"), header=F, stringsAsFactors=F)
names(test.mappings) <- c("mapping.name", "software1", "software1.test", "software2", "software2.test", "expectIdentical")



test.results <- compareTests(test.library, mapped.tests=test.mappings)


# by default, if mapped.tests parameter given, tests within Software is suppressed
# Here's how to turn it back on
test.results <- compareTests(test.library, mapped.tests=test.mappings, show.all.tests=TRUE)


## specify the reference versions to be used in tests BETWEEN software
test.results <- compareTests(test.library, mapped.tests=test.mappings, ref.versions=list(bowtie="1.0.1", bowtie2="2.2.3"))





stopifnot(FALSE)





name <- "bowtie2"
testDirTop <- paste(testingFolder, "tests",sep="/")
testDir <- paste(testDirTop, name,sep="/")
outputsDirTop <- paste(testingFolder, "outputs",sep="/")
outputsDir <- paste(outputsDirTop, name,sep="/")

versions.file <- paste(testDir, paste(name, "versions", sep="."),sep="/")
versions.info <- read.delim(versions.file, header=F)

tests <- dir(testDir, pattern="test.sh")
# using filenames should ensure unique names for tests (?)





outputs <- findTestOutputs(testDir)

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


#test.library <- compileTestResults(names="bowtie2", versions=as.character(versions.info[,1]), tests=tests, outputsDir=outputsDir)




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
# simpler starter example may be bowtie vs bowtie 2


# created a tab-delim file called test.mappings in top of tests/ folder
# software1 software1.testA software2   software2.testA TRUE
# the fifth column is TRUE if expect results to be the same, FALSE if not or NA if unknown.
# May need to be 1/0 instead of TRUE/FALSE

test.mappings <- read.delim(paste(testDirTop, "test.mappings", sep="/"), header=F, stringsAsFactors=F)
names(test.mappings) <- c("software1", "software1.test", "software2", "software2.test", "expectIdentical")


# for each software-test, need to collate test info as above
#   What are the expected output files?
#   Are the files available?   (option to re-run tests?)
#   How to deal with versions (or lack thereof)?

outputs.bowtie <- findTestOutputs(paste(testDirTop, "bowtie",sep="/"))
outputs.bowtie2 <- findTestOutputs(paste(testDirTop, "bowtie2",sep="/"))

versions.bowtie <- "1.0.1"
versions.bowtie2 <- "2.2.3"

test.library.bowtie <- compileTestResults(names="bowtie", versions=versions.bowtie , outputs=outputs.bowtie, outputsDir=paste(outputsDirTop, "bowtie",sep="/"))
test.library.bowtie2 <- compileTestResults(names="bowtie2", versions=versions.bowtie2, outputs=outputs.bowtie2, outputsDir=paste(outputsDirTop, "bowtie2",sep="/"))

names(test.library.bowtie)  #versions
names(test.library.bowtie2)  #versions

#TODO re-write compareTests to either take two libraries, or a single library containing multiple software tests 
#       PLUS the list of test mappings between softwares.
# A single library would be best
# [[library]][[software]][[version]][[test]]

version.1 <- "1.0.1"
version.2 <- "2.2.3"

for(i in 1:nrow(test.mappings))  {
    soft.1 <- test.mappings[i,'software1']
    soft.2 <- test.mappings[i,'software2']
    test.1 <- test.mappings[i,'software1.test']
    test.2 <- test.mappings[i,'software2.test']    
    expect <- test.mappings[i,'expectIdentical']   
    print(paste(test.1, " vs", test.2))
    print(paste(  "Expect:", expect, "Result:" ,     test.library[[soft.1]][[version.1]][[test.1]]  == test.library[[soft.2]][[version.2]][[test.2]] ))
}


