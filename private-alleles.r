
pop <- as.factor(c(rep(c('AE','CT','CY','GR','IO','IS','IT'),c(11,11,10,10,5,9,9)))) #you dont really have to do that just have a population vector
 
require(SNPRelate)
gen_mat <- snpgdsGetGeno('perfect_unpruned.gds') # change name to your gds to get Genotable

### position indexes for populations ### START AND END are their indexes in the Genotable or the header of the vcf pre-gds 
positions <- data.frame('pop'=unique(pop), 'start'=c(1,12,23,33,43,48,57), 'end'=c(11,22,32,42,47,56,65))
#this will tell the function where each population is in row indexes of the genomatrix

count_priv_all <- function(column, start, finish){
  pallele = rep(F,10) # the number 10 is the number of samplings the function will perform to get a mean and SD
  others <- column[-c(start:finish)] #non-population individuals 
  total <- length(others) - sum(is.na(others)) # some might be NAs, remove from calc
  for(i in 1:10){
  sampled_ind <- column[c(sample(start:finish, size=5, replace=F))] #sample=5 , you can change that to the smallest sample size
  total_sampled_ind <- 5 - sum(is.na(sampled_ind)) #remove NAs!
  if(total_sampled_ind == 0){ #FUCK
      print('Only NAs in sample')
      next
    } else {
      if(sum(others,na.rm=T)==0 & sum(sampled_ind,na.rm=T)!=0){ #All the others have full 0s and we have sth else 
        pallele[i] = T 
      }else if (sum(others,na.rm=T) == 2*total & sum(sampled_ind,na.rm=T) != 2*total_sampled_ind){ # All the others have full 2s and ours have sth else
        pallele[i] = T
        }
     }
  }
  return(pallele)
}
matrix1 <- matrix(NA, nrow=0, ncol=10) #make matrix 
for(i in 1:length(unique(pop))){ # loop the function for each pop
    print(i)
    matrix1 <- rbind(matrix1, rowSums(apply(gen_mat,2, function(x) {count_priv_all(x,positions$start[i],positions$end[i])}),na.rm=T) )
  }
write.table(matrix1, file='Private_alleles.table')
