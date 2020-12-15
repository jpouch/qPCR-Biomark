#! /usr/bin/Rscript

### Data normalization (Livak's method) ###

######################################## Reference ########################################
# "Analysis of relative gene expression data using real-time PCR and the 2^-ââCt method"
#		Kenneth J. Livak and Thomas D. Schmittgen
#	  		Methods, 25, 402-408 (2001)
#	http://www.gene-quantification.net/livak-2001.pdf
###########################################################################################



#' Function to normalize qPCR data to a reference sample and a reference gene
#'
#' definition of the function to calculate the delta Ct between target gene and reference gene
#' @param df: data frame to be normalized
#' @param s1: column containing sample names, usually [2] when open_data.R has been followed
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
#' @param row[2]: refers to the column containing the sample names
#' @param row[6]: refers to the column containing the ct values
#' 
#' @example 

RefGeneID <- "yourReferenceGeneID"

delta1_livak <- function(df, s1, ct1){
  geneRef <- df[df$geneID == RefGeneID & df$sampleID == s1,]
  ctRef <- geneRef$ct
    
  ct1 <- as.numeric(ct1)
  delta1 <- ct1 - ctRef
}


taq_data$delta1 <- apply(taq_data, 1, function(row) delta1_livak(taq_data, row[2], row[6]))


#' definition of the function to calculate the difference between delta Ct between experimental and reference sample
#' @param df: data frame to be normalized
#' @param g1: column containing gene names, can be [1] when add_efficiency.R has been followed or [4] when open_data.R has been followed
#' @param d1: column containing delta Ct previously calculated, can be [7] or [8]
#' @param sampleRef: defines a subset of data for the reference sample used (put your reference sample name in the quotes. Caution: R is case sensitive)
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
#' @param row[1]: refers to the column containing the gene names
#' @param row[8]: refers to the column containing the delta ct values previously calculated
#' 
#' @example 

sampleRef <- "yourReferenceSample"

delta2_livak <- function(df, g1, d1){
  WT <- df[df$sampleID == sampleRef & df$geneID == g1,]
  deltaWT <- WT$delta1
  
  d1 <- as.numeric(d1)
  delta2 <- 2^-(deltaWT - d1)
}


taq_data$delta2 <- apply(taq_data, 1, function(row) delta2_livak(taq_data, row[1], row[8]))





#' Function to normalize qPCR data to a set of several reference genes
#'
#'
#' If you have several reference genes, you can normalize your data to the geometric mean of the genes.
#' Reference: "Accurate normalization of real-time quantitative RT-PCR data by geometric averaging of multiple internal control genes"
#' Vandesompele J. et al - Genome Biology 2002, 3(7)
#'
#' definition of the function
#' @param df: stands for data frame
#' @param s1: column containing sample names, usually [2] when open_data.R has been followed
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
#' @param row[2]: refers to the column containing the sample names
#' @param row[6]: refers to the column containing the ct values

#' Required package
library(psych)


RefGenesID <- c("Reference1", "Reference2", "Reference3")                         
                         
delta1_livak_geom <- function(df, s1, ct1){
  geneRefs <- df[df$reference %in% RefGenesID & df$sampleID == s1, ]
  geomRef <- geometric.mean(geneRefs$ct)
    
  ct1 <- as.numeric(ct1)
  delta1s <- ct1 - geomRef
}

taq_data$delta1_geom <- apply(taq_data, 1, function(row) delta1_livak_geom(taq_data, row[2], row[6]))


#' definition of the function to calculate the difference between delta Ct between experimental and reference sample
#' @param df: stands for data frame
#' @param g1: column containing gene names, can be [1] or [4]
#' @param d1: column containing delta Ct previously calculated, normally [7]
#' @param sampleRef: defines a subset of data for the reference sample used (put your reference sample name in the quotes. Caution: R is case sensitive)
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
#' @param row[1]: refers to the column containing the gene names
#' @param row[7]: refers to the column containing the delta ct values previously calculated
#' 
#' @example 

sampleRef <- "yourReferenceSample"

delta2_livak_geom <- function(df, g1, d1){
  WT <- df[df$sampleID == sampleRef & df$geneID == g1, ]
  deltaWT <- WT$delta1
  
  d1 <- as.numeric(d1)
  delta2 <- 2^(deltaWT - d1)
}


taq_data$delta2_geom <- apply(taq_data, 1, function(row) delta2_livak_geom(taq_data, row[4], row[7]))


                              
                              
## J. Pouch ## 2020 ##
