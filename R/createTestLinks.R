
#' createTestLinks 
#' 
#' createTestLinks 
#' 
#' creates links to test file locations to be used in html/markdown reporting.
#' 
#' @param test a data frame of the type returned by compareTests()
#' @param software  which software
#' @param testFolder top level testfolder
#' @param format  c("markdown", "html")
#' @param check.test.file  check whether the created link points to a real file
#' @param relative.link  make the file path relative (uses convertLinkToRelative())
#' @param start.dir  to which directory should the link be relative
#' 
#' @export
#' 
createTestLinks <- function(test, software, testFolder, format="markdown", check.test.file=TRUE, relative.link=TRUE, start.dir=getwd())  {
  file.loc <- paste(testFolder, software, test, sep="/")
  
  # output as a relative link (aides 
  if(relative.link)  file.loc <- convertLinkToRelative(file.loc, start.dir=start.dir)
  
  #markdown
  linked.text <- paste("[", test, "](", file.loc, ")", sep="")
  
  return(linked.text)
}

# createTestLinks(test="bowtie_singleRead_2.generic.test.sh", software="bowtie", testFolder=testDirTop)
# createTestLinks(test="bowtie_singleRead_2.generic.test.sh", software="bowtie", testFolder=testDirTop, relative.link=F)