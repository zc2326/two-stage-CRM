
library(dfcrm)

two_stg_crm = function(theta, K, R, n, m, nsim = 5000){
  
  delta <- 0.25*theta
  mu0 <- ceiling(K/2)        
  prior <- getprior(delta, theta, mu0, K) 
  
  x0.temp <- NA
  for (k in 1:(K-1)){
    x0.temp <- c(x0.temp , rep(k, m))
  }
  x0 <- c(x0.temp[-1], rep(K, n-m*(K-1)))      
  
  b <- log(R) 
  
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
  c(theta, K, R, n, m, pcs)
} 


#### Parameter matrix; only considering two variables: theta, K.
theta.candi <- c(rep(0.1,168), rep(0.15, 168), rep(0.20, 168), rep(0.25, 168), rep(0.30, 168), 
                 rep(0.35, 168), rep(0.40, 168), rep(0.45, 168), rep(0.50, 168))

R.candi <-  rep( c(rep(1.25, 28), rep(1.5, 28), rep(1.75,28), rep(2.0, 28) , rep(2.25,28), rep(2.5,28)   )  , 9)

m.candi <- rep(c(rep(1, 7), rep(2, 7),rep(3, 7), rep(4, 7) ) , 54)

n.candi <- rep(c(20, 25, 30, 35, 40, 45, 50), 216)

para <- cbind(theta.candi,R.candi,  m.candi,n.candi)

para.mat = para[which(para[, 4] >= (para[, 3] * 8)), ]
 
args<-commandArgs(TRUE)
currind <-as.integer(args[1])
print(currind)

for (ii in 1:length(theta.candi)){
  if(ii==currind) {
    t <- two_stg_crm( para.mat[ii,1],  8, para.mat[ii,2], para.mat[ii,4], para.mat[ii,3])
  }
}


######## output#######
write.csv(t, file = paste0("eight", currind, ".csv"))

 