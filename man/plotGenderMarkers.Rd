% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/methods-plotGenderMarkers.R
\docType{methods}
\name{plotGenderMarkers}
\alias{plotGenderMarkers}
\alias{plotGenderMarkers}
\alias{plotGenderMarkers,bcbioRNASeq-method}
\alias{plotGenderMarkers,DESeqDataSet-method}
\alias{plotGenderMarkers,DESeqTransform-method}
\title{Plot Sexually Dimorphic Gender Markers}
\usage{
plotGenderMarkers(object, ...)

\S4method{plotGenderMarkers}{bcbioRNASeq}(object, interestingGroups,
  normalized = c("rlog", "vst", "tpm"), color = scale_color_viridis(discrete
  = TRUE), title = TRUE)

\S4method{plotGenderMarkers}{DESeqDataSet}(object,
  interestingGroups = "sampleName", organism,
  color = scale_color_viridis(discrete = TRUE), title = TRUE)

\S4method{plotGenderMarkers}{DESeqTransform}(object,
  interestingGroups = "sampleName", organism,
  color = scale_color_viridis(discrete = TRUE), title = TRUE)
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

\item{color}{Desired ggplot color scale. Must supply discrete values. When
set to \code{NULL}, the default ggplot2 color palette will be used. If manual
color definitions are desired, we recommend using
\code{\link[ggplot2:scale_color_manual]{ggplot2::scale_color_manual()}}.}

\item{title}{Title of plot.}

\item{organism}{Organism name. Typically can be left unset and should be
detected automatically, unless a spike-in FASTA sequence is provided
containing a gene identifier that is first alphabetically in the count
matrix rownames.}
}
\value{
\code{ggplot}.
}
\description{
Plot Sexually Dimorphic Gender Markers
}
\examples{
# bcbioRNASeq ====
plotGenderMarkers(bcb_small)

# DESeqDataSet ====
plotGenderMarkers(dds_small)

# DESeqTransform ====
plotGenderMarkers(rld_small)
}
\seealso{
Other Quality Control Functions: \code{\link{plot5Prime3PrimeBias}},
  \code{\link{plotCorrelationHeatmap}},
  \code{\link{plotCountDensity}},
  \code{\link{plotCountsPerGene}},
  \code{\link{plotDispEsts}},
  \code{\link{plotExonicMappingRate}},
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
Michael Steinbaugh
}
