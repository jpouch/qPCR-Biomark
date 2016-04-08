#! /usr/bin/Rscript

### Add efficiency values to data set ###
#' 
#' Create subset table with Standard samples only
#'
#' @param taq_data= data frame to be processed
#' @param taq_data$type == "Standard": selects samples that are referenced as standard in the Sample Setup from Real-time Analysis software.
#'
#' @example
#'
#' Remove first columns containing sample name (no longer needed)

standard <- subset(taq_data, taq_data$type == "Standard")
standard[,1] <- NULL

#' Set concentrations to log10
#'
#' @example


standard$conc <- log10(standard$conc)

#' Create matrix to be melted
#'
#' value: vector containing the Ct values
#' genes: vector containing gene names
#' conc: vector containing log(concentration)
#'
#' @param value: vector of values used to fill the matrix
#' @param nrow: number of rows. Must be equal to the length of the vector used for rows, in our case length(slope) = 4
#' @param ncol: number of columns. Must be equal to the length of the vector used for columns, in our case number of genes
#' @param dimnames: assign row and column names. First element of list() is for rows and second is for columns
#' @ param byrow = TRUE: fills the matrix by row (default is by column)
#'
#' set matrix as data frame
#' add a column containing concentration values
#'
#' @example

value <- standard[,3]
genes <- unique(standard[,2])
conc <- unique(standard[,1])

mat <- matrix(value, nrow  = 4, ncol = 96, dimnames = list(slope, genes), byrow = TRUE)
mat <- as.data.frame(mat)
mat$slope <- conc

#' Melt the data frame (stacks a set of columns into a single column of data)
#'
#' @param mat: data frame to be processed
#' @param id: specifies the id variables
#' @param measure: specifies the measured variables
#' @param variable: id to be stacked into a single column
#'
#' @example

std <- melt(mat, id=names(mat)[97], measure=names(mat)[1:96], variable = "genes")

#' Extract slope value from linear regression
#'
#' @param std: data frame to be processed
#' @param std$genes: specifies factors to be used, in our case the genes
#' @param coef: function to apply linear regression (lm) to the data
#'
#' @example
#'
#' create data frame with only gene names and slope value
#' calculate efficiency with 10^(-1/slope) formula
#'
#' @example

fits <- by(std, std$genes, function(i) coef(lm(value ~ slope, i)))
eff <- data.frame(genes = names(fits), do.call(rbind, fits))[c(1,3)]
eff$efficiency <- 10^(-1/eff$slope)

#' Add efficiency values to the data frame of interest
#'
#' @param taq_data$geneID: column containing value to be looked up
#' @param eff: data frame containing values to be extracted and assigned
#'
#' @example
flui$efficiency <- lookup(flui$geneID, eff)
