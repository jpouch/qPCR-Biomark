#! /usr/bin/Rscript

library(conflicted)

### Opening file ###
#' Make sure you are in the correct working directory (use getwd() and setwd() functions)
#' 
#' enter your csv file name (e. g. "file.csv")
#' @param skip = 11 : allows to skip the first eleven rows of the csv file (contain infos about your Biomark run)
#' @param sep = "," : specifies column separator
#' @param dec = "," : specifies type of decimal (usually changes with computer's language settings)
#' @param header = TRUE : extracts header name of each column
#' @param fill = TRUE : bypasses error if some columns do not have the same row number
#' @param na.string : change all the 999 values to NA
#'
#' Keep only columns with data of interest (i.e. columns 2 to 7 and column 10)
#' @example TaqMan chemistry data set
#' colnames() : optional. Only if you want to rename the first four columns that by default are "Name", "Type", "Name.1" and "Type.1"

taq_data <- read.table("taq_data.csv", skip = 11, sep = ",", dec = ",", header = TRUE, fill = TRUE, na.strings = "999", stringsAsFactors = FALSE)

taq_data <- taq_data[, c(2:7, 10)]

colnames(taq_data) <- c("sampleID", "type", "concentration", "geneID", "reference", "ct", "status")

#'
#' @example EvaGreen chemistry data set (more columns with melting curve data)

eva_data <- read.table("file.csv", skip = 11, sep = ",", dec = ".", header = TRUE, fill = TRUE, na.strings = "999", stringsAsFactors = FALSE)

eva_data <- eva_data[, c(2:7, 10)]

colnames(eva_data) <- c("sampleID", "type", "concentration", "geneID", "reference", "ct", "status")


#' It is possible that the Fluidigm software calculates a Ct value but gives it a Fail status.
#' We find it best to exclude these values in order to work with only the valid values.
#'
#' @param is.na(df$ct) == FALSE: selects all non NA values in the ct column
#' @param df$status == "Fail": selects rows with Fail status
#' @param 6: column containing Ct values
#' @param <- NA: attributes NA to ct values with Fail status
#'
#' @example
#' The "status" column can be removed after this step
#' @example

taq_data[is.na(taq_data$ct) == FALSE & taq_data$status == "Fail", 6] <- NA

taq_data$status <- NULL






## J. Pouch ## 2020 ##
