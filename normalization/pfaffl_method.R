#! /usr/bin/Rscript

### Data normalization (Pfaffl's method) ###

######################################## Reference ########################################
#	 "A new mathematical model for relative quantification in real-time RT_PCR"
#			      Michael W. Pfaffl
#		  Nucleic Acid Research, 2001, Vol 29, N°9 00
#	  http://nar.oxfordjournals.org/content/29/9/e45.long
###########################################################################################

#' Function to normalize qPCR data to one reference gene
#'
#'definition of the function to calculate delta Ct between reference samples and experimental sample
#' @param df: stands for data frame
#' @param g1: column containing gene names, usually [2] when open_data.R has been followed
#' @param ct1: column containing Ct values, usually [6] when open_data.R has been followed
#' @param e1: column containing efficiency values, usually [7] when open_data.R has been followed and status deleted
#' @param WT: defines a subset data for the reference sample used (put your reference sample name in the quotes. Caution: R is case sensitive)
#' @param ctWT: isolates Ct values for the reference sample
#' @param ct1: all other Ct values in the data (numeric type forced)
#' @param e1: all efficiencies in the data (numeric type forced)
#' @param delta: calculates for each gene efficiency to the power of delta ct
#'
#' @example
#' 
#' apply function to each row of the data frame
#' @param taq_data: data frame to be processed
#' @param 1: apply the function to each row
#' @param function(row) delta_pfaffl: calls the function you want to apply
#' @param row[2]: refers to the second column containing the gene names
#' @param row[6]: refers to the fourth column containing the ct values
#' @param row[7]: refers to the fifth column containing the efficiency values
#' 
#' @example 

delta_pfaffl <- function(df, g1, ct1, e1){
  WT <- df[df$sampleID == "yourReferenceSample" & df$geneID == g1,]
  ctWT <- WT$ct
  ct1 <- as.numeric(ct1)
  
  e1 <- as.numeric(e1)
  
  delta <- e1^(ctWT-ct1)
}


taq_data$delta <- apply(taq_data, 1, function(row) delta_pfaffl(taq_data, row[2], row[6], row[7]))

#' definition of the function to calculate delta ratio between target genes and reference gene
#' @param df: stands for data frame
#' @param s1: column containing sample names, usually [1] when open_data.R has been followed
#' @param d1: column containing delta ct previously calculated, normally [8]
#' @param ref: defines a subset data for the reference gene used (put your reference gene name in the quotes. Caution: R is case sensitive)
#' @param deltaRef: isolates delta Ct values for the reference gene
#' @param d1: all other delta Ct values in the data (numeric type forced)
#' @param ratio: calculates ratio to the reference gene for each gene in the data
#' 
#' @example 
#' 
#' apply function to each row of the data frame
#' @param taq_data: data frame to be processed
#' @param 1: apply funciton to each row
#' @param function(row) ratio_pfaffl: calls the function you want to apply
#' @param row[1]: refers to the first column containing the sample names
#' @param row[8]: refers to the sixth column containing the delta ct values
#' 
#' @example 


ratio_pfaffl <- function(df, s1, d1){
  ref <- df[df$geneID == "yourReferenceGene" & df$sampleID == s1,]
  deltaRef <- ref$delta
  d1 <- as.numeric(d1)
  
  ratio <- d1/deltaRef
}
#' Apply ratio calculation to data frame
taq_data$ratio <- apply(taq_data, 1, function(row)  ratio_pfaffl(taq_data, row[1], row[8]))
