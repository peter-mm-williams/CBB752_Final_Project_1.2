#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Title :  QCmetrics_fastq.R 
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

# Usage:      Rscript QCmetrics_fastq.R /path/to/inputfile.gct /path/to/outputfile.csv
# Example:    example line
# Note:       Input: fastq file, which is a text file with 1st row = header
#             
#           
#             Output: a csv. of pairwise gene interactions, Pearson R values, and p-values, comma-delimited
#
#             example.gct: constructed from all_aml_train.gct, remove 2 header lines, keep first 10 genes


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