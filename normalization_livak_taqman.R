#! /usr/bin/Rscript

### Data normalization (Livak's method) ###

######################################## Reference ########################################
#							  															  #
# "Analysis of relative gene expression data using real-time PCR and the 2^-∆∆Ct method"  #
#						Kenneth J. Livak and Thomas D. Schmittgen						  #
#								Methods, 25, 402-408 (2001)								  #
#					http://www.gene-quantification.net/livak-2001.pdf					  #
#							  															  #
###########################################################################################

#' Function to normalize qPCR data to one reference gene
#'
#'
#' @param df: data frame to work with
#' @param s1: column containing sample names, usually [1]
#' @param ct1: column containing Ct values, usually [5]
#' @param row: defines data for the reference used
#' @param ctRef: calculates geometric mean on Ct values for the reference
#' @param ct1: all other Ct values in the data
#' @param res: calculates ratio corresponding to the normalized values
#'
#' @example

norma_livak <- function(df, s1, m1){
  row <- df[df$reference=="Reference" & df$name==s1,]
  ctRef <- geometric.mean(row$ctVal)
    
  m1 <- as.numeric(m1)
  delta <- m1 - ctRef
  res <- 2^-delta 
}

fr$livak <- apply(fr, 1, function(row) norma_livak(fr, row[1], row[4]))


#' NOTE: if no Reference was assigned in Detector setup, use the assay name (e.g. df[df$geneID=="your_reference" & df$name==s1,]