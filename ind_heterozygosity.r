pop <- as.factor(c(rep(c('AE','CT','CY','GR','IO','IS','IT'),c(11,11,10,10,5,9,9)))) #pop code for each ind
set1 = c('#EFA120', '#995C1F', '#3865A6', '#079CC4', '#57AF94', '#A6E23D', '#FFE040', '#59436C') # colours
#packages
library(SNPRelate)
library(ggplot2)

gen.table <- snpgdsGetGeno('../final_unpruned.gds') #genotype table

gds <- snpgdsSummary('../final_unpruned.gds')
samples <- gds$sample.id #sample names

ind_het <- function(ind_geno){
  ones <- sum(ind_geno == 1, na.rm = T)
  tots <- length(ind_geno) - sum(is.na(ind_geno))
  ones / tots 
}

heterozygosity <- apply(gen.table, 1, ind_het) # apply for each individual
dat <- data.frame('Population'=pop, 'het'=heterozygosity, 'sample'=samples) #make data.frame

#plot
plot <- ggplot(data = dat, mapping = aes(x=Population, y=het, fill=Population)) + geom_boxplot() +
  scale_fill_manual(values=set1) + ylab('Observed heterozygosity') + xlab('Population') + 
  theme_minimal()
pdf('ind_heterozygosity.pdf')
print(plot)
dev.off()
