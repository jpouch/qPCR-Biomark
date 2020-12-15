#! /usr/bin/Rscript


#' Required packages
library(reshape2)
library(ggplot2)

### Add efficiency values to data set ###
#' Create matrix to be melted
#'
#' value: vector containing Ct values
#' geneID: vector containing gene names
#' conc: vector containing log(concentration) values
#' if there is a NA value in this vector, it has to be removed by selecting only the numeric values using the na.omit() function
#'
#' @param values: vector of values used to fill the matrix
#' @param nrow: number of rows. Must be equal to the length of the vector used for rows, in our case length(slope) = 4
#' @param ncol: number of columns. Must be equal to the length of the vector used for columns, in our case number of genes
#' @param dimnames: assign row and column names. First element of list() is for rows and second is for columns
#' @param byrow = TRUE: fills the matrix by row (default is by column)
#'
#' set matrix as data frame
#' add a column containing concentration values
#'
#' @example

values <- taq_data[taq_data$type == "Standard", 6]
geneID <- unique(taq_data[,4])
conc <- na.omit(log10(unique(taq_data[taq_data$type == "Standard", 3])))

mat <- as.data.frame(matrix(values, nrow  = 4, ncol = 96, dimnames = list(conc, geneID), byrow = TRUE))
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

std <- na.omit(reshape2::melt(mat, id=names(mat)[97], measure=names(mat)[1:96], variable = "geneID"))

#' Extract slope value from linear regression
#'
#' @param std: data frame to be processed
#' @param std$geneID: specifies factors to be used, in our case the genes
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

fits <- by(std, std$geneID, function(i) coef(lm(value ~ slope, i)))

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

fits <- nullToNA(fits)

eff <- data.frame(geneID = names(fits), do.call(rbind, fits))[c(1, 3)]
eff$efficiency <- 10^(-1/eff$slope)
eff$slope <- NULL

#' Add efficiency values to the data frame of interest
#'
#' @param taq_data: dataframe
#' @param eff: data frame containing values to be extracted and assigned (must be two columns only)
#' @param all.x = TRUE: attributes NA to any value missing in the eff data (i. e. genes not present in the eff data frame)
#'
#' @example

taq_data <- merge(taq_data, eff, all.x = TRUE)

           
#' Remove Standard data that cause errors for the normalization step
#'
#' 
taq_data <- taq_data[taq_data$type != "Standard", ]

### Optional ###
#'
#' Visualize standard curves with ggplot2 for reference genes
#'

ggplot(std, aes(x = slope, y = value, color = geneID)) +
  geom_point(size = 3) +
  labs(x = "log[C]", y = "Ct") + 
  geom_smooth(method = "lm", se = FALSE)

           
           
           
## J. Pouch ## 2020 ##
