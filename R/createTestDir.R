

createTestDir <- function(topDir=getwd(), folders =c("inputs", "outputs", "tests", "reports"), softwares=NULL, add.subs=c("outputs", "tests")) {
  
  if(!file.exists(topDir))   dir.create(topDir)
  
  for(thisFolder in folders)  {
    folderPath <- paste(topDir, thisFolder, sep="/")
    dir.create(folderPath)
  }
  
  if(!is.null(softwares))  {
    for(thisFolder in add.subs)  {
      for(thisSoftware in softwares) {
        folderPath <- paste(topDir, thisFolder, thisSoftware, sep="/")
        dir.create(folderPath)
      }
    }    
  }
}

# createTestDir()
# createTestDir("testFolder")
# createTestDir(softwares=c("bowtie", "bowtie2"))

