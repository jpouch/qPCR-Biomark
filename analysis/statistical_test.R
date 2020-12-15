#! usr/bin/Rscript

#' Required package
library(reshape2)


### Apply statistical test to the qPCR data set ###
#'
#' The data that has been used so far is long-format data:
#' all genes are stored in one column and their corresponding values in another column.
#' To perform a statiscal test across the data, we need to change the format from long to wide to get one column per gene.
#'
#' @param taq_data: data frame to be casted.
#' @param sampleID: column used as ID variable. The names should clearly indicate conditions or groups to be compared.
#' If easier, you can add a "condition" or "group" column and specify it to dcast as following: sampleID + condition ~ geneID
#' @param geneID: column used to put all genes in individuals columns.
#' @param value.var: column containing values (here we choose the normalized values in column "delta2", but you can indicate the column of your choice.)
#' 
#' @example

taq_stat <- reshape2::dcast(taq_data, sampleID ~ geneID, value.var="delta2")

#'
#' Some of the columns may contains a lot of NA values. Performing a statiscal test on those columns will generate an error.
#' We need to remove those columns.
#' The data frame needs to be set as a data table in order to be able to use the ":=" assignment from the data.table package to remove the columns.
#'
#' @example: set taq_data as data table

taq_stat <- as.data.table(taq_stat)

#'
#' Apply function to calculate the number of NA values per column
#'
#' @param taq_stat: data table to be processed
#' @param function(x) sum: calculates the sum of the NA values
#' @param length(which(is.na(x))): calculates the length of the vector for which is.na test returns TRUE
#'
#' @example

na_count <- sapply(taq_stat, function(x) sum(length(which(is.na(x)))))

#'
#' Get the column number where na_count is superior to a value of your choice.
#' For 96.96 experiments, we chose 75; and for 48.48 experiments we chose 32. Those are arbitrary choices, for which the statistical works. You can set the limit value to another value until the test works.
#'
#' @param which(na_count > 75): displays the column numbers for which there are more than 75 NA values
#'
#' @example

which(na_count > 75)

#'
#' Remove columns from the data table
#'
#' Copy the numbers previously displayed
#'
#' @param taq_stat: data table to be processed
#' @param c(4, 6, 14, 21, 38): vector containing column numbers to be removed
#' @param := NULL: assign NULL to those columns which comes down to remove them
#'
#' @example

taq_stat <- taq_stat[, c(3, 5, 8, 11, 13, 14, 17, 18, 20, 28, 30, 31, 37, 38, 39, 49, 50, 57, 58, 63, 74, 78, 81, 83, 84, 89):= NULL]

#'
#' Revert data table to data frame
#'
#' @example

taq_stat <- as.data.frame(taq_stat)

#'
#' Apply statistical test to each column for a comparison of two conditions/groups (Wilcoxon test chosen for example)
#' The p-value result is stored in a data frame (one p-value per gene)
#'
#' @param as.data.frame: store the results in data frame format
#' @param sapply: returns the p-value in a vector
#' @param taq_stat[-1]: apply test to whole data frame
#' @param  function(x): apply following function
#' @param unlist(wilcox.test): apply Wilcoxon rank sum test (also known as Mann-Whitney test for non-parametric data)
#' @param x~taq_stat$sampleID, na.action = "na.exclude": specifies where the condition/group info is and exclude the possible NA values in the data
#' @param ["p-value"]: extract p-value from test output
#'
#' @example

taq_wilcox <- as.data.frame(sapply(taq_stat[-1],
                                   function(x) unlist(wilcox.test(x~taq_stat$sampleID, na.action = "na.exclude")["p.value"])))

#'
#' Assign legend to p-values
#' You can automatically assign stars to p-values with the function stars.pval() from the gtools package.
#' You need to store the p-values in a vector
#' (in our example you can do: pvalues <- sapply(taq_stat[-1], function(x) unlist(wilcox.test(x~taq_stat$sampleID, na.action = "na.exclude")["p.value"]))
#' Then run stars.pval(pvalues)

                                   
                                   
## J. Pouch ## 2020 ##                                   
