
#' convertLinkToRelative 
#' 
#' convertLinkToRelative 
#' 
#' converts a file path to a relative link within the system. If the file is on a different system, it is unchanged.
#' 
#' @param x a path to a file
#' @param start.dir  from which directory should the relative link be made [default working dir]
#' 
#' @return a character string relative path
#' 
convertLinkToRelative <- function(x, start.dir=getwd()) {
  # normalise paths.
  x.n <- normalizePath(x, winslash ="/", mustWork=F)
  start.n <- normalizePath(start.dir, winslash ="/", mustWork=F)  # only need directory
  
  # should now be '/' separated
  
  tokens.x <- unlist(strsplit(x.n, "/"))
  tokens.s <- unlist(strsplit(start.n, "/"))
  # if two files/folders on same system, then return original path with a warning.
  if(tokens.x[1] != tokens.s[1])  {
    warning("File is on a different system!")
    rel.path <- x
  } else {
    # determine lowest folder in common.
    min.length <- min(length(tokens.x), length(tokens.s))
    match.index <-  tokens.s[1:min.length] == tokens.x[1:min.length]
    first.false <-   match(F, match.index)
    if(is.na(first.false) ){ 
      rel.path <- paste(c(".", tokens.x[(min.length+1):length(tokens.x)]) , collapse="/")
    } else { 
      blank.length <- length(tokens.s) - (first.false - 1)
      rel.path <- paste(c(rep("..", blank.length ), tokens.x[first.false:length(tokens.x)]) , collapse="/")
    }
  }
  return(rel.path) 
}
# convertLinkToRelative("/mnt/folder1/folderA/fileX", start.dir="/mnt/folder1/folderB")