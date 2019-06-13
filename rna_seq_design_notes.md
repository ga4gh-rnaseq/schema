# Target Users

We aim to build this infrastructure to be useful for three distinct groups of users of the data servers which implement the API.
1.	Research data scientists who integrate new and/or existing datasets to derive new hypotheses and experimental paradigms
2.	Methodologists who are developing new analytical methods in this API for RNA-seq analysis – including quantification, differential expression, dimension reduction and clustering modules.
3.	Data aggregators and portal developers who are creating computational solutions to collecting and analyzing large scale (multi-million+ samples) datasets

# Use Case Overview

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
