% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/methods-plotCountDensity.R
\docType{methods}
\name{plotCountDensity}
\alias{plotCountDensity}
\alias{plotCountDensity}
\alias{plotCountDensity,bcbioRNASeq-method}
\title{Plot Count Density}
\usage{
plotCountDensity(object, ...)

\S4method{plotCountDensity}{bcbioRNASeq}(object, interestingGroups,
  normalized = c("tmm", "rlog", "vst", "tpm"), style = c("line", "solid"),
  color = scale_color_viridis(discrete = TRUE),
  fill = scale_fill_viridis(discrete = TRUE), title = "count density")
}
\arguments{
\item{object}{Object.}

\item{...}{Additional arguments.}

\item{interestingGroups}{Character vector denoting groups of interest that
define the samples. If left unset, defaults to \code{sampleName}.}

\item{normalized}{Character indicating which normalization method to apply:
\itemize{
\item "\code{tpm}": Transcripts per million (tximport).
\item "\code{tmm}": edgeR trimmed mean of M-values. Calculated on the fly.
\item "\code{rlog}": DESeq2 \strong{log2} regularized log transformation.
\item "\code{vst}": DESeq2 \strong{log2} variance stabilizing transformation.
}}

\item{style}{Desired plot style ("\code{line}" or "\code{solid}").}

\item{color}{Desired ggplot color scale. Must supply discrete values. When
set to \code{NULL}, the default ggplot2 color palette will be used. If manual
color definitions are desired, we recommend using
\code{\link[ggplot2:scale_color_manual]{ggplot2::scale_color_manual()}}.}

\item{fill}{Desired ggplot fill scale. Must supply discrete values. When set
to \code{NULL}, the default ggplot2 color palette will be used. If manual color
definitions are desired, we recommend using \code{\link[ggplot2:scale_fill_manual]{ggplot2::scale_fill_manual()}}.}

\item{title}{Title of plot.}
}
\value{
\code{ggplot}.
}
\description{
Plot Count Density
}
\examples{
# bcbioRNASeq ====
plotCountDensity(bcb_small)
plotCountDensity(
    object = bcb_small,
    style = "line",
    interestingGroups = "sampleName"
)
}
\seealso{
Other Quality Control Functions: \code{\link{plot5Prime3PrimeBias}},
  \code{\link{plotCorrelationHeatmap}},
  \code{\link{plotCountsPerGene}},
  \code{\link{plotDispEsts}},
  \code{\link{plotExonicMappingRate}},
  \code{\link{plotGenderMarkers}},
  \code{\link{plotGeneSaturation}},
  \code{\link{plotGenesDetected}},
  \code{\link{plotIntronicMappingRate}},
  \code{\link{plotMappedReads}},
  \code{\link{plotMappingRate}}, \code{\link{plotMeanSD}},
  \code{\link{plotPCACovariates}}, \code{\link{plotPCA}},
  \code{\link{plotRRNAMappingRate}},
  \code{\link{plotTotalReads}}
}
\author{
Michael Steinbaugh, Rory Kirchner, Victor Barrera
}
