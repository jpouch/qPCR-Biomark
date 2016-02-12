#! /usr/bin/Rscript

########## RStudio ##########

### Opening file ###
#' Make sure you are in the correct working directory (to get current working directory use getwd())
#' 
#'
#' @param skip = 11 : allows to skip the file header
#' @param sep = "," : specifies column separator
#' @param dec = "." : specifies type of decimal
#' @param header = TRUE : extracts header name of each column
#' @param fill = TRUE : bypasses error if some columns do not have the same row number
#' @param colClasses : specifies type of value stored in each column (character, number, factor...). Use "NULL" for columns that will not be used
#' @param na.string : change all the 999 to NA
#' @example TaqMan chemistry data set
#' colnames() : only if you want to rename the first three columns that by default are "Name", "Name.1" and "Type.1"

taq_data <- read.csv("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, colClasses = c("NULL", "character", "NULL", "NULL", "character", "character", "numeric", "NULL", "NULL", "character", "NULL", "NULL"), na.strings = "999")

colnames(taq_data) <- c("sampleID", "geneID", "reference", "ct", "status")

#' @example EvaGreen chemistry data set (more columns with melting curve data)

eva_data <- read.csv("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, colClasses = c("NULL", "character", "NULL", "NULL", "character", "character", "numeric", "NULL", "NULL", "character", "NULL", "NULL","NULL", "NULL", "NULL"))

colnames(eva_data) <- c("sampleID", "geneID", "reference", "ct", "status")

#' If you have added the efficiency values in the last column (see pre_process_data.txt), you can add one item in colClasses
#' @example TaqMan chemistry data set
#' @example EvaGreen chemistry data set

taq_data <- read.csv("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, colClasses = c("NULL", "character", "NULL", "NULL", "character", "character", "numeric", "NULL", "NULL", "character", "NULL", "NULL", "numeric"), na.strings = "999")

colnames(taq_data) <- c("sampleID", "geneID", "reference", "ct", "status", "efficiency")

eva_data <- read.csv("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, colClasses = c("NULL", "character", "NULL", "NULL", "character", "character", "numeric", "NULL", "NULL", "character", "NULL", "NULL","NULL", "NULL", "NULL", "numeric"))

colnames(eva_data) <- c("sampleID", "geneID", "reference", "ct", "status", "efficiency")
