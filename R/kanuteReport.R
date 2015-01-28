kanuteReport <- function(x, file="kanute.report.md", software="", format="md")  {
  md.file <- file
  require(markdown)
  require(knitr)
  cat(paste("#", software, "Kanute report\n"), file=md.file)
  cat(kable(x, format="markdown", align="c"), fill=T, file=md.file, append=T)
  cat("\n", file=md.file, append=T)
  outFile <- sub(".md$", ".html", md.file)
  print(outFile)
  knit2html(md.file, output=outFile, options=c('base64_images') , stylesheet="C:/Users/Dave/HalfStarted/AnalysisMake/markdown_DTG.css" )
}

#kanuteReport(x=single.result, file="reports/testReport.md")