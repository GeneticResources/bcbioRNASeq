context("S4 Class Definition")

bcb <- suppressWarnings(loadRNASeq(
    uploadDir,
    ensemblRelease = 87L,
    organism = "Mus musculus"
))
validObject(bcb)



# bcbioRNASeq S4 Object ========================================================
test_that("Slots", {
    expect_identical(
        slotNames(bcb),
        c(
            "rowRanges",
            "colData",
            "assays",
            "NAMES",
            "elementMetadata",
            "metadata"
        )
    )
    expect_identical(
        lapply(seq_along(slotNames(bcb)), function(a) {
            class(slot(bcb, slotNames(bcb)[[a]]))
        }),
        list(
            structure(
                "GRanges",
                package = "GenomicRanges"
            ),
            structure(
                "DataFrame",
                package = "S4Vectors"
            ),
            structure(
                "ShallowSimpleListAssays",
                package = "SummarizedExperiment"
            ),
            "NULL",  # character for SummarizedExperiment
            structure(
                "DataFrame",
                package = "S4Vectors"
            ),
            "list"
        )
    )
})

test_that("Assays", {
    # All assays should be a matrix
    expect_true(all(vapply(
        X = assays(bcb),
        FUN = function(assay) {
            is.matrix(assay)
        },
        FUN.VALUE = logical(1L)
    )))
})

test_that("Column data", {
    # All columns should be factor5
    expect_true(all(vapply(
        X = colData(bcb),
        FUN = function(assay) {
            is.factor(assay)
        },
        FUN.VALUE = logical(1L)
    )))
})

test_that("Row data", {
    # Ensembl annotations from AnnotationHub, using ensembldb
    expect_identical(
        lapply(rowData(bcb), class),
        list(
            "geneID" = "character",
            "geneName" = "character",
            "geneBiotype" = "factor",
            "description" = "character",
            "seqCoordSystem" = "factor",
            "entrezID" = "list",
            "broadClass" = "factor"
        )
    )
})

test_that("Metadata", {
    tibble <- c("tbl_df", "tbl", "data.frame")
    expect_identical(
        lapply(metadata(bcb), class),
        list(
            "version" = c("package_version", "numeric_version"),
            "level" = "character",
            "caller" = "character",
            "countsFromAbundance" = "character",
            "uploadDir" = "character",
            "sampleDirs" = "character",
            "sampleMetadataFile" = "character",
            "projectDir" = "character",
            "template" = "character",
            "runDate" = "Date",
            "interestingGroups" = "character",
            "organism" = "character",
            "genomeBuild" = "character",
            "ensemblRelease" = "integer",
            "rowRangesMetadata" = tibble,
            "gffFile" = "character",
            "tx2gene" = "data.frame",
            "lanes" = "integer",
            "yaml" = "list",
            "metrics" = "data.frame",
            "dataVersions" = tibble,
            "programVersions" = tibble,
            "bcbioLog" = "character",
            "bcbioCommandsLog" = "character",
            "allSamples" = "logical",
            "loadRNASeq" = "call",
            "date" = "Date",
            "wd" = "character",
            "utilsSessionInfo" = "sessionInfo",
            "devtoolsSessionInfo" = "session_info",
            "isSpike" = "character",
            "unannotatedRows" = "character"
        )
    )
    # Interesting groups should default to `sampleName`
    expect_identical(
        metadata(bcb)[["interestingGroups"]],
        "sampleName"
    )
})

test_that("Example data dimensions", {
    expect_identical(
        dim(bcb),
        c(503L, 4L)
    )
    expect_identical(
        colnames(bcb),
        c("group1_1", "group1_2", "group2_1", "group2_2")
    )
    expect_identical(
        rownames(bcb)[1L:4L],
        c(
            "ENSMUSG00000002459",
            "ENSMUSG00000004768",
            "ENSMUSG00000005886",
            "ENSMUSG00000016918"
        )
    )
})



# subset =======================================================================
test_that("subset : Normal gene and sample selection", {
    x <- bcb_small[seq_len(100L), seq_len(4L)]
    expect_s4_class(x, "bcbioRNASeq")
    expect_identical(
        dim(x),
        c(100L, 4L)
    )
    expect_identical(
        rownames(x)[[1L]],
        rownames(bcb_small)[[1L]]
    )
    expect_identical(
        colnames(x),
        head(colnames(bcb_small), 4L)
    )
    expect_identical(
        names(assays(x)),
        c("raw", "tpm", "length", "rlog", "vst")
    )
})

test_that("subset : Skip DESeq2 transforms", {
    x <- bcb_small[seq_len(100L), seq_len(4L), transform = FALSE]
    expect_identical(
        names(assays(x)),
        c("raw", "tpm", "length")
    )
})

test_that("subset : Minimal selection ranges", {
    # Require at least 100 genes, 2 samples
    x <- bcb_small[seq_len(100L), seq_len(2L)]
    expect_error(
        bcb_small[seq_len(99L), ],
        "is_in_left_open_range : length\\(i\\)"
    )
    expect_error(
        bcb_small[, seq_len(1L)],
        "is_in_left_open_range : length\\(j\\)"
    )
    expect_identical(
        dimnames(x),
        list(
            head(rownames(bcb_small), 100L),
            head(colnames(bcb_small), 2L)
        )
    )
})



# updateObject =================================================================
test_that("updateObject", {
    invalid <- bcb_small
    metadata(invalid)[["version"]] <- package_version("0.1.7")
    expect_error(
        validObject(invalid),
        "metadata\\(object\\)\\[\\[\"version\"\\]\\] >= 0.2 is not TRUE"
    )
    organism <- metadata(invalid)[["organism"]]
    rowRanges <- makeGRangesFromEnsembl(organism)
    valid <- suppressWarnings(updateObject(invalid, rowRanges = rowRanges))
    expect_identical(
        metadata(valid)[["version"]],
        packageVersion
    )
    expect_identical(
        metadata(valid)[["previousVersion"]],
        package_version("0.1.7")
    )
})
