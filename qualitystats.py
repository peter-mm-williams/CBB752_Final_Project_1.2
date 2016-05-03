#!/usr/bin/python

__author__ = "Peter Williams"
__copyright__ = "Copyright 2016"
__credits__ = ["Peter Williams"]
__license__ = "GPL"
__version__ = "1.0.0"
__maintainer__ = "Peter Williams"
__email__ = "peter.williams@yale.edu"

### Usage:      python3 qualitystats.py -i <input file> -o <output file>
### Examples:   python3 qualitystats.py -i sample-input.fastq -o sample-output.txt
###				python3 qualitystats.py -i sample-input.fastq
### Note:       	Generates a set of 3 plots and a text file for corresponding fastq file
###					The -o flag is optional
###
### Input Formats:	-i 	string of corresponding fastq file
###			-o	string containing the name of the file to which the output information is saved
### Output Format:	txt file containing the file name, the number of sequences and the titles of corresponding plots

### Import libraries
import argparse
import numpy as np
import matplotlib.pyplot as mp
#import matplotlib as mpl
#rc_defaults=dict(mpl.rcParams)

### This is one way to read in arguments in Python. We need to read input file and score file.
parser = argparse.ArgumentParser(description='Quality Stats Generator')
parser.add_argument('-i', '--input', help='fastq file name', required=True)
parser.add_argument('-o', '--output', nargs='?',default='output.txt', help='Output file name')
args = parser.parse_args()

### Implementation
def qstats(filename,outfile):
	
	############################################################################
	### Create an array of q-scores
	
	### Initialize Variables and load fastq file
	qscores=np.zeros((1,1))
	count=0
	lengths=[]
	f=open(filename,'r')
	### Input quality scores, convert from ascii format, and assign to numpy array
	# 		If length of the reads is not the same, allow for variable length by
	#		making the array of dimension (number of reads)x(length of longest read).
	#		empty entries in the array will be assigned NAN so that stats will not be affected.
	for x in f:
		# If first score line, resize array, assign phred score converted value to last row
		if count==3:
			qscores.resize(1,len(x.strip()))
			qscores[len(qscores[:,0])-1,:]=np.array([int(ord(i)) for i in x.strip()])-33
			lengths.append(len(x.strip()))
		# If score line, resize array, assign phred score converted value to last row
		if count%4==3 and count>3:
			lengths.append(len(x.strip()))
			if len(x.strip())>len(qscores[0,:]):
				maxlen0=len(qscores[0,:])
				maxlen=len(x.strip())
				switch=1
			else:
				switch=0
			qscores.resize(len(qscores[:,0])+1,max(len(x.strip()),len(qscores[0,:])))
			if switch==1:
				qscores[:,maxlen0:maxlen]=np.NAN
			qscores[-1,:]=np.NAN
			qscores[len(qscores[:,0])-1,:]=np.array([int(ord(i)) for i in x.strip()])-33
		count+=1
	f.close()
	
	###########################################################################
	### Make Plots
	f=mp.figure(figsize=(5.2,4.5))
	mp.hist(np.array(lengths))
	mp.ylabel('Number of reads at given ')
	mp.title('Distribution of Sequence Lengths')
	mp.xlabel('Sequence Length (bp)')
	f.tight_layout()
	f.savefig('Sequence_Length_Distribution.png')

	f=mp.figure(figsize=(5.2,4.5))
	mp.errorbar(range(0,101),np.nanmean(qscores,axis=0),yerr=[np.nanstd(qscores,axis=0),np.nanstd(qscores,axis=0)])
	mp.errorbar(range(0,101),np.nanmedian(qscores,axis=0),yerr=[np.nanmedian(qscores,axis=0)-np.nanpercentile(qscores,25,axis=0),-np.nanmedian(qscores,axis=0)+np.nanpercentile(qscores,75,axis=0)])
	mp.xlabel('Position in Read (bp)')
	mp.ylabel('Qaulity Phred Score')
	mp.legend(['Mean and Standard Deviation','Median and Quartiles'],loc=0)
	f.tight_layout()
	f.savefig('Per_Base_Sequence_Quality.png')

	f=mp.figure(figsize=(5.2,4.5))
	mp.hist(np.nanmean(qscores,axis=1))
	mp.ylabel('Frequency of Mean Phred Value')
	mp.title('Sequence Quality Score Distribution')
	mp.xlabel('Mean Phred Score per Sequence')
	f.tight_layout()
	f.savefig('Per_Sequence_Mean_Quality_Distribution.png')
	
	###########################################################################
	### Create output file
	f=open(outfile,'w')
	f.write('Quality Score Statistics and Figure names for %s' %filename)
	f.write('\n\n')
	f.write('Number of Sequences = %d' %len(qscores[:,0]))
	f.write('\n\n')
	f.write('For the Distribution of read lengths see: Sequence_Length_Distribution.png')
	f.write('\n\n')
	f.write('For a plot of the per read quality see: Per_Base_Sequence_Quality.png')
	f.write('\n\n')
	f.write('For a plot of the distribution of mean quality per sequence see: Per_Sequence_Mean_Quality_Distribution.png')
	f.close()
	
### Run
qstats(args.input, args.output)

