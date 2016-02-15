#! /usr/bin/Rscript

########## Hierarchical clustering ##########

#' Generate vectors containing needed variables
#'
#' ct: contains Ct values (column 4)
#' genes: contains gene names (unique occurences)
#' samples: contains sample names (unique occurences)
#'
#' @example 96.96 experiment (96 samples, 96 genes)

ct <- taq_data[, 4]

genes <- unique(taq_data[, 2])

samples <- unique(taq_data[, 1])


#' Generate matrix
#' In this example, the clustering is made on the samples. If you want to look at the genes, you need to revert this matrix using t(mat_clust), or invert the order of the vectors in dimnames
#'
#' @param ct: values to be added to the matrix
#' @param nrow: specifies the number of rows (should be equal to the length of the vector "samples". To get this number, length(samples))
#' @param ncol: specifies the number of columns (should be equal to the length of the vector "genes". To get this number, length(genes))
#' @param dimnames: list containing names to be given to rows and columns. First item is for rows, and second item is for columns
#'
#' @ example

mat_clust <- matrix(ct, nrow = 96, ncol = 96, dimnames = list(samples, genes))


#' Calculate median of the Ct values per gene
#'
#' @param mat_clust: matrix to be processed
#' @param 2: apply function by column
#' @param median: calculates median
#'
#' @ example

medians <- apply(mat_clust, 2, median)


#' Calculate mean average deviation of the Ct values per gene
#'
#' @param mat_clust: matrix to be processed
#' @param 2: apply function by column
#' @param mad: calculates mean average deviation
#'
#' @ example

mads <- apply(mat_clust, 2, mad)


#' Center each column using scale() function
#' Each column has its median substracted from its valus and divided by its mean average deviation
#'
#' @param mat_clust: matrix to be processed
#' @param center: specifies the value to center the data (substraction)
#' @param scale: speficies the value to scale the data (division)
#'
#' @ example

data.use <- scale(mat_clust, center = medians, scale = mads)


#' Generate the distance matrix
#'
#' All about dist() function [here](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/dist.html)
#'
#' @param data.use: normalized data
#' @param method: distance method to use
#'
#' @example

data.dist <- dist(data.use, method = "euclidian")


#' Generate cluster solution
#'
#' All about hclust() function [here](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/hclust.html)
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
#'
#' @example

plot(data.hclust, labels = samples, xlab = "", main = "Dendrogram")
