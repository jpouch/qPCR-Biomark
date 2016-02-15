#! /usr/bin/Rscript

### Data normalization (Livak's method) ###

######################################## Reference ########################################
# "Analysis of relative gene expression data using real-time PCR and the 2^-∆∆Ct method"  #
#		Kenneth J. Livak and Thomas D. Schmittgen	                #
#			Methods, 25, 402-408 (2001)			          	#
#	http://www.gene-quantification.net/livak-2001.pdf	              #
###########################################################################################

#' Function to normalize qPCR data to one reference gene
#'
#' definition of the function
#' @param df: stands for data frame
#' @param s1: column containing sample names, usually [1] when open_data.R has been followed
#' @param ct1: column containing Ct values, usually [4] when open_data.R has been followed
#' @param row: defines a subset data for the reference used (put your reference gene name in the quotes. Caution: R is case sensitive)
#' @param ctRef: isolates Ct values for the reference
#' @param ct1: all other Ct values in the data
#' @param delta: calculates the difference between the Ct of the target and the Ct of the reference gene
#' @param res: calculates ratio corresponding to the normalized values (see Livak's article)
#'
#' @example
#' apply function to each row of the data frame
#' @param taq_data: data frame to be processed
#' @param 1: apply the function to each row
#' @param function(row) norma_livak: calls the function you want to apply
#' @param row[1]: refers to the first column containing the sample names
#' @param row[4]: refers to the fourth column containing the ct values

norma_livak <- function(df, s1, ct1){
  row <- df[df$geneID=="yourReferenceGene" & df$sampleID==s1,]
  ctRef <- row$ct
    
  ct1 <- as.numeric(ct1)
  delta <- ct1 - ctRef
  res <- 2^-delta 
}

taq_data$livak <- apply(taq_data, 1, function(row) norma_livak(taq_data, row[1], row[4]))


#' Function to normalize qPCR data to a set of several reference genes
#'
#'
#' If you have several reference genes, you can normalize your data to the geometric mean of the genes.
#' Reference: "Accurate normalization of real-time quantitative RT-PCR data by geometric averaging of multiple internal control genes"
#' Vandesompele J. et al - Genome Biology 2002, 3(7)
#'
#' definition of the function
#' @param df: stands for data frame
#' @param s1: column containing sample names, usually [1] when open_data.R has been followed
#' @param ct1: column containing Ct values, usually [4] when open_data.R has been followed
#' @param row: defines a subset data for the references used
#' @param ctRef: calculates the geometric mean of the Ct values for the reference genes
#' @param ct1: all other Ct values in the data
#' @param delta: calculates the difference between the Ct of the target and the geometric mean of the reference genes
#' @param res: calculates ratio corresponding to the normalized values (see Livak's article)
#'
#' @example
#' apply function to each row of the data frame
#' @param taq_data: data frame to be processed
#' @param 1: apply the function to each row
#' @param function(row) norma_livak: calls the function you want to apply
#' @param row[1]: refers to the first column containing the sample names
#' @param row[4]: refers to the fourth column containing the ct values

norma_livak_geom <- function(df, s1, ct1){
  row <- df[df$reference=="Reference" & df$sampleID==s1,]
  geomRef <- geometric.mean(row$ct)
    
  ct1 <- as.numeric(ct1)
  delta <- ct1 - geomRef
  res <- 2^-delta 
}

taq_data$livak_geom <- apply(taq_data, 1, function(row) norma_livak_geom(taq_data, row[1], row[4]))


#' NOTE: if no Reference status was assigned in Detector setup, you can create a vector containing all your reference genes
#' @example reference_genes <- c("gene1", "gene2", "gene3", ...)
#' and call it in row using %in%
#' row <- df[df$geneID %in% reference_genes & df$sampleID==s1,]
