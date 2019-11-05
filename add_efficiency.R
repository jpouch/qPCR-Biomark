#! /usr/bin/Rscript

library(reshape2)
library(qdapTools)
library(ggplot2)

### Add efficiency values to data set ###
#' Create matrix to be melted
#'
#' value: vector containing the Ct values
#' genes: vector containing gene names
#' conc: vector containing log(concentration)
#' if there is a NA value in this vector, it has to be removed by selecting only the numeric values using the na.omit() function
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

value <- taq_data[taq_data$type == "Standard",6]
genes <- as.vector(unique(taq_data[,4]))
conc <- na.omit(log10(unique(taq_data[taq_data$type == "Standard",3])))

mat <- matrix(value, nrow  = 4, ncol = 96, dimnames = list(conc, genes), byrow = TRUE)
mat <- as.data.frame(mat)
mat$slope <- conc

#' Melt the data frame (stacks a set of columns into a single column of data)
#'
#' @param mat: data frame to be processed
#' @param id: specifies the id variables, in our case the log(concentration) stored in the last column
#' @param measure: specifies the measured variables (all columns execpt the last one)
#' @param variable: id to be stacked into a single column
#' We use na.omit() to remove NA values that will generate an error when calling the by() function
#'
#' @example

std <- na.omit(melt(mat, id=names(mat)[97], measure=names(mat)[1:96], variable = "genes"))

#' Extract slope value from linear regression
#'
#' @param std: data frame to be processed
#' @param std$genes: specifies factors to be used, in our case the genes
#' @param coef: function to apply linear regression (lm) to the data
#'
#' @example
#'
#' Some genes may return NULL in the "fits" list.
#' We need to change NULL to NA in order to prevent the difference in length error from the do.call function.
#'
#' create function to change NULL to NA
#' apply function to list of interest
#' create data frame with only gene names and slope value
#' calculate efficiency with 10^(-1/slope) formula
#' remove slope column in order to retrieve efficiency with the lookup() function (see below)
#'
#' @example

fits <- by(std, std$genes, function(i) coef(lm(value ~ slope, i)))

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}
fits <- nullToNA(fits)

eff <- data.frame(genes = names(fits), do.call(rbind, fits))[c(1,3)]
eff$efficiency <- 10^(-1/eff$slope)
eff$slope <- NULL

#' Add efficiency values to the data frame of interest
#'
#' @param taq_data$geneID: column containing value to be looked up
#' @param eff: data frame containing values to be extracted and assigned (must be two columns only)
#' @param missing: attributes NA to any value missing in the eff data (i. e. genes not present in the eff data frame)
#'
#' @example

taq_data$efficiency <- lookup(taq_data$geneID, eff, missing = NA)


### Optional ###
#'
#' Visualize standard curves with ggplot2
#'

ggplot(std, aes(x = slope, y = value, color = genes)) +
  geom_point(size = 3) +
  labs(x = "log[C]", y = "Ct") + 
  geom_smooth(method = "lm", se = FALSE)
