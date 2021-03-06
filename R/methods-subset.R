#' Bracket-Based Subsetting
#'
#' Extract genes by row and samples by column from a `bcbioRNASeq` object. The
#' internal `DESeqDataSet` and count transformations are rescaled automatically.
#' DESeq2 transformations can be disabled on large subset operations by setting
#' `transform = FALSE`.
#'
#' @name subset
#' @family S4 Class Definition
#' @author Lorena Pantano, Michael Steinbaugh
#'
#' @inheritParams base::`[`
#' @inheritParams general
#'
#' @return `bcbioRNASeq`.
#'
#' @seealso `help("[", "base")`.
#'
#' @examples
#' # Minimum of 100 genes, 2 samples
#' genes <- head(rownames(bcb_small), 100L)
#' head(genes)
#' samples <- head(colnames(bcb_small), 2L)
#' head(samples)
#'
#' # Subset by sample name
#' bcb_small[, samples]
#'
#' # Subset by gene list
#' bcb_small[genes, ]
#'
#' # Subset by both genes and samples
#' subset <- bcb_small[genes, samples]
#' print(subset)
#' assayNames(subset)
#'
#' # Skip DESeq2 variance stabilizing transformations
#' subset <- bcb_small[genes, samples, transform = FALSE]
#' print(subset)
#' assayNames(subset)
NULL



# Methods ======================================================================
#' @rdname subset
#' @export
setMethod(
    "[",
    signature(
        x = "bcbioRNASeq",
        i = "ANY",
        j = "ANY",
        drop = "ANY"
    ),
    function(x, i, j, ..., drop = FALSE) {
        validObject(x)

        dots <- list(...)
        if (!identical(dots[["transform"]], FALSE)) {
            transform <- TRUE
        }

        # Genes (rows)
        if (missing(i)) {
            i <- 1L:nrow(x)
        }
        # Require at least 100 genes
        assert_all_are_in_left_open_range(length(i), lower = 99L)

        # Samples (columns)
        if (missing(j)) {
            j <- 1L:ncol(x)
        }
        # Require at least 2 samples
        assert_all_are_in_left_open_range(length(j), lower = 1L)


        # Early return if dimensions are unmodified
        if (identical(dim(x), c(length(i), length(j)))) {
            return(x)
        }

        # Regenerate RangedSummarizedExperiment
        rse <- as(x, "RangedSummarizedExperiment")
        rse <- rse[i, j, drop = drop]

        # Assays ===============================================================
        assays <- assays(rse)
        if (isTRUE(transform)) {
            inform(paste(
                "Calculating variance stabilizations using DESeq2",
                packageVersion("DESeq2")
            ))
            txi <- .regenerateTximportList(rse)
            dds <- DESeqDataSetFromTximport(
                txi = txi,
                colData = colData(rse),
                # Use an empty design formula
                design = ~ 1  # nolint
            )
            # Suppress warning about empty design formula
            dds <- suppressWarnings(DESeq(dds))
            validObject(dds)
            inform("Applying rlog transformation")
            assays[["rlog"]] <- assay(rlog(dds))
            inform("Applying variance stabilizing transformation")
            assays[["vst"]] <- assay(varianceStabilizingTransformation(dds))
        } else {
            inform("Skipping DESeq2 transformations")
            # Ensure existing transformations get dropped
            assays[["vst"]] <- NULL
            assays[["rlog"]] <- NULL
        }

        # Metadata =============================================================
        metadata <- metadata(rse)
        metadata[["subset"]] <- TRUE
        # Update version, if necessary
        if (!identical(metadata[["version"]], packageVersion)) {
            metadata[["originalVersion"]] <- metadata[["version"]]
            metadata[["version"]] <- packageVersion
        }
        # Metrics
        metadata[["metrics"]] <- metadata[["metrics"]] %>%
            .[colnames(rse), , drop = FALSE] %>%
            rownames_to_column() %>%
            mutate_if(is.character, as.factor) %>%
            mutate_if(is.factor, droplevels) %>%
            column_to_rownames()

        # Return ===============================================================
        .new.bcbioRNASeq(
            assays = assays,
            rowRanges = rowRanges(rse),
            colData = colData(rse),
            metadata = metadata,
            isSpike = metadata[["isSpike"]]
        )
    }
)
