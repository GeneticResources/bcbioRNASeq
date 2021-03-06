% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/methods-plotMeanSD.R
\docType{methods}
\name{plotMeanSD}
\alias{plotMeanSD}
\alias{plotMeanSD}
\alias{plotMeanSD,bcbioRNASeq-method}
\alias{plotMeanSD,DESeqDataSet-method}
\title{Plot Row Standard Deviations vs. Row Means}
\usage{
plotMeanSD(object, ...)

\S4method{plotMeanSD}{bcbioRNASeq}(object, orientation = c("vertical",
  "horizontal"), legend = FALSE)

\S4method{plotMeanSD}{DESeqDataSet}(object, orientation = c("vertical",
  "horizontal"), legend = FALSE)
}
\arguments{
\item{object}{Object.}

\item{...}{Additional arguments.}

\item{orientation}{Orientation to use for plot grid, either \code{horizontal} or
\code{vertical}.}

\item{legend}{Include the color bar legend. This is typically not that
informative and is disabled by default, to improve the plot appearance.}
}
\value{
\code{ggplot} grid.
}
\description{
\code{\link[vsn:meanSdPlot]{vsn::meanSdPlot()}} wrapper that plots \code{\link[=log2]{log2()}}, \code{\link[=rlog]{rlog()}}, and
\code{\link[=varianceStabilizingTransformation]{varianceStabilizingTransformation()}} normalized counts.
}
\examples{
# bcbioRNASeq ====
plotMeanSD(bcb_small)

# DESeqDataSet ====
plotMeanSD(dds_small)
}
\seealso{
Other Quality Control Functions: \code{\link{plot5Prime3PrimeBias}},
  \code{\link{plotCorrelationHeatmap}},
  \code{\link{plotCountDensity}},
  \code{\link{plotCountsPerGene}},
  \code{\link{plotDispEsts}},
  \code{\link{plotExonicMappingRate}},
  \code{\link{plotGenderMarkers}},
  \code{\link{plotGeneSaturation}},
  \code{\link{plotGenesDetected}},
  \code{\link{plotIntronicMappingRate}},
  \code{\link{plotMappedReads}},
  \code{\link{plotMappingRate}},
  \code{\link{plotPCACovariates}}, \code{\link{plotPCA}},
  \code{\link{plotRRNAMappingRate}},
  \code{\link{plotTotalReads}}
}
\author{
Michael Steinbaugh, Lorena Patano
}
