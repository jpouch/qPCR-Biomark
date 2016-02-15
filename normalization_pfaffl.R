#! /usr/bin/Rscript

### Data normalization (Pfaffl's method) ###

######################################## Reference ########################################
#	 "A new mathematical model for relative quantification in real-time RT_PCR"
#			Michael W. Pfaffl
#		Nucleic Acid Research, 2001, Vol 29, N°9 00
#	http://nar.oxfordjournals.org/content/29/9/e45.long							  															  #
###########################################################################################

#' Function to normalize qPCR data to one reference gene
#'
#'definition of the function
#' @param df: stands for data frame
#' @param s1: column containing sample names, usually [1] when open_data.R has been followed
#' @param e1: column containing efficiency values, usually [6] when open_data.R has been followed
#' @param ct1: column containing Ct values, usually [4] when open_data.R has been followed
#' @param row: defines a subset data for the reference used (put your reference gene name in the quotes. Caution: R is case sensitive)
#' @param eRef: isolate efficiency for the reference
#' @param ctRef: isolate Ct values for the reference
#' @param denom: calculates denominator (for the reference)
#' @param e1: all other efficiencies in the data
#' @param ct1: all other Ct values in the data
#' @param num: calculates numerator (for the targets)
#' @param res: calculates ratio corresponding to the normalized values (see Pfaffl's article)
#'
#' @example
#' apply function to each row of the data frame
#' @param taq_data: data frame to be processed
#' @param 1: apply the function to each row
#' @param function(row) norma_livak: calls the function you want to apply
#' @param row[1]: refers to the first column containing the sample names
#' @param row[6]: refers to the sixth column containing the efficiency values
#' @param row[4]: refers to the fourth column containing the ct values


norma_pfaffl <- function(df, s1, e1, ct1){
	row <- df[df$geneID=="yourReferenceGene" & df$sampleID==s1,]
	eRef <- row$efficiency
	ctRef <- row$ct
	denom <- (eRef^(-1 * ctRef))
	
	e1 <- as.numeric(e1)
	ct1 <- as.numeric(ct1)
	num <- (e1^(-1 * ct1))
	
	res <- num/denom  
}

taq_data$pfaffl <- apply(taq_data, 1, function(row) norma_pfaffl(taq_data, row[1], row[6], row[4]))

