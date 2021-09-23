## General background on RNA Data

Transcriptome profiling of a cell, tissue, or tumor is a powerful and universal phenotyping tool in both research and clinical settings.  When a mutation or epigenetic aberration exerts its biological effects, the affected cells and tissues typically display multiple quantitative and qualitative changes in gene expression, often in coherent pathways and structures.  While pioneering studies used microarray-based methods to profile the transcriptome, the main contemporary method for genome-wide profiling of gene expression is RNA-seq, which is based on DNA sequencing of cDNA made from RNA.

Gene expression output in the form of quantifications needs to cover several forms.  The most basic is aggregate gene quantification but it is also very important to support transcript level quantification.  This can be further broken down into the exon level as well as splice junction quantification.  Additionally, it is very common for an investigator to want to look at differential comparisons between multiple related RNA quantifications.  For bulk RNA it is not uncommon to just download the full quantification results for the set of comparable experiments for later comparison.  In the single cell RNA-seq world each cell is an experiment so to do the same will result in potentially millions of files.  This will be a significant challenge to both download and manage on the client end. 

## Target Users

We aim to build this infrastructure to be useful for three distinct groups of users of the data servers which implement the API.
1.	Research data scientists who integrate new and/or existing datasets to derive new hypotheses and experimental paradigms
2.	Methodologists who are developing new analytical methods in this API for RNA-seq analysis – including quantification, differential expression, dimension reduction and clustering modules.
3.	Data aggregators and portal developers who are creating computational solutions to collecting and analyzing large scale (multi-million+ samples) datasets

## Use Case Overview

The collected use cases are organized into several categories.  Two of these are query based and influence the data to be returned via the API.  These will generally be called early in a downstream analysis pipeline to focus on relevant input datasets.

### Metadata-based Searches

Metadata-based searches filter the search query on one or more of the annotated metadata items associated with the samples.  These include:

* Cell type
* Condition
* Gene or set of genes

### Data-based Searches

A set of use cases require data-based searches.  These are characterized by attempting to filter the response based on similarity to user supplied expression data.  This expression profile to match may be either for one of more cells or for a set of specified genes.  A key feature of these data-based queries is that expression data in the form of a vector or similar construct needs to be provided as an argument to the query.

* Match to input cell expression values
* Match profile and filter by metadata

### Matrix Manipulation

A set of use cases describe manipulation of the expression matrix.  This supports operations on subsets of the original matrix for remote processing either serially or in parallel.  It is important to note that these use cases are designed around slices of a matrix and not filters on the contents of the matrix.

* Slice along columns and/or rows
* Support out of core compute
* Stream chunks of the matrix
