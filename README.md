# tools
This is a description of the scripts in the _tools_ directory  

1. polarizing.py  
This script finds the ancestral allele based on a single outgroup individual in a vcf and modifies the info field of the vcf to include the AA: field.  

* It requires 3 input statements 
    + The input filename
    + The output filename
    + The name of the outgroup individual  
    
The script assumes that the individual is an outgroup to all other samples in the vcf as such:  

(OUTGROUP(Samples))  

In that case when the Outgroup is homozygous for an allele then this allele is assumed to be the ancestral. If the outgroup is heterozygous we don't really care because we only get information for the ancestal allele if all samples are homozygous. In that case the ancestral allele is the allele missing but for analyses that require polymorphic sites the information for the samples is missing (non-variant site). We use this script as a filtering step before executing the fastSIMCOAL2 software [link](http://cmpg.unibe.ch/software/fastsimcoal2/)  

2. pop_heterozygosity.r  
A simple non-optimized script to calculate Heterozygosity from a gds file. Modifying variables in the script adapts the script to data. Calculates the heterozygosity of the population per site.

3. private-alleles.r  
A simple function in R that calculates private alleles from a gds file using the genotype matrix. Quite annotated. Used in "Genomic consequences of colonisation, migration and genetic drift in barn owl insular populations of the eastern Mediterranean".

4. ind_heterozygosity.r 
A simple script to calculate the heterozygosity of each individual and plot it per population. Used in "Genomic consequences of colonisation, migration and genetic drift in barn owl insular populations of the eastern Mediterranean"

