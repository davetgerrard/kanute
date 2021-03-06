% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/scanTestDir.R
\name{scanTestDir}
\alias{scanTestDir}
\title{scanTestDir}
\usage{
scanTestDir(softwares, testDirTop)
}
\arguments{
\item{softwares}{vector of softwares to include}

\item{testDirTop}{location of testDir}
}
\value{
a list of results.
}
\description{
scanTestDir for tests
}
\details{
Scans the testdir for tests. Runs \code{\link{findTestOutputs}} on each software sub-folder of tests
}

