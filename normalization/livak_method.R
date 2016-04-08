#! /usr/bin/Rscript

### Data normalization (Livak's method) ###

######################################## Reference ########################################
# "Analysis of relative gene expression data using real-time PCR and the 2^-∆∆Ct method"
#		Kenneth J. Livak and Thomas D. Schmittgen
#	  		Methods, 25, 402-408 (2001)
#	http://www.gene-quantification.net/livak-2001.pdf
###########################################################################################

#' Function to normalize qPCR data to a reference sample and a reference gene
#'
#' definition of the function to calculate the delta Ct between target gene and reference gene
#' @param df: stands for data frame
#' @param s1: column containing sample names, usually [1] when open_data.R has been followed
#' @param ct1: column containing Ct values, usually [6] when open_data.R has been followed
#' @param geneRef: defines a subset data for the reference used (put your reference gene name in the quotes. Caution: R is case sensitive)
#' @param ctRef: isolates Ct values for the reference gene
#' @param ct1: all other Ct values in the data (numeric type forced)
#' @param delta1: calculates the difference between the Ct of the target and the Ct of the reference gene
#'
#' @example
#' 
#' apply function to each row of the data frame and create new column to store the result
#' @param taq_data: data frame to be processed
#' @param 1: apply the function to each row
#' @param function(row) norma_livak: calls the function you want to apply
#' @param row[1]: refers to the first column containing the sample names
#' @param row[6]: refers to the fourth column containing the ct values
#' 
#' @example 

delta1_livak <- function(df, s1, ct1){
  geneRef <- df[df$geneID == "yourReferenceGene" & df$sampleID == s1,]
  ctRef <- geneRef$ct
    
  ct1 <- as.numeric(ct1)
  delta1 <- ct1 - ctRef
}


taq_data$delta1 <- apply(taq_data, 1, function(row) delta1_livak(taq_data, row[1], row[6]))


#' definition of the function to calculate the difference between delta Ct between experimental and reference sample
#' @param df: stands for data frame
#' @param g1: column containing gene names, usually [2] when open_data.R has been followed
#' @param d1: column containing delta Ct previously calculated, normally [5]
#' @param WT: defines a subset of data for the reference sample used (put your reference sample name in the quotes. Caution: R is case sensitive)
#' @param deltaWT: isolates delta Ct values for the reference sample
#' @param d1: all other delta Ct values in the data (numeric type forced)
#' @param delta2: calculates two to the power of the double delta (see Livak's article)
#' 
#' @example 
#' 
#' apply function to each row of the data frame and create new column to store the result
#' @param taq_data: data frame to be processed
#' @param 1: apply function to each row
#' @param function (row) delta2_livak: calls the function you want to apply
#' @param row[2]: refers to the second column containing the gene names
#' @param row[7]: refers to the fifth column containing the delta ct values previously calculated
#' 
#' @example 

delta2_livak <- function(df, g1, d1){
  WT <- df[df$sampleID == "yourReferenceSample" & df$geneID == g1,]
  deltaWT <- WT$delta1
  
  d1 <- as.numeric(d1)
  delta2 <- 2^(deltaWT - d1)
}


taq_data$delta2 <- apply(taq_data, 1, function(row) delta2_livak(taq_data, row[2], row[7]))





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
#' @param ct1: column containing Ct values, usually [6] when open_data.R has been followed
#' @param geneRef: defines a subset data for the references used
#' @param ctRef: calculates the geometric mean of the Ct values for the reference genes. REQUIRED PACKAGE: psych
#' @param ct1: all other Ct values in the data
#' @param delta1s: calculates the difference between the Ct of the target and the geometric mean of the reference genes
#' @param res: calculates ratio corresponding to the normalized values (see Livak's article)
#'
#' @example
#' apply function to each row of the data frame
#' @param taq_data: data frame to be processed
#' @param 1: apply the function to each row
#' @param function(row) norma_livak: calls the function you want to apply
#' @param row[1]: refers to the first column containing the sample names
#' @param row[6]: refers to the fourth column containing the ct values

delta1_livak_geom <- function(df, s1, ct1){
  geneRefs <- df[df$reference=="Reference" & df$sampleID==s1,]
  geomRef <- geometric.mean(geneRefs$ct)
    
  ct1 <- as.numeric(ct1)
  delta1s <- ct1 - geomRef
}

taq_data$delta1_geom <- apply(taq_data, 1, function(row) delta1_livak_geom(taq_data, row[1], row[6]))


#' definition of the function to calculate the difference between delta Ct between experimental and reference sample
#' @param df: stands for data frame
#' @param g1: column containing gene names, usually [2] when open_data.R has been followed
#' @param d1: column containing delta Ct previously calculated, normally [7]
#' @param WT: defines a subset of data for the reference sample used (put your reference sample name in the quotes. Caution: R is case sensitive)
#' @param deltaWT: isolates delta Ct values for the reference sample
#' @param d1: all other delta Ct values in the data (numeric type forced)
#' @param delta2: calculates two to the power of the double delta (see Livak's article)
#' 
#' @example 
#' 
#' apply function to each row of the data frame and create new column to store the result
#' @param taq_data: data frame to be processed
#' @param 1: apply function to each row
#' @param function (row) delta2_livak: calls the function you want to apply
#' @param row[2]: refers to the second column containing the gene names
#' @param row[7]: refers to the fifth column containing the delta ct values previously calculated
#' 
#' @example 

delta2_livak_geom <- function(df, g1, d1){
  WT <- df[df$sampleID == "yourReferenceSample" & df$geneID == g1,]
  deltaWT <- WT$delta1
  
  d1 <- as.numeric(d1)
  delta2 <- 2^(deltaWT - d1)
}


taq_data$delta2_geom <- apply(taq_data, 1, function(row) delta2_livak_geom(taq_data, row[2], row[7]))


#' NOTE: if no Reference status was assigned in Detector setup, you can create a vector containing all your reference genes
#' @example reference_genes <- c("gene1", "gene2", "gene3", ...)
#' and call it in geneRefs using %in%
#' geneRefs <- df[df$geneID %in% reference_genes & df$sampleID==s1,]
