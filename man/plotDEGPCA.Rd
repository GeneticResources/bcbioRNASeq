% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/methods-plotDEGPCA.R
\docType{methods}
\name{plotDEGPCA}
\alias{plotDEGPCA}
\alias{plotDEGPCA}
\alias{plotDEGPCA,DESeqResults-method}
\title{Plot DEG PCA}
\usage{
plotDEGPCA(object, ...)

\S4method{plotDEGPCA}{DESeqResults}(object, counts,
  interestingGroups = "sampleName", lfc = 0L,
  color = scale_color_viridis(discrete = TRUE), label = FALSE,
  title = "deg pca", return = c("ggplot", "data.frame"))
}
\arguments{
\item{object}{Object.}

\item{...}{Additional arguments.}

\item{counts}{Object containing a normalized counts matrix.}

\item{interestingGroups}{Character vector denoting groups of interest that
define the samples. If left unset, defaults to \code{sampleName}.}

\item{lfc}{Log fold change ratio (base 2) cutoff.}

\item{color}{Desired ggplot color scale. Must supply discrete values. When
set to \code{NULL}, the default ggplot2 color palette will be used. If manual
color definitions are desired, we recommend using
\code{\link[ggplot2:scale_color_manual]{ggplot2::scale_color_manual()}}.}

\item{label}{Superimpose sample text labels on the plot.}

\item{title}{Title of plot.}

\item{return}{Object class to return. Uses \code{\link[=match.arg]{match.arg()}} internally and picks
the first item in the vector by default.}
}
\value{
\code{ggplot} or \code{data.frame}.
}
\description{
Plot DEG PCA
}
\examples{
# DESeqResults, DESeqTransform ====
plotDEGPCA(
    object = res_small,
    counts = rld_small,
    interestingGroups = interestingGroups(bcb_small),
    label = TRUE
)
}
\seealso{
Other Differential Expression Functions: \code{\link{alphaSummary}},
  \code{\link{contrastName}}, \code{\link{plotDEGHeatmap}},
  \code{\link{plotMA}}, \code{\link{plotVolcano}},
  \code{\link{resultsTables}}
}
\author{
Michael Steinbaugh
}
