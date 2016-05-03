**README for CBB752_Final_Project_1.2**
---------------------------------------------------------------
Tool that generates “quality control statistics” from FastQ file.

Note: This tool is part of a set of bioinformatic and biological structure tools created for CBB752 at Yale University in the Spring 2016. The website containing links to the set of tools can be found at: https://github.com/CBB752Spring2016/CBB752Spring2016.github.io

# The python tool that accomplishes this task is named qualitystats.py

## General
qualitystats.py takes one required input (name of the fastq file to be processed) and one optional input (the name of the txt file to which the filename and titles of the corresponding plots are output).  This tool creates png files of the following plots:
  
  * Distribution of Read Lengths
  
  * Per base quality score containing the median, quartiles, mean, and standard deviation
  
  * Distribution of mean quality per sequence

## Usage
  
  Usage:      python3 qualitystats.py -i < input file > -o < output file >
  
  Examples:  
  ```{r NCBI_python, engine="python", highlight=TRUE}
  # Usage from terminal:
  	     python3 qualitystats.py -i sample-input.fastq -o sample-output.txt
         python3 qualitystats.py -i sample-input.fastq
  ```
  
## Input and Output formats
  
  Input Formats:	
                  
                  -i  string of corresponding fastq file
                  -o  string containing the name of the file to which the output information is saved

  Output Format:	txt file containing the file name, the number of sequences and the titles of corresponding plots

## Sample Output


![Fig1](https://github.com/peter-mm-williams/CBB752_Final_Project_1.2/blob/master/Sequence_Length_Distribution.png)

