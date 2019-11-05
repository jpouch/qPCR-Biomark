#! /usr/bin/Rscript

### Opening file ###
#' Make sure you are in the correct working directory (to get current working directory use getwd())
#' 
#' enter your csv file name (e. g. "file.csv")
#' @param skip = 11 : allows to skip the file header
#' @param sep = "," : specifies column separator
#' @param dec = "." : specifies type of decimal
#' @param header = TRUE : extracts header name of each column
#' @param fill = TRUE : bypasses error if some columns do not have the same row number
#' @param na.string : change all the 999 to NA
#'
#' Keep only columns with data of interest (i.e. columns 2 to 7 and column 10)
#' @example TaqMan chemistry data set
#' colnames() : only if you want to rename the first four columns that by default are "Name", "Type", "Name.1" and "Type.1"

taq_data <- read.table("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, na.strings = "999")

taq_data <- taq_data[,c(2:7,10)]

colnames(taq_data) <- c("sampleID", "type", "concentration", "geneID", "reference", "ct", "status")

#'
#' @example EvaGreen chemistry data set (more columns with melting curve data)

eva_data <- read.table("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, na.strings = "999")

eva_data <- eva_data[,c(2:7,10)]

colnames(eva_data) <- c("sampleID", "type", "concentration", "geneID", "reference", "ct", "status")


#' It is possible that the Fluidigm software calculates a Ct value but gives it a Fail status.
#' We find it best to exclude these values in order to work with only the valid values.
#'
#' df stands for data frame. To be replaced with your data frame name (i.e taq_data)
#' @param is.na(df$ct) == FALSE: selects all non NA values in the ct column
#' @param df$status=="Fail": selects rows with Fail status
#' @param 6: column containing Ct values
#' @param <- NA: attributes NA to ct values with Fail status
#'
#' @example
#' The status column can be removed after this step
#' @example

df[is.na(df$ct) == FALSE & df$status == "Fail", 6] <- NA

df$status <- NULL
