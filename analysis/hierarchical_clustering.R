#! /usr/bin/Rscript



########## Hierarchical clustering ##########

#' Generate vectors containing needed variables
#'
#' norm_val: contains normalized values (column 9 or other depending on the normalization step)
#' geneID: contains gene names (unique occurences)
#' samples: contains sample names (unique occurences)
#'
#' @example 96.96 experiment (96 samples, 96 genes)

norm_val <- taq_data[, 9]

geneID <- unique(taq_data$geneID)

samples <- taq_data[1:96, 2]


#' Generate matrix
#' In this example, the clustering is made on the samples.
#' If you want to look at the genes, you need to revert this matrix using t(mat_clust)
#'
#' @param norm_val: values to be added to the matrix
#' @param nrow: specifies the number of rows (should be equal to the length of the vector "samples". To get this number, length(samples))
#' @param ncol: specifies the number of columns (should be equal to the length of the vector "geneID". To get this number, length(geneID))
#' @param dimnames: list containing names to be given to rows and columns. First item is for rows, and second item is for columns
#'
#' @ example

mat_clust <- matrix(norm_val, nrow = 96, ncol = 96, dimnames = list(samples, geneID))



#' Generate the distance matrix
#'
#' @param data.use: normalized data
#' @param method: distance method to use
#'
#' @example

data.dist <- dist(mat_clust, method = "euclidian")


#' Generate cluster solution
#'
#' @param data.dist: distance matrix
#' @param method: agglomeration method to use ("complete", "average", "mcquitty", ...)
#'
#' @example

data.hclust <- hclust(data.dist, method = "complete")


#' Plot the cluster
#'
#' @param data.hclust: cluster to be displayed
#' @param labels: specifies the vector containing names of the clustered variable (i. e. samples)
#' @param xlab: abscissa legend
#' @param main: plot title
#' @param hang: align labels
#'
#' @example

plot(data.hclust, labels = samples, xlab = "", main = "Dendrogram", hang = -1)




## J. Pouch ## 2020 ##
