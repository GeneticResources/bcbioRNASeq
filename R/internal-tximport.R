#' Import RNA-Seq Counts
#'
#' Import RNA-seq counts using
#' [tximport](https://doi.org/doi:10.18129/B9.bioc.tximport).
#'
#' Normalized counts are loaded as length-scaled transcripts per million.
#' Consult this [vignette](https://goo.gl/h6fm15) for more information.
#'
#' @author Michael Steinbaugh, Rory Kirchner
#' @keywords internal
#' @noRd
#'
#' @inheritParams tximport::tximport
#' @param sampleDirs Sample directories to import.
#' @param type *Optional.* Manually specify the expression caller to use.
#'   If `NULL`, if defaults to our preferred priority.
#'
#' @seealso [tximport::tximport()].
#'
#' @return `list` containing count matrices.
.tximport <- function(
    sampleDirs,
    type = c("salmon", "kallisto", "sailfish"),
    txIn = TRUE,
    txOut = FALSE,
    tx2gene
) {
    assert_all_are_dirs(sampleDirs)
    type <- match.arg(type)
    assert_is_a_bool(txIn)
    assert_is_a_bool(txOut)
    assertIsTx2gene(tx2gene)

    # Check for count output format, by using the first sample directory
    subdirs <- list.dirs(
        path = sampleDirs[[1L]],
        full.names = TRUE,
        recursive = FALSE
    )
    assert_are_intersecting_sets(basename(subdirs), validCallers)

    # Locate `quant.sf` files for salmon or sailfish output
    if (type %in% c("salmon", "sailfish")) {
        files <- list.files(
            path = file.path(sampleDirs, type),
            pattern = "quant.sf",
            full.names = TRUE,
            recursive = TRUE
        )
    } else if (type == "kallisto") {
        files <- list.files(
            path = file.path(sampleDirs, type),
            pattern = "abundance.h5",
            full.names = TRUE,
            recursive = TRUE
        )
    }
    assert_all_are_existing_files(files)
    names(files) <- names(sampleDirs)

    # Begin loading of selected counts
    inform(paste("Reading", type, "counts using tximport"))

    tximport(
        files = files,
        type = type,
        txIn = txIn,
        txOut = txOut,
        countsFromAbundance = "lengthScaledTPM",
        tx2gene = as.data.frame(tx2gene),
        ignoreTxVersion = FALSE,
        importer = read_tsv
    )
}



.regenerateTximportList <- function(object) {
    assert_is_any_of(
        x = object,
        classes = c("bcbioRNASeq", "RangedSummarizedExperiment")
    )
    assert_is_subset(c("tpm", "raw", "length"), names(assays(object)))
    assert_is_subset("countsFromAbundance", names(metadata(object)))
    list(
        "abundance" = assays(object)[["tpm"]],
        "counts" = assays(object)[["raw"]],
        "length" = assays(object)[["length"]],
        "countsFromAbundance" = metadata(object)[["countsFromAbundance"]]
    )
}
