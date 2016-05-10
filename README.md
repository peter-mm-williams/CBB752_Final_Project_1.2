**README for Quality Statistics**
---------------------------------------------------------------

Python tool that generates quality control statistics from FastQ file. A tool that accomplishes this task in the language R can be found [here] (https://github.com/dspak/CBB752_Final_Project_1.2). This tool is part of a set of bioinformatic and biological structure tools created for CBB752 at Yale University in the Spring 2016. The website containing the set of tools can be found [here] (http://cbb752spring2016.github.io).

Python tool that generates quality control statistics from FastQ file. The name of the tool is qualitystats.py. 

### General
The script take one required input (name of the fastq file to be processed) and one optional input (the name of the txt file to which the filename and titles of the corresponding plots are output).  This tool creates png files of the following plots:
  
  * Distribution of Read Lengths
  
  * Per base quality score containing the median, quartiles, mean, and standard deviation
  
  * Distribution of mean quality per sequence

### Usage
  
  #### Usage:      python3 qualitystats.py -i < input file > -o < output file >
  
  #### Examples:  
  ```{r NCBI_python, engine="python", highlight=TRUE}
  # Usage from terminal:
  	     python3 qualitystats.py -i sample-input.fastq -o sample-output.txt
         python3 qualitystats.py -i sample-input.fastq
  ```
  
### Input and Output formats
  
  Input Formats:	
                  
    -i  string of corresponding fastq file
    -o  string containing the name of the file to which the output information is saved

  Output Format:	txt file containing the file name, the number of sequences and the titles of corresponding plots

### Sample Output

Quality Score Statistics and Figure names for sample-input.fastq

Number of Sequences = 100000

For the Distribution of read lengths see: Sequence_Length_Distribution.png

![Fig1](https://github.com/peter-mm-williams/CBB752_Final_Project_1.2/blob/master/Sequence_Length_Distribution.png)

For a plot of the per base quality score see: Per_Base_Sequence_Quality.png

![Fig2](https://github.com/peter-mm-williams/CBB752_Final_Project_1.2/blob/master/Per_Base_Sequence_Quality.png)

For a plot of the distribution of mean quality per sequence see: Per_Sequence_Mean_Quality_Distribution.png

![Fig3](https://github.com/peter-mm-williams/CBB752_Final_Project_1.2/blob/master/Per_Sequence_Mean_Quality_Distribution.png)

