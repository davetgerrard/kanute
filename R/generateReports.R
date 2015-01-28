generateReports <- function(x, softwares=names(x), reportFolder="reports/", testFolder="tests/", add.directory=F)  {
  require(knitr )
  for(thisSoftware in softwares)  {
    single.result <- x[[thisSoftware]]
    single.result$test <- as.character(single.result$test)  # remove factor
    for(i in 1:nrow(single.result))  {
      single.result$test[i] <- createTestLinks(test=as.character(single.result$test[i]), software=thisSoftware, testFolder=testFolder, relative.link=T, start.dir=reportFolder)
    }  
    kanuteReport(x=single.result, file=paste(reportFolder, software= thisSoftware, ".KanuteReport.md", sep=""))
    
  }
  if(add.directory) {
    require(markdown)
    dir.file <- paste(reportFolder, "kanuteReports.Rmd", sep="")
    cat("# Kanute report\n", file=dir.file)
    for(thisSoftware in softwares)  {
      cat(paste("- [",thisSoftware , "](", paste(thisSoftware, ".KanuteReport.html", sep="") ,")"), file=dir.file, append=T)
      cat("\n", file=dir.file, append=T)
    }
    outfile <- sub("Rmd", "html", dir.file)
    knit2html(dir.file, output=outfile)
  }
}

#generateReports(test.results)
#generateReports(test.results, add.directory=T)