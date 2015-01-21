#
#' compareTests
#' 
#' Compares Tests.
#' 
#' Current version take library of test results from compileTestResults().  could write generic function that take result from above as argument or that can accept all the data and run the above too.
#' 
#' @param x param description
#' @param softwares param description
#' @param versions param description
#' @param ref.software param description
#' @param ref.versions param description
#' @param mapped.tests param description
#' @param show.all.tests param description
#' 
#' @return some comparison results
#' 
#' @export
compareTests <- function(x, softwares=names(x), versions=lapply(x, names),  ref.software = NULL, ref.versions =NULL, mapped.tests=NULL, show.all.tests=is.null(mapped.tests))  {
    # test each versions results against the reference
    #print(ref.software)
    #print(ref.version)
    # compile a table/matrix with test names in first column (can't always use row.names)
    # and remaining columns for different versions.
    results <- list() 
    
    stopifnot(length(intersect("MAPPED.TESTS", softwares)) == 0)    # cannot allow software with name "MAPPED.TESTS"
    
    if(is.null(ref.software)) {
        ref.software = names(x)[1]
    } 
    # if no reference version given in list
    if(is.null(ref.versions)) {
        ref.versions = list()        
    } 
    for(thisSoftware in softwares)  {    
        #if no reference given for this software.
        if(is.null(ref.versions[[thisSoftware]])) {
            ref.versions[[thisSoftware]] <- versions[[thisSoftware]][1]
        }
    }
    
    if(show.all.tests) {    # compare tests WITHIN each software.
        print("#######KANUTE###########: Comparing test results WITHIN each software")
        for(thisSoftware in softwares)  {
            print(thisSoftware)
            #thisRef.software <- thisSoftware

     
            #ref.version <- 
            #results[thisSoftware] <- data.frame(test=tests)
            ref.version <- ref.versions[[thisSoftware]]
            
            print(paste("Using version", ref.version, "as reference"))
            print(paste("Processing", length(versions[[thisSoftware]]),  "versions..."))
            #ref.results <- 
            results[[thisSoftware]] <- data.frame()
            
            for(thisVersion in versions[[thisSoftware]])  {
                print(thisVersion)
                tests <- names(x[[thisSoftware]][[thisVersion]])
                #print(tests)
                versionData <- data.frame(test=tests, result= as.character(x[[thisSoftware]][[thisVersion]][tests]) ==  as.character(x[[thisSoftware]][[ref.version ]][tests]))
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
        
        
    }
    
    if(!is.null(mapped.tests))  {   # compare tests BETWEEN sofwares.
        print("#######KANUTE###########: Comparing tests BETWEEN softwares")
        print(paste(nrow(mapped.tests), "mapped tests"))

        #results[['MAPPED.TESTS']] <- data.frame(row.names=c("a", "v"))
        mapped.tests$result <- NA    
        for(i in 1:nrow(mapped.tests))  {
            
            s1 <- mapped.tests[i,'software1']
            t1 <- mapped.tests[i,'software1.test']
            s2 <- mapped.tests[i,'software2']
            t2 <- mapped.tests[i,'software2.test']
            expect <- mapped.tests[i,'expectIdentical']
            v1 <-  ref.versions[[s1]]
            v2 <- ref.versions[[s2]]
            #for(thisVersion in versions[[thisSoftware]])  {
            # let's not go through all version and just use the refVersions for each software.
            
            mapped.tests[i,'result'] <-   as.character(x[[s1]][[v1]][t1]) ==  as.character(x[[s2]][[v2]][t2 ])
            mapped.tests[i,'ver1'] <- v1
            mapped.tests[i,'ver2'] <- v2
            #}
            
            
        }
        results[['MAPPED.TESTS']] <- mapped.tests
        #print(paste("Using ", ref.software, "as reference"))
        
        
    }
    return(results)
    
}