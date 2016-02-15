# qPCR-Biomark
R scripts to process and analyze qPCR data from Fluidigm Biomark HD

---

**Creation : 2016/01/06**

**Last update : 2016/02/12**

---

## Motivation

qPCR-Biomark contains different R scripts developed to analyze high-throughput qPCR data from Fluidigm Biomark HD.
Normalization to a reference gene is available for both Livak and Pfaffl methods (reference available soon) for TaqMan chemistry and EvaGreen chemistry experiments.


## Principle

pre_process_data.txt contains different information concerning the csv file extracted from Fluidigm Real-Time PCR Analysis software. Procedure to add efficiency values is also described (necessary if working with the Pfaffl's normalization method).

open_data.R is a simple R script with a single command line to open the csv file, remove unused rows, assign type of data per column and which value to consider as NA. Data set may contain unvalid Ct values (Ct value different from 999 but with Fail status). Command lines to replace these values with NA are described.

normalization_livak.R is an R script which performs normalization to a reference gene according to the Livak's method (2^-∆∆Ct - [article](http://www.gene-quantification.de/livak-2001.pdf). In this script, only a ∆Ct between reference gene and target gene is calculated. If you wish to calculate ∆∆Ct between reference group and condition group, please ask for related R script (see contact below).
A function to perform the normalization to multiple reference genes using the geometric mean is also described.

normalization_pfaffl.R is an R script which performs normalization to a reference gene according to the Pfaffl's method [article] (http://www.gene-quantification.de/pfaffl-nar-2001.pdf). In this script, you will need to have added efficiency value for each gene (as described in pre_process_data.txt).

## Get qPCR-Biomark

* Download the program

With *git clone* from the repository
 
```	git clone https://github.com/jpouch/qPCR-Biomark```


## Usage

Coming soon

#### Program

* R 3.2.2 +

#### Third party R packages

* cluster
* Distance
* FactoMineR
* ggplot2
* gtools
* Hmisc
* RColorBrewer

## Authors and Contact

Juliette Pouch - 2015
* <pouch@biologie.ens.fr>  <juliette.pouch@gmail.com>
* [Github](https://github.com/jpouch)
* [Plateforme de qPCR à haut débit de l'IBENS](http://www.ibens.ens.fr/spip.php?rubrique46)
* <qpcr@biologie.ens.fr>
