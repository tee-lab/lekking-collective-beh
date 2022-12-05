source('lek-functions.R')

library(ggplot2)
library(ggdark)
library(scico)
library(gganimate)
library(ggimage)

#Declare array to store CurrLocation, NewLocation, DirMovement of individuals

#Parameters
N <- 20 #number of male blackbuck
L <- 5 #size of the lek
T <- 100 #time duration for simulations.
dt <- 0.1 #time step of integration
Omega_r <- 0.25
rr <- 2 #repulsion radius

s0 <- 2
s <- rep(s0,N) #speed

d0 <- 5

#Initialise blackbuck locations
CurrX <- runif(N,-2*L, 2*L)
CurrY <- runif(N,-2*L, 2*L)
NewX <- runif(N,-2*L, 2*L)
NewY <- runif(N,-2*L, 2*L)

theta <- runif(N, -pi, pi)
DirX <- cos(theta)
DirY <- sin(theta)

#Central breeding ground
BreedX <- 5
BreedY <- 5

distBreedOld <- rep(1000,N)

plot(CurrX, CurrY)

#Initiate attraction to the breeding centre -- origin.

for (t in 1:T)
{
  
  #Attraction to the breeding ground
  desdir <- fidelity(CurrX, CurrY, BreedX, BreedY)
  
  #Randomize the directions
  ranDirs <- randomizeDir(desdir$X, desdir$Y, Omega_r) 
  
  for (i in 1:N)
  {
    
    #Check Repulsion    
    netRepDir <- repulsion(i, rr, CurrX, CurrY)
    
    if (netRepDir$rep > 0) { #if repulsion, just repel
      NewX[i] <- CurrX[i] + s[i]*dt*netRepDir$X
      NewY[i] <- CurrY[i] + s[i]*dt*netRepDir$Y
    }
    else { #If no repulision, move as planned.
      NewX[i] <- CurrX[i] + s[i]*dt*ranDirs$X[i]
      NewY[i] <- CurrY[i] + s[i]*dt*ranDirs$Y[i]
    }
  }
  
  CurrX <- NewX
  CurrY <- NewY
  
  print(t)
  plen <- 12
  plot(CurrX, CurrY,xlim = c(-plen,plen),ylim=c(-plen,plen))
  Sys.sleep(0.1)
  
}

#Now implement departure.

bbimage = "/home/arathore/PhD/Analysis/4_Leks/LekPersprctivePaper/Simulations/bb.jpg"

gimage = "/home/arathore/PhD/Analysis/4_Leks/LekPersprctivePaper/Simulations/grass.jpg"

glek = "/home/arathore/PhD/Analysis/4_Leks/LekPersprctivePaper/Simulations/lek.png"


#Food is located at (10,0)
FoodX <- -10
FoodY <- -10

Tf <- 1000
foraging <- rep(0,N) #a bolean variation to know if an individual is foraging
total_foragers <- rep(0,Tf)
Tw <- 250 #Minimum waittime to switch to foraging state.
fstatus <- rep(0,N) #foraging status
pf <- 0.001
rs <-rr+0.3  #rs <- 0 means no social copying of foraging status. 1 means social. int.

foraging[ceiling(runif(1,0,1)*N)] <- 1

df=data.frame(CurrX,CurrY,NewX,NewY,ts=rep(t,N),id=1:N,foraging)


for (t in 1:Tf) {
  
  for (i in 1:N){

    # if the current state is non-foraging and if time since last foraging state > Tw.
    if (foraging[i]==0 && fstatus[i] == 0) {
      
      #individual randomly switches to the foraging state.
      if (runif(1,0,1) < pf ) {
        foraging[i] <- 1
        fstatus[i] <- 1
        print(t)
      }
      else if(rs!=0) { #OR copy foraging status of neighbours
        foraging[i] <- copyforage(i, rs, foraging, CurrX, CurrY)
        if (foraging[i]==1)
          fstatus[i] <- 1
      }
      
    }
    
    netRepDir <- repulsion(i, rr, CurrX, CurrY)
    
    #if repulsion, just repel 
    #repulsion works only in non-foraging state.
    if (netRepDir$rep > 0 && foraging[i]==0) { 
      NewX[i] <- CurrX[i] + s[i]*dt*netRepDir$X
      NewY[i] <- CurrY[i] + s[i]*dt*netRepDir$Y
    }
    
    else { #If no repulsion, move depending on foraging or not.
      
      #if foraging 
      if (foraging[i]==1) {
        attx <- FoodX
        atty <- FoodY
      }
      else #if not foraging
      {
        attx <- BreedX
        atty <- BreedY
      }
      
      #Attraction to the breeding ground
      desdir <- fidelity(CurrX[i], CurrY[i], attx, atty)
      
      #Randomize the directions
      ranDirs <- randomizeDir(desdir$X, desdir$Y, Omega_r) 
      NewX[i] <- CurrX[i] + s[i]*dt*ranDirs$X[i]
      NewY[i] <- CurrY[i] + s[i]*dt*ranDirs$Y[i]
    }
    
    if (foraging[i]==1 && distance(CurrX[i]-FoodX,CurrY[i]-FoodY) < rr) {
      foraging[i] = 0
      print(t)
      print(i)
    }
  }
  
  CurrX <- NewX
  CurrY <- NewY
  
  print(t)
  
  plen <- 12
  # par(mfrow=c(1,2)) 
  # plot(CurrX, CurrY,xlim = c(-plen,plen),ylim=c(-plen,plen))
  # 
  # for (i in 1:N) {
  #   if (fstatus[i]==1 && foraging[i]==1)
  #     points(CurrX[i],CurrY[i],col='red',pch=0)
  #   else if (fstatus[i]==1 && foraging[i]==0)
  #     points(CurrX[i],CurrY[i],col='green',pch=0)
  # }

  total_foragers[t] <- sum(foraging)
  #plot(1:t,total_foragers[1:t],xlim = c(1,T),ylim=c(0,N),pch=1,col='blue') 
  #plot(1:t,total_foragers[1:t],xlim = c(1,t),ylim=c(0,N),pch=1,col='blue',
  #     ylab='Number of foragers', xlab='Time') 
  #Sys.sleep(0.1)
  df1=data.frame(CurrX,CurrY,NewX,NewY,ts=rep(t,N),id=1:N,foraging)
  df=rbind(df,df1)
  

}

anim <- ggplot(
  df, 
  aes(x = CurrX, y=CurrY)
) +
  geom_image(aes(image = bbimage), size = 0.04) +
  geom_point(aes(colour = ifelse(foraging==1,"red","white"),x=CurrX,y=CurrY+1),
             size = 6,shape="^") +
  scale_color_identity()+
  geom_image(aes(image = gimage,x=FoodX,y=FoodY), size = 0.15) +
  xlim(-plen,plen)+
  ylim(-plen,plen)+
  transition_time(ts)+
  theme_bw() +
  theme(legend.position="none")

animate(anim, fps = 5, duration = 30)

plot(1:t,total_foragers[1:t],ylim=c(0,N),pch=23,col='orange2',bg="cyan",lwd=2,cex=2)

