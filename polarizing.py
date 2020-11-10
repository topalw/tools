#!/usr/bin/env python3

import sys
import os.path

### CHECKS ###
if len(sys.argv) != 4: #check input
	exit('Argument 1 should be the input vcf file, argument 2 the vcf file to create, argument 3 the name of the outgroup population')

if os.path.isfile(sys.argv[1]) == False : #check if file exists
	exit('input file not found')

### GLOBALS ###
infile = open(sys.argv[1], 'r') #open file to read
outfile = open(sys.argv[2], 'w') #open file to write

### GIST ###
for line in infile: 
	if line[:2] == '##': #write header lines
		outfile.write(line)
	elif line[:2] == '#C': #sample line
		linelist = line.rstrip().split('\t') #rstrip() to make sure it is found if its the last
		try: #get index of outgroup
			outindex = linelist.index(sys.argv[3]) 
		except ValueError:
			exit('Outgroup not found')
		outfile.write(line) #write line
	else:
		linelist = line.split('\t') #get splitted vcf line to use later
		tmp = linelist[outindex] #get correct column for outgroup genotype
		out = tmp.split(':')[0] #get genotype
		if out == '0/0': #outgroup homozygous for the reference == ancestral
			ref = linelist[3] #get ref allele 
			info = linelist[7] #get info field 
			info = 'AA:' + ref + ';' + info  #add AA info into info field
			linelist[7] = info #change line
			outfile.write('\t'.join(linelist)) #paste list together and write
		elif out == '1/1': #outgroup homozygous for the alternative == ancestral
			alt = linelist[4]
			info = linelist[7]
			info = 'AA:' + alt + ';' + info
			linelist[7] = info 
			outfile.write('\t'.join(linelist))

### GOOD PRACTICE ###
infile.close()
outfile.close()
