# KANUTE - version testing between softwares and versions   <a name="Top"></a> 

# Working notebook

### Dave T. Gerrard, University of Manchester
### Produced 2014-07-07
[Dave's website](http://personalpages.manchester.ac.uk/staff/David.Gerrard/)


## Table of contents ##
- [Example](#Example)
- [](#)
- [](#)

```
## [1] "/mnt/lustre/scratch/mqbssdgb/kanute/TestFolder/reports"
```

[Back to top](#Top)


## <a name="Example"></a>Example ##

TODO




```r
########### Reading testing results produced elsewhere (no local testing, only comparison).
#
parent_dir <-  paste(Sys.getenv("SCRATCH"),"kanute", sep="/")
testingFolder <- paste(parent_dir, "TestFolder", sep="/")
testDirTop <- paste(testingFolder, "tests",sep="/")
outputsDirTop <- paste(testingFolder, "outputs",sep="/")
source(paste(parent_dir, "scripts/kanute_funcs.R", sep="/"))
#
#
#
#
softwares <- c("bowtie", "bowtie2")
#
testing.list <- scanTestDir(softwares=softwares, testDirTop=testDirTop)
#
#
#
test.library <- compileTestResults(testing.list, outputsDirTop)
#
#
#
test.results <- compareTests(test.library)
```

```
## [1] "#######KANUTE###########: Comparing test results WITHIN each software"
## [1] "bowtie"
## [1] "Using version 0.12.7 as reference"
## [1] "Processing 5 versions..."
## [1] "0.12.7"
## [1] "0.12.8"
## [1] "0.12.9"
## [1] "1.0.0"
## [1] "1.0.1"
## [1] "bowtie2"
## [1] "Using version 2.2.3 as reference"
## [1] "Processing 9 versions..."
## [1] "2.2.3"
## [1] "2.2.2"
## [1] "2.2.1"
## [1] "2.2.0"
## [1] "2.1.0"
## [1] "2.0.5"
## [1] "2.0.2"
## [1] "2.0.0-beta7"
## [1] "2.0.0-beta6"
```

```r
#
## created a tab-delim file called test.mappings in top of tests/ folder
## mapping.name software1 software1.testA software2   software2.testA TRUE
## the final column is TRUE if expect results to be the same, FALSE if not or NA if unknown.
## May need to be 1/0 instead of TRUE/FALSE
#
test.mappings <- read.delim(paste(testDirTop, "test.mappings", sep="/"), header=F, stringsAsFactors=F)
names(test.mappings) <- c("mapping.name", "software1", "software1.test", "software2", "software2.test", "expectIdentical")
#
#
#
test.results <- compareTests(test.library, mapped.tests=test.mappings)
```

```
## [1] "#######KANUTE###########: Comparing tests BETWEEN softwares"
## [1] "2 mapped tests"
```

```r
#
#
## by default, if mapped.tests parameter given, tests within Software is suppressed
## Here's how to turn it back on
test.results <- compareTests(test.library, mapped.tests=test.mappings, show.all.tests=TRUE)
```

```
## [1] "#######KANUTE###########: Comparing test results WITHIN each software"
## [1] "bowtie"
## [1] "Using version 0.12.7 as reference"
## [1] "Processing 5 versions..."
## [1] "0.12.7"
## [1] "0.12.8"
## [1] "0.12.9"
## [1] "1.0.0"
## [1] "1.0.1"
## [1] "bowtie2"
## [1] "Using version 2.2.3 as reference"
## [1] "Processing 9 versions..."
## [1] "2.2.3"
## [1] "2.2.2"
## [1] "2.2.1"
## [1] "2.2.0"
## [1] "2.1.0"
## [1] "2.0.5"
## [1] "2.0.2"
## [1] "2.0.0-beta7"
## [1] "2.0.0-beta6"
## [1] "#######KANUTE###########: Comparing tests BETWEEN softwares"
## [1] "2 mapped tests"
```

```r
#
#
### specify the reference versions to be used in tests BETWEEN software
test.results <- compareTests(test.library, mapped.tests=test.mappings, ref.versions=list(bowtie="1.0.1", bowtie2="2.2.3"))
```

```
## [1] "#######KANUTE###########: Comparing tests BETWEEN softwares"
## [1] "2 mapped tests"
```

```r
#
#

#What have we got at the end of all that
test.results
```

```
## $MAPPED.TESTS
##           mapping.name software1                      software1.test software2                       software2.test expectIdentical result  ver1  ver2
## 1 singleRead_1.generic    bowtie bowtie_singleRead_1.generic.test.sh   bowtie2 bowtie2_singleRead_1.generic.test.sh           FALSE  FALSE 1.0.1 2.2.3
## 2 singleRead_2.generic    bowtie bowtie_singleRead_2.generic.test.sh   bowtie2 bowtie2_singleRead_2.generic.test.sh            TRUE   TRUE 1.0.1 2.2.3
```



[Back to top](#Top)


[Back to top](#Top)


## <a name="Anchor_name"></a>Start of next section ##

[Back to top](#Top)

## About this file 

Produced from an R-markdown (Rmd) file ../reports/example.Rmd . 

NOT CURRENTLYPart of an analysis pipeline controlled by 'make' processing this [makefile](../makefile)


[Back to top](#Top)

To compile me, run this in shell:

``` {shell}
cd ~/HanleyGroup/BerryChIPseq_multiTissue
make

```

Information about the R session:-


```r
sessionInfo()
```

```
## R version 3.0.2 (2013-09-25)
## Platform: x86_64-redhat-linux-gnu (64-bit)
## 
## locale:
##  [1] LC_CTYPE=en_GB       LC_NUMERIC=C         LC_TIME=en_GB        LC_COLLATE=en_GB     LC_MONETARY=en_GB    LC_MESSAGES=en_GB    LC_PAPER=en_GB       LC_NAME=C            LC_ADDRESS=C         LC_TELEPHONE=C       LC_MEASUREMENT=en_GB LC_IDENTIFICATION=C 
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
## [1] knitr_1.6    markdown_0.7
## 
## loaded via a namespace (and not attached):
## [1] evaluate_0.5.5 formatR_0.10   stringr_0.6.2  tools_3.0.2
```
