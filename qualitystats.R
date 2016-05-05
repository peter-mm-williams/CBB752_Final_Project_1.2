#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title :  qualitystats.R 
# Version : 1.0
#
# Purpose : A tool that outputs standard QC metrics and figures for fastq files
#  
# Version Notes : 
#
# Created.date  : 27 Apr 2016
# Created.by    : Dan Spakowicz
# Updated.date  :  
# Updated.by    : 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Usage:      Rscript qualitystats.R -i <input file> -o <output file>
### Examples:   Rscript qualitystats.R -i sample-input.fastq -o sample-output.txt
###				Rscript qualitystats.R -i sample-input.fastq
### Note:       	Generates a set of 3 plots and a text file for corresponding fastq file
###					The -o flag is optional
###
### Input Formats:	-i 	string of corresponding fastq file
###			-o	string containing the name of the file to which the output information is saved
### Output Format:	txt file containing the file name, the number of sequences and the titles of corresponding plotsgenes

rm(list=ls())

# Load the required packages

if(!require(ShortRead)){
  source("http://bioconductor.org/biocLite.R")
  biocLite("ShortRead")
  library(ShortRead)
}
library(ShortRead)

list.of.packages <- c("optparse")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library(optparse)


# set arguments
option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL, 
              help="fastq file name", metavar="character"),
  make_option(c("-o", "--out"), type="character", 
              default="output_R.txt", 
              help="output file name [default= %default]", metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

# DS start of code

# [[Notes from Mtg]] :: Outputs 
# File name
# 1) Total sequences
# 2) sequence length dist figure
# 3) per base sequence quality figure is really nice
# ILMN v1.3+ encoding
# position in read where <Q20 
# 
# 4) Mean quality score histogram
# 
# 
# per base sequence quality scores
# sequence quality distribution
# sequence length distribution
# 
# send around a fastq file 