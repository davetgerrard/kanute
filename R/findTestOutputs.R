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