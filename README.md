# qPCR-Biomark
**R scripts to process and analyze qPCR data from Fluidigm Biomark HD**

---

**Creation : 2016/01/06**

**Last update : 2016/04/11**

---

## Motivation

qPCR-Biomark contains different R scripts developed to analyze high-throughput qPCR data from Fluidigm Biomark HD.
Normalization to a reference gene is available for both [Livak](http://www.gene-quantification.de/livak-2001.pdf) and [Pfaffl](http://www.gene-quantification.de/pfaffl-nar-2001.pdf) methods for TaqMan® chemistry and EvaGreen chemistry experiments.  
This repository was made to help researchers handling large sets of qPCR data from the Biomark HD. Any question, feedback and request are welcome. Feel free to contact us (see below).


## Principle

qPCR results from a Biomark experiment can be exported as csv file from Fluidigm Real-Time PCR Analysis software.
**about_data.txt** describes content for each column of the csv and specifies those that will be used for further analysis (sample name, sample type, standard concentration, gene name, gene type, Ct value, quality status).

**open_data.R** is a simple R script with a single command line to open the csv file in your R session, remove unused rows, assign type of data per column and which value to consider as NA (i. e. 999).
Data set may contain unvalid Ct values (Ct value different from 999 but with Fail status) - it can be saturated signals from too high expressed genes (Ct < 4 - software will be unable to distinguish between noise and true amplification) or signals that give bad amplification curve.
Command lines to replace these values with NA are described.

**add_efficiency.R** describes how to extract slopes to calculate efficiency for each gene (necessary if working with Pfaffl's method).
Data from the Standard samples is stored in a matrix used to create a molten data frame. Coefficients from linear regression are isolated in a new data frame, and efficiency values are calculated using the 10^(-1/slope) formula. The lookup function allows to assign efficiency value to each gene along the data frame from *open_data.R*.

#### Normalization

**livak_method.R** is an R script which performs normalization to a reference gene and a reference sample, according to the Livak's method (2^-∆∆Ct - see [article](http://www.gene-quantification.de/livak-2001.pdf)). The calculation is performed in two steps: a first delta Ct to the reference gene, and a second delta to the reference sample.
A function to perform the normalization to multiple reference genes using the geometric mean is also described (psych package required). This method is described in *"Accurate normalization of real-time quantitative RT-PCR data by geometric averaging of multiple internal control genes"* Vandesompele J. et al - Genome Biology 2002, 3(7).

**pfaffl_method.R** is an R script which performs normalization to a reference sample and a reference gene according to the Pfaffl's method (see [article] (http://www.gene-quantification.de/pfaffl-nar-2001.pdf)). In this script, you will need to have added efficiency value for each gene (as described in add_efficiency.R). The calculation is performed in two steps: delta Ct to the reference sample, and ratio between deltas for reference gene and other genes.

#### Analysis

**hierarchical_clustering.R** is an R script which performs hierarchical clustering. The example described is a clustering on the samples, on the raw Ct values. It is absolutely possible to make the clustering on the genes or on normalized values.
Most functions used are in the R stats package.  
The dist() function accepts different methods, yet we have not tested them all and have no qualification in advising which one is the best for the data set. You can learn more about this function [here](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/dist.html).  
The hclust() function also works with different methods. Changing method can drastically change the output tree (dendrogram) you will get. Again here, we have no expertise about these methods. The choice will depend on the type of samples, data set etc. All about hclust [here](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/hclust.html).

**statistical_analysis.R** is an R script which allows to run statistical test of your choice to the data.
Steps to change the data format to get one gene per column is described in the script.
Too many NA values in one column causes the sapply() function to fail. Command lines to count NA values per column and remove the corresponding columns are described. The threshold chosen is arbitrary and can be changed according to your needs.
For our example we chose wilcox.test (Wilcoxon rank sum aka Mann-Whitney test), but the command works with other tests (e. g. t.test, kruskal.test etc.). The choice of the test depends on the size of the groups to be compared, the matching of the groups (independancy, paired etc.). This [webpage](http://www.biostathandbook.com/testchoice.html) gives interesting tips for choosing the right test for your data.

## Get qPCR-Biomark

* Download the program

With *git clone* from the repository
 
```	git clone https://github.com/jpouch/qPCR-Biomark ```


## Usage

These scripts allow quick processing and analysis of high-throughput qPCR data generated on the Biomark HD from Fluidigm.
Largest data set are 9,216 rows, difficult to handle on Excel.  
Using R to open and process data allows the user to quickly subset data and perform different analysis (average, standard deviation etc.) on the whole data set.

We recommand using RStudio interface, because it is very user-friendly and easy to use for non expert R users.
You can download it [here](https://www.rstudio.com/products/rstudio/download/).

#### Program

* R 3.2.2 +

#### Third party R packages

 | data.table | ggplot2 | Hmisc | psych | qdap | reshape2 | stringr
------------ | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | -------------
command | as.data.table, := | geom_point, geom_smooth | %nin% | geometric.mean | lookup | melt | str_detect |
file | statistical_test.R | add_efficiency.R |  | livak_method.R | add_efficiency.R | add_efficiency.R | |

## Authors and Contact

Juliette Pouch - 2016
* <juliette.hamroune@inserm.fr> | <juliette.pouch@gmail.com>
* [Github](https://github.com/jpouch)
* High-throughput qPCR core facility - IBENS contact: <qpcr@biologie.ens.fr> ; [web page](http://www.ibens.ens.fr/spip.php?rubrique46)
