fname <- file.choose()              #Acticity scan from one video sample
dat = read.csv(fname, header=TRUE)     #Choose ActSync.csv
#head(dat)


library(ggplot2)

# Activity map for males and females

ggplot(dat, aes(x = Time.Stamp, y = TID, color = Activity, shape = Sex)) +
  geom_jitter(size=4) + 
  scale_y_discrete(limits=seq(1,20,1)) +
  ylab("Territory ID")+
  xlab("Time interval")



## Map for a particular activity

dat1 = dat[(dat$Sex == "M" & dat$Activity == "W") | (dat$Sex == "F"),]

ggplot(dat1, aes(x = x, y = y, color = Time.Stamp,shape=Sex)) +
  geom_jitter(size=4,width=0.2) + 
  scale_y_discrete(limits=seq(1,4,1))+ 
  scale_x_discrete(limits=seq(1,5,1))

dat1 = dat[dat$Activity == "P",]

ggplot(dat1, aes(x = x, y = y, color = Time.Stamp)) +
  geom_jitter(size=4,width=0.2,shape=17) + 
  scale_y_discrete(limits=seq(1,4,1))+ 
  scale_x_discrete(limits=seq(1,5,1))

## Male aggression heat maps -- activity Fight "F" and chasing "C"
dat1 = dat[dat$Activity == "F" | dat$Activity == "C",]

library(reshape)
dmat=tapply(dat1$Time.Stamp,list(dat1$x,dat1$y),length)
df<-melt(dmat)
df[is.na(df)] = 0
colnames(df) <- c("x", "y", "value")

 ggplot(df, aes(x = x, y = y, fill = value)) +
  geom_tile(color = "white",
            lwd = 1.5,
            linetype = 1) +
  coord_fixed()+
  scale_fill_gradientn(colors = hcl.colors(30, "Oslo"))+
  theme(legend.position = "none")

g <- ggplot(dat1, aes(x = x, y = y)) +
  geom_point()
g+ geom_density_2d_filled(alpha = 0.5) +
  geom_density_2d(size = 0.25, colour = "black")+
  theme(legend.position = "none")


## female hotspots
dat2 = dat[dat$Sex == "F",]
m <- ggplot(dat2, aes(x = x, y = y)) +
  geom_point()
m + geom_density_2d_filled(alpha = 0.5) +
  geom_density_2d(size = 0.25, colour = "black")

#  theme(legend.position = "none")

# for(i in 1:nrow(dat)){
#   if((dat$TID[i] %% 5)== 0){
#     dat$x[i] = 5
#   }else{
#     dat$x[i] = dat$TID[i] %% 5
#   }
#   
#   
#   dat$y[i] = ceiling(dat$TID[i]/5)
#   
#   
# }
# View(dat)
# write.csv(x=dat,file="ActSync.csv")