# KANUTE - behaviour testing between softwares and versions   <a name="Top"></a> 

# Example: Kadmon

### Dave T. Gerrard, University of Manchester
### Produced 2014-07-08
[Dave's website](http://personalpages.manchester.ac.uk/staff/David.Gerrard/)


## Table of contents ##
- [Overview](#Overview)
- [Tests directory](#test_dir)
- [Comparing tests example](#Example)


[Back to top](#Top)


# <a name="overview"></a>Overview ##

This is framework and piece of software to support:-
- checking if a specific behaviour of a piece of software is constant between versions.
- checking if the behaviour of one piece of software is identical to the supposed same behaviour in another piece of software.

It is __not__ intended for performance benchmarking or for comparing _real world_ noisy data.

The process has two parts:-

1. A set of unit tests. These can be written in any language but must produce a pre-defined output. Tests and Outputs are organised in a structured testing folder/directory. Users are free to develop individual tests over a long period of time. Reports can then be run on an ad-hoc basis, using all or just a selection of test results.
2. Software to parse the tests, their output and make comparisons between versions and between softwares. The current implementation is in R (see below) but could be ported to any language.



[Back to top](#Top)


# <a name="test_dir"></a>Tests directory ##

The [testing folder](../) will contain the following sub-folders

- [inputs](../inputs/)		a collection of minimal input data, used by tests to produce outputs
- [tests](../tests/)		the individual test scripts, arranged by __software__
- [outputs](../outputs/)	the individual test results, arranged by __software__ then _version_
- [reports](../reports/)	an optional directory containing reports (like this one)    


The software sub-folders within tests/ should contain a file called SOFTWARE.versions listing the version IDs. This is also a good place to list full paths to executable for each version, if so, the file should be tab delimited. Example: [bowtie.versions](../tests/bowtie/bowtie.versions)

The individual test scripts should specify the name of the output file they generate. Currently, the KANUTE package can detect these in bash scripts if they are assigned to the _TEST_OUT_NAME_ variable.



[Back to top](#Top)


# <a name="Example"></a>Comparing tests example ##

Running the tests is kept separate from comparing the results between different versions or software.

The test comparisons have initially been implemented in R and make use of the md5sum program.

## Starting the R session

The user begins by giving the directory where the tests are stored and defining a subset of software names and version that they are interested in. The following workflow is in R 



```r
########### Reading testing results produced earlier (no execution, only comparison).
#
parent_dir <-  paste(Sys.getenv("SCRATCH"),"kanute", sep="/")
testingFolder <- paste(parent_dir, "TestFolder", sep="/")
testDirTop <- paste(testingFolder, "tests",sep="/")
outputsDirTop <- paste(testingFolder, "outputs",sep="/")
source(paste(parent_dir, "scripts/kanute_funcs.R", sep="/"))
#
#
softwares <- c("bowtie", "bowtie2")
```

## Scan for tests in the testing folder
There is a function _scanTestDir()_ to got through the directory and pick out softwares, versions and tests. This produces a list object.


```r
#
testing.list <- scanTestDir(softwares=softwares, testDirTop=testDirTop)
testing.list
```

```
## $bowtie
## $bowtie$outputs
## bowtie_singleRead_1.generic.test.sh bowtie_singleRead_2.generic.test.sh      bowtie_version.generic.test.sh 
##                  "single_read1.sam"                  "single_read2.sam"                       "version.out" 
## 
## $bowtie$versions.info
##       V1                                      V2
## 1 0.12.7 /opt/gridware/apps/bowtie/0.12.7/bowtie
## 2 0.12.8 /opt/gridware/apps/bowtie/0.12.8/bowtie
## 3 0.12.9 /opt/gridware/apps/bowtie/0.12.9/bowtie
## 4  1.0.0  /opt/gridware/apps/bowtie/1.0.0/bowtie
## 5  1.0.1  /opt/gridware/apps/bowtie/1.0.1/bowtie
## 
## 
## $bowtie2
## $bowtie2$outputs
## bowtie2_singleRead_1.generic.test.sh bowtie2_singleRead_2.generic.test.sh      bowtie2_version.generic.test.sh 
##                   "single_read1.sam"                   "single_read2.sam"                        "version.out" 
## 
## $bowtie2$versions.info
##            V1                                             V2
## 1       2.2.3       /opt/gridware/apps/bowtie2/2.2.3/bowtie2
## 2       2.2.2       /opt/gridware/apps/bowtie2/2.2.2/bowtie2
## 3       2.2.1       /opt/gridware/apps/bowtie2/2.2.1/bowtie2
## 4       2.2.0       /opt/gridware/apps/bowtie2/2.2.0/bowtie2
## 5       2.1.0       /opt/gridware/apps/bowtie2/2.1.0/bowtie2
## 6       2.0.5       /opt/gridware/apps/bowtie2/2.0.5/bowtie2
## 7       2.0.2       /opt/gridware/apps/bowtie2/2.0.2/bowtie2
## 8 2.0.0-beta7 /opt/gridware/apps/bowtie2/2.0.0-beta7/bowtie2
## 9 2.0.0-beta6 /opt/gridware/apps/bowtie2/2.0.0-beta6/bowtie2
```

```r
#
```

## Compile md5sums for each test

Using the result of _scanTestDir_ the user can then get md5sum CHECKSUM values for every test with a result file. Again this produces another list.



```r
#
test.library <- compileTestResults(testing.list, outputsDirTop)
#test.library   # don't show this, it's a big hier-archichal list of md5sums
#
#
```

# Compare results across versions

The above list has all the information to check whether any two tests produced the same input, or not. The default behaviour of _compareTests_ is to check for concordance between versions __within__ one piece of software.


```r
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
test.results
```

```
## $bowtie
##                                  test 0.12.7 0.12.8 0.12.9 1.0.0 1.0.1
## 1 bowtie_singleRead_1.generic.test.sh   TRUE   TRUE   TRUE  TRUE  TRUE
## 2 bowtie_singleRead_2.generic.test.sh   TRUE   TRUE   TRUE  TRUE  TRUE
## 3      bowtie_version.generic.test.sh   TRUE  FALSE  FALSE FALSE FALSE
## 
## $bowtie2
##                                   test 2.2.3 2.2.2 2.2.1 2.2.0 2.1.0 2.0.5 2.0.2 2.0.0-beta7 2.0.0-beta6
## 1 bowtie2_singleRead_1.generic.test.sh  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE        TRUE        TRUE
## 2 bowtie2_singleRead_2.generic.test.sh  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE        TRUE        TRUE
## 3      bowtie2_version.generic.test.sh  TRUE FALSE FALSE FALSE FALSE FALSE FALSE       FALSE       FALSE
```

```r
#
```

## Compare results for some tests across softwares

An important feature of KANUTE is to test for differences in results __between__ different softwares. This depends on the user having written tests that produce comparable results. The user must then also provide a table of mappings between specific tests performed on two different softares. Here is an example [file](../tests/test.mappings) 



```r
## created a tab-delim file called test.mappings in top of tests/ folder
## mapping.name software1 software1.testA software2   software2.testA TRUE
## the final column is TRUE if expect results to be the same, FALSE if not or NA if unknown.
## May need to be 1/0 instead of TRUE/FALSE
#
test.mappings <- read.delim(paste(testDirTop, "test.mappings", sep="/"), header=F, stringsAsFactors=F)
names(test.mappings) <- c("mapping.name", "software1", "software1.test", "software2", "software2.test", "expectIdentical")
test.mappings
```

```
##           mapping.name software1                      software1.test software2                       software2.test expectIdentical
## 1 singleRead_1.generic    bowtie bowtie_singleRead_1.generic.test.sh   bowtie2 bowtie2_singleRead_1.generic.test.sh           FALSE
## 2 singleRead_2.generic    bowtie bowtie_singleRead_2.generic.test.sh   bowtie2 bowtie2_singleRead_2.generic.test.sh            TRUE
```

Then, giving this _data.frame_ to _compareTests_ will make a comparison BETWEEN softwares.


```r
test.results <- compareTests(test.library, mapped.tests=test.mappings)
```

```
## [1] "#######KANUTE###########: Comparing tests BETWEEN softwares"
## [1] "2 mapped tests"
```

```r
test.results
```

```
## $MAPPED.TESTS
##           mapping.name software1                      software1.test software2                       software2.test expectIdentical result   ver1  ver2
## 1 singleRead_1.generic    bowtie bowtie_singleRead_1.generic.test.sh   bowtie2 bowtie2_singleRead_1.generic.test.sh           FALSE  FALSE 0.12.7 2.2.3
## 2 singleRead_2.generic    bowtie bowtie_singleRead_2.generic.test.sh   bowtie2 bowtie2_singleRead_2.generic.test.sh            TRUE   TRUE 0.12.7 2.2.3
```

```r
### specify the reference versions to be used in tests BETWEEN software
test.results <- compareTests(test.library, mapped.tests=test.mappings, ref.versions=list(bowtie="1.0.1", bowtie2="2.2.3"))
```

```
## [1] "#######KANUTE###########: Comparing tests BETWEEN softwares"
## [1] "2 mapped tests"
```

```r
test.results
```

```
## $MAPPED.TESTS
##           mapping.name software1                      software1.test software2                       software2.test expectIdentical result  ver1  ver2
## 1 singleRead_1.generic    bowtie bowtie_singleRead_1.generic.test.sh   bowtie2 bowtie2_singleRead_1.generic.test.sh           FALSE  FALSE 1.0.1 2.2.3
## 2 singleRead_2.generic    bowtie bowtie_singleRead_2.generic.test.sh   bowtie2 bowtie2_singleRead_2.generic.test.sh            TRUE   TRUE 1.0.1 2.2.3
```


By default, if mapped.tests parameter given, tests __within__ Software are suppressed. Here's how to turn it back on


```r
# Here's how to turn it back on
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
#What have we got at the end of all that
test.results
```

```
## $bowtie
##                                  test 0.12.7 0.12.8 0.12.9 1.0.0 1.0.1
## 1 bowtie_singleRead_1.generic.test.sh   TRUE   TRUE   TRUE  TRUE  TRUE
## 2 bowtie_singleRead_2.generic.test.sh   TRUE   TRUE   TRUE  TRUE  TRUE
## 3      bowtie_version.generic.test.sh   TRUE  FALSE  FALSE FALSE FALSE
## 
## $bowtie2
##                                   test 2.2.3 2.2.2 2.2.1 2.2.0 2.1.0 2.0.5 2.0.2 2.0.0-beta7 2.0.0-beta6
## 1 bowtie2_singleRead_1.generic.test.sh  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE        TRUE        TRUE
## 2 bowtie2_singleRead_2.generic.test.sh  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE        TRUE        TRUE
## 3      bowtie2_version.generic.test.sh  TRUE FALSE FALSE FALSE FALSE FALSE FALSE       FALSE       FALSE
## 
## $MAPPED.TESTS
##           mapping.name software1                      software1.test software2                       software2.test expectIdentical result   ver1  ver2
## 1 singleRead_1.generic    bowtie bowtie_singleRead_1.generic.test.sh   bowtie2 bowtie2_singleRead_1.generic.test.sh           FALSE  FALSE 0.12.7 2.2.3
## 2 singleRead_2.generic    bowtie bowtie_singleRead_2.generic.test.sh   bowtie2 bowtie2_singleRead_2.generic.test.sh            TRUE   TRUE 0.12.7 2.2.3
```

## <a name="todo"></a>TO DO ##

- Build in more tests for more software
- Visualisation of results (Coloured grid, use Shiny)
- Run/update tests from within R session
- Allow for non-generic tests.
- Tests between installations or compare against an archive (may need extra structure or second testingFolder).

[Back to top](#Top)

## 


[Back to top](#Top)


## <a name="Anchor_name"></a>Start of next section ##

[Back to top](#Top)

## About this file 

Produced from an R-markdown (Rmd) file ../reports/example.Rmd . 


[Back to top](#Top)




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
