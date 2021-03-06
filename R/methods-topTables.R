# FIXME Add method support for `DESeqResults`
# FIXME Use kables for dynamic return



#' Top Tables of Differential Expression Results
#'
#' @name topTables
#' @family R Markdown Functions
#' @author Michael Steinbaugh
#'
#' @inheritParams general
#'
#' @param object [resultsTables()] return `list`.
#' @param n Number genes to report.
#' @param coding Whether to only return coding genes.
#'
#' @return `kable`.
#'
#' @examples
#' # DESeqResults to list ====
#' resTbl <- resultsTables(
#'     object = res_small,
#'     rowData = rowData(bcb_small),
#'     summary = FALSE,
#'     write = FALSE
#' )
#' topTables(resTbl, n = 5L)
NULL



# Constructors =================================================================
.subsetTop <- function(
    object,
    n = 50L,
    coding = FALSE
) {
    assert_is_data.frame(object)
    assert_has_colnames(object)
    assert_has_rows(object)
    assertIsImplicitInteger(n)
    assert_is_a_bool(coding)
    # Note that `geneName` and `description` columns are optional
    requiredCols <- c("geneID", "baseMean", "log2FoldChange", "padj")
    assert_is_subset(requiredCols, colnames(object))

    if (isTRUE(coding)) {
        assert_is_subset("broadClass", colnames(object))
        object <- object %>%
            .[.[["broadClass"]] == "coding", , drop = FALSE]
    }

    if (!nrow(object)) {
        return(NULL)
    }

    keepCols <- c(requiredCols, c("geneName", "geneBiotype", "description"))
    return <- object %>%
        as_tibble() %>%
        remove_rownames() %>%
        head(n = n) %>%
        mutate(
            baseMean = round(!!sym("baseMean")),
            log2FoldChange = format(!!sym("log2FoldChange"), digits = 3L),
            padj = format(!!sym("padj"), digits = 3L, scientific = TRUE)
        ) %>%
        .[, which(colnames(.) %in% keepCols)]

    # Sanitize the description, if necessary
    if ("description" %in% colnames(return)) {
        # Remove symbol information in description, if present
        return[["description"]] <- gsub(
            pattern = " \\[.+\\]$",
            replacement = "",
            x = return[["description"]]
        )
    }

    return %>%
        # Shorten `log2FoldChange` to `lfc`
        dplyr::rename(lfc = !!sym("log2FoldChange"))
}



# Methods ======================================================================
#' @rdname topTables
#' @export
setMethod(
    "topTables",
    signature("list"),
    function(
        object,
        n = 50L,
        coding = FALSE
    ) {
        # Passthrough: n, coding
        assert_is_list(object)
        assert_is_subset(
            c("all", "deg", "degLFCDown", "degLFCUp"),
            names(object)
        )

        up <- .subsetTop(
            object[["degLFCUp"]],
            n = n,
            coding = coding
        )
        down <- .subsetTop(
            object[["degLFCDown"]],
            n = n,
            coding = coding
        )
        contrast <- object[["contrast"]]
        if (!is.null(up)) {
            show(kable(
                up,
                caption = paste(contrast, "(upregulated)")
            ))
        }
        if (!is.null(down)) {
            show(kable(
                down,
                caption = paste(contrast, "(downregulated)")
            ))
        }
    }
)
