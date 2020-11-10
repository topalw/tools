setwd('C://Users/Alexandros/Desktop/Insular-genomics/Analyses/Stats/')
set1 = c('#EFA120', '#995C1F', '#3865A6', '#079CC4', '#57AF94', '#A6E23D', '#FFE040', '#59436C')
pop <- as.factor(c(rep(c('AE','CT','CY','GR','IO','IS','IT'),c(11,11,10,10,5,9,9))))
#tmp <- read.table('../coords.csv', sep=',', header=T)
#samples <-as.character(tmp[,1])
#tab <- data.frame('pop'=pop, 'sampleID'=samples)

gen_matrix <- snpgdsGetGeno('perfect_unpruned.gds') #name of input gds file
# the positions data.frame has 3 information columns and 4 to be filled by the script
# pop is the name of the populations, the start and finish indicate the index that individuals
# from said population appear in the gds (or vcf file). 
positions <- data.frame('pop'=unique(pop), 'start'=c(1,12,23,33,43,48,57), 'end'=c(11,22,32,42,47,56,65),
                        'mean_he'=rep(0,7), 'mean_ho'=rep(0,7), 'sd_he' = rep(0,7), 'sd_ho'=rep(0,7))

for(k in 1:nrow(positions)){
    he = rep(NA, dim(gen_matrix)[2])
    ho = rep(NA, dim(gen_matrix)[2])
  for(i in 1:dim(gen_matrix)[2]){
    sub_col <- gen_matrix[positions$start[k]:positions$end[k],i]
    nas <- sum(is.na(sub_col))
    total = positions$end[k] - positions$start[k] + 1 - nas
    hom = length(which(sub_col == 0))
    het = length(which(sub_col == 1))
    p = (2*hom + het)/(2*total)
    ho[i] = het / total
    he[i] = 2 * p* (1- p )
  }
    positions$mean_he[k] <- mean(he, na.rm = T)
    positions$mean_ho[k] <- mean(ho, na.rm = T)
    positions$sd_he[k] <- sd(he, na.rm = T)
    positions$sd_ho[k] <- sd(ho, na.rm = T)
}  

write.csv(positions, file='heterozygosity.csv')
 
