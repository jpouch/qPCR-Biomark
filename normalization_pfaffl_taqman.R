#! /usr/bin/Rscript

### Data normalization (Pfaffl's method) ###

######################################## Reference ########################################
#							  															  #
#	    "A new mathematical model for relative quantification in real-time RT_PCR"   	  #
#									Michael W. Pfaffl									  #
#						Nucleic Acid Research, 2001, Vol 29, N°9 00						  #
#					http://nar.oxfordjournals.org/content/29/9/e45.long					  #
#							  															  #
###########################################################################################

#' Function to normalize qPCR data to one reference gene
#'
#'
#' @param df: data frame to work with
#' @param s1: column containing sample names, usually [1]
#' @param e1: column containing efficiency values, usually [6]
#' @param ct1: column containing Ct values, usually [4]
#' @param row: defines data for the reference used
#' @param eRef: isolate efficiency for the reference
#' @param ctRef: isolate Ct values for the reference
#' @param denom: calculates denominator
#' @param e1: all other efficiencies in the data
#' @param ct1: all other Ct values in the data
#' @param num: calculates numerator
#' @param res: calculates ratio corresponding to the normalized values
#'
#' @example


norma_pfaffl <- function(df, s1, e1, ct1){
	row <- df[df$reference=="Reference" & df$sampleID==s1,]
	eRef <- row$efficiency
	ctRef <- row$ct
	denom <- (eRef^(-1 * ctRef))
	
	e1 <- as.numeric(e1)
	ct1 <- as.numeric(ct1)
	num <- (e1^(-1 * ct1))
	
	res <- num/denom  
}

fr$pfaffl <- apply(fr, 1, function(row) norma_pfaffl(fr, row[1], row[6], row[4]))


#' NOTE: if no Reference was assigned in Detector setup, use the assay name (e.g. df[df$geneID=="your_reference" & df$sampleID==s1,]