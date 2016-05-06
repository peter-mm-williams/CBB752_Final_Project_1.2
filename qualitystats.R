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

# remove any previously loaded functions
rm(list=ls())

# suppress warnings
oldw <- getOption("warn")
options(warn = -1)

# Load the required packages
list.of.packages <- c("optparse", "reshape2", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library(optparse)
library(reshape2)
library(ggplot2)

if(!require(ShortRead)){
  source("http://bioconductor.org/biocLite.R")
  biocLite("ShortRead")
  library(ShortRead)
}
library(ShortRead)


# set arguments
option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL, 
              help="fastq file name", metavar="character"),
  make_option(c("-o", "--out"), type="character", 
              default="output_R", 
              help="output file name [default= %default]", metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

#######
# create function for generating quality assessment plots
#######

QualityStats <- function(infile, outfile) {
  
  # input and process using shortRead
  input <- readFastq(infile)
  
  # scores for each nucleotide
  scores <- data.frame(as(quality(input), "matrix"))
  
  # lengths of each read
  lengths <- data.frame(apply(scores, 1, function(x) length(which(!is.na(x)))))
  
  #average quality score per nucleotide for each read
  ave.score <- (alphabetScore(input))/lengths
  
  #plot a histogram of the average quality score of each read
  ggplot(ave.score, aes(ave.score))+
    geom_histogram() +
    labs(x = "Quality Score",
         y = "Number of Reads",
         title = "Average Quality Scores for each Read")
  ggsave(paste(outfile, "_qual_hist.png", sep = ""))

  
  # plot a histogram of the average length of each read
  ggplot(lengths, aes(lengths))+
    geom_histogram()+
    labs(x = "Length",
         y = "Number of Reads",
         title = "Read Lengths")
  ggsave(paste(outfile, "_length_hist.png", sep = ""))
  
  
  # convert to long format for plotting boxplots by position
  m.scores <- melt(scores, na.rm = T)
  
  # calculate the means for each position  
  means <- data.frame(colMeans(scores, na.rm = T))
  means$id <- row.names(means)
  colnames(means) <- c("means", "id")
  
  # join the means with the long format data
  m.scores.means <- merge(m.scores, means, by.x = "variable", by.y = "id", all =T)
  colnames(m.scores.means) <- c("Position", "value", "means")
  m.scores.means$Position <- gsub("X", "", m.scores.means$Position)
  m.scores.means$Position <- as.integer(m.scores.means$Position)
  m.scores.means <- m.scores.means[order(m.scores.means$Position),]
  
  # plot boxplots of read qualities by position
  ggplot(m.scores.means, aes(x = factor(Position), y = value)) +
    geom_boxplot(fill = "green", outlier.size = 0) +
    geom_line(aes(x = Position, y = means, color = "Mean"), size = 1) +
    labs(x = "Position", y = "Quality Score", 
         title = "Read Quality Scores for each Position")+
    theme(axis.text.x = element_text(angle = 45),
          legend.position = c(0.9, 0.2), 
          legend.background = element_rect(color = "black", size = 1, linetype = "solid"))+
    scale_x_discrete(breaks = c(seq(1, nrow(means), by = 4)))+
    scale_color_manual("", values=c(Mean="red"))
  ggsave(paste(outfile, "_perBase_qual.png", sep = ""))
  
  
  # write summary text file 
  fileOut<-file(paste(outfile, ".txt", sep=""))
  writeLines(c(paste("Quality Score Statistics and Figure names for ", infile, sep=""),
               "",
               paste("Number of Sequences = ", nrow(scores), sep=""),
               "",
               paste("For the Distribution of read lengths see: ", outfile, "_length_hist.png", sep = ""),
               "",
               paste("For a plot of the per base quality score see: ", outfile, "_perBase_qual.png", sep = ""),
               "",
               paste("For a plot of the distribution of mean quality per sequence see: ", outfile, "_qual_hist.png", sep = "")),
             fileOut)
  close(fileOut)
}

QualityStats(opt$input, opt$out)

# return warning setting
options(warn = oldw)