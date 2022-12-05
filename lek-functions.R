#Functions for the lek model

distance <- function(x,y)
{
  sqrt(x^2 + y^2)
}

repulsion <- function (i, rr, CurrX, CurrY)
{
  for (j in 1:N)
  {
      alldist <- distance (CurrX-CurrX[i], CurrY-CurrY[i])    
      
      rep <- 0 # A bolean variable to indicate if repulsion happens.
      
      #indices of individuals within repulsion zone
      repind <- which(alldist>0 & alldist<rr)
      
      if(length(repind)>0){
      #each repulsion direction
      repDirsX <- CurrX[i] - CurrX[repind] 
      repDirsY <- CurrY[i] - CurrY[repind]
      
      magrep <- sqrt(repDirsX^2 + repDirsY^2)
        
      repDirsX <- repDirsX/magrep
      repDirsY <- repDirsY/magrep
      
      #print(distance(repDirsX^2+repDirsY^2))
      
      netRepDirX <- sum(repDirsX)
      netRepDirY <- sum(repDirsY)
      
      magnetrep <- sqrt(netRepDirX^2 + netRepDirY^2)
      
      netRepDirX <-  netRepDirX / magnetrep
      netRepDirY <-  netRepDirY / magnetrep
      rep = 1 #A bolean var to know if there was repulsion
      }
      else {
        netRepDirX <- 0
        netRepDirY <- 0
        rep = 0 #A bolean var to indicate no repulsion
      }
      
      return(list(rep=rep,X=netRepDirX,Y=netRepDirY))
      
  }
}

social <- function (i, rs, CurrX, CurrY, DirX, DirY, OmegaA, OmegaO)
{
  for (j in 1:N)
  {
    alldist <- distance (CurrX-CurrX[i], CurrY-CurrY[i])    
    
    soc <- 0 # A bolean variable to indicate if social int happens.
    
    #indices of individuals within social zone
    socind <- which(alldist>0 & alldist<rs)
    
    if(length(socind)>0){
      #each attraction direction
      attDirsX <- CurrX[socind] - CurrX[i]
      attDirsY <- CurrY[socind] - CurrY[i] 
      
      magatt <- sqrt(attDirsX^2 + attDirsY^2)
      
      attDirsX <- attDirsX/magatt
      attDirsY <- attDirsY/magatt
      
      netAttDirX <- sum(attDirsX)
      netAttDirY <- sum(attDirsY)
      
      magnetatt <- sqrt(netAttDirX^2 + netAttDirY^2)
      
      netAttDirX <-  netAttDirX / magnetatt
      netAttDirY <-  netAttDirY / magnetatt
      
      #Alignment
      
      alinDirX <- sum(DirX)
      alinDirY <- sum(DirY)
      
      magalin <- sqrt(alinDirX^2 + alinDirY^2)
      
      netAlinDirX <-  alinDirX / magalin
      netAlinDirY <-  alinDirY / magalin
      
      #Stochasticity
      #theta <- runif(1, -pi, pi)
      #noiseDirX <- cos(theta)
      #noiseDirY <- sin(theta)
      
      #Social Direction
      SocDirX <- OmegaA*netAttDirX + OmegaO*netAlinDirX #+ (1-OmegaA-OmegaO)*noiseDirX
      SocDirY <- OmegaA*netAttDirY + OmegaO*netAlinDirY #+ (1-OmegaA-OmegaO)*noiseDirY
      
      magsoc <- sqrt(SocDirX^2 + SocDirY^2)
      
      netSocDirX <-  SocDirX / magsoc
      netSocDirY <-  SocDirY / magsoc
      
    }
    else {
      netSocDirX <- 0
      netSocDirY <- 0
      soc = 0 #A bolean var to indicate no repulsion
    }
    
    return(list(soc=soc,X=netSocDirX,Y=netSocDirY))
    
  }
}

fidelity <- function(x, y, BreedX, BreedY)
{
  
  DirDesX <- BreedX - CurrX
  DirDesY <- BreedY - CurrY
  distBreed <- sqrt(DirDesX^2+DirDesY^2)
  DirDesX <- DirDesX/distBreed
  DirDesY <- DirDesY/distBreed
  
  return(list(X=DirDesX, Y=DirDesY))
  
}

randomizeDir <- function(dirx, diry, Omega_r)
{
  N <- length(dirx)
  
  #random angles and directions
  theta <- runif(N, -pi, pi)
  DirRandX <- cos(theta)
  DirRandY <- sin(theta)
  
  #weight the original direction with the random direction
  DirX <- dirx + Omega_r*DirRandX
  DirY <- diry + Omega_r*DirRandY
  norm <- sqrt(DirX^2 +DirY^2)
  DirX <- DirX/norm
  DirY <- DirY/norm
  
  return(list(X=DirX, Y=DirY))

}

copyforage <- function(i, rs, foraging, CurrX, CurrY)
{
  n<-10
  
  alldist <- distance (CurrX-CurrX[i], CurrY-CurrY[i])    

  #indices of individuals within social zone
  socind <- which(alldist>0 & alldist<rs)
  
  prob_foraging <- sum(foraging[socind])/n

  #with a probability, switch to foraging
  if (runif(1,0,1) < prob_foraging)
    foraging[i] <- 1
  
  return(foraging[i])
}