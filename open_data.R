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
#' @param colClasses : specifies type of value stored in each column (character, number, factor...).
#' Use "NULL" for columns that you do not want to use.
#' @param na.string : change all the 999 to NA
#' @example TaqMan chemistry data set
#' colnames() : only if you want to rename the first three columns that by default are "Name", "Type", "Name.1" and "Type.1"

taq_data <- read.csv("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, colClasses = c("NULL", "character", "character", "numeric", "character", "character", "numeric", "NULL", "NULL", "character", "NULL", "NULL"), na.strings = "999")

colnames(taq_data) <- c("sampleID", "type", "concentration", "geneID", "reference", "ct", "status")

#'
#' @example EvaGreen chemistry data set (more columns with melting curve data)

eva_data <- read.csv("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, colClasses = c("NULL", "character", "character", "numeric", "character", "character", "numeric", "NULL", "NULL", "character", "NULL", "NULL","NULL", "NULL", "NULL"), na.strings = "999")

colnames(eva_data) <- c("sampleID", "type", "concentration", "geneID", "reference", "ct", "status")


#' It is possible that the Fluidigm software calculates a Ct value but gives it a Fail status.
#' We find it best to exclude these values in order to work with only the valid values.
#'
#' df stands for data frame. To be replaced with your data frame name (i.e taq_data)
#' @param is.na(df$ct) == FALSE: selects all non NA values in the ct column
#' @param df$status=="Fail": selects rows with Fail status
#' @param <- NA: attributes NA to ct values with Fail status
#' @example
#' The status column can be removed after this step
#' @example

df[is.na(df$ct) == FALSE & df$status == "Fail", 4] <- NA

df$status <- NULL
