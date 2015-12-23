maxthreshold <- function(data,nsim=2,IP=2,method='deterministic',
                         parms,thresholdmin=2,thresholdmax=20,printon=FALSE){
  
  threshvec <- seq(thresholdmin,thresholdmax,1)
  rvec <- rep(0,length(threshvec))
  for(it in 1:length(rvec)){
    
    if(printon == T){
      print(sprintf('trying threshold=%d',threshvec[it]))
    }
    res <- simulatetsir(data, nsim = nsim, IP=IP,
                        parms=parms,
                        method=method,
                        epidemics='break', pred ='forward',
                        threshold=threshvec[it],
                        add.noise.sd = 0, mul.noise.sd = 0)
    
    obs <- res$res$cases
    pred <- res$res$mean
    
    fit <- lm(pred ~ obs)
    r.squared <- summary(fit)$r.squared 
    rvec[it] <- r.squared
    
    if(printon == T){
      print(sprintf('resulting Rsquared is %f',r.squared))
    }
  }
  
  threshold <- threshvec[which.max(rvec)]
  return(threshold)
  
  
}
