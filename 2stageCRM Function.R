
#####################################################
#   R code for one set of parameters
#            First simulation       
#            2016/11/25
#####################################################

library(dfcrm)
rm(list=ls())

####################   Setting  ###################
# theta - The target DLT rate
#     K - Number of dose level
#     R - Effect size(Odds Ratio)
#     n - Sample size of the trial
#     m - cohort size
#  nsim - number of simulations
# delta - halfwidth of the indifference intervals

theta <- 0.10
K <- 4 
R <- 1.25
n <- 20
m <- 3

nsim <- 20
delta <- 0.25*theta
###############################################


############## Other Arguments ################
#    mu0 - The prior guess of MTD
#  prior - initial guesses of toxicity probabilities
#     x0 - initial design
#   beta - log odds ratio

# prior
mu0 <- ceiling(K/2)       # mu0 = K/2 for even K; mu0 = (K+1)/2 for odd K
prior <- getprior(delta, theta, mu0, K) 

# x0:  get x0 from m, n, K
x0.temp <- NA
for (k in 1:(K-1)){
  x0.temp <- c(x0.temp , rep(k, m))
  }
x0 <- c(x0.temp[-1], rep(K, n-m*(K-1)))      

#beta
b <- log(R)     
###############################################


############# crmsim simulation ###############
#    a - alpha
#    k - an indicator
# PI_k - True toxicity probabilites (in the scenario that dose k is MTD)
# obj_k$MTD - Probability that this dose is selected
 

## Dose level k is MTD:
k <- c(1:K)
temp <- (log(theta/(1-theta)))
PI <- matrix(NA, nrow = K, ncol = K, byrow = T)

for (i in 1:K){
  a <- temp - b*i
  PI[i,] <- exp(a+b*k)/(1+exp(a+b*k))
}

pcs <- rep(NA, K)
for(k in 1:K){
pcs[k] <- crmsim(PI[k,], prior, theta, n, x0, nsim)$MTD[k]
}

############## output  ##################

c(theta, K, R, n, m, pcs)






# check

# Dose level 1 is MTD:
# a <- (log(theta/(1-theta))) - b*1  
# k <- c(1:K)                        
# PI <- exp(a+b*k)/(1+exp(a+b*k))    

# obj1 = crmsim(PI, prior, theta, n, x0, nsim)    # ?no m here?
# obj1$MTD                           


# obj1 = crmsim(PI[1,], prior, theta, n, x0, nsim)
# obj2 = crmsim(PI[2,], prior, theta, n, x0, nsim)
# obj3 = crmsim(PI[3,], prior, theta, n, x0, nsim)
# obj4 = crmsim(PI[4,], prior, theta, n, x0, nsim)
# obj1$MTD[1]
# obj2$MTD[2]
# obj3$MTD[3]
# obj4$MTD[4]


 