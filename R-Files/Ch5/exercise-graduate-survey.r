n<-0:9;q<-.795;p<-1-q
windows(width = 3, height = 3, pointsize = 8)
plot(n,q^n*p,type='h',lwd=4,ylim=c(-.01,.35))
abline(h=0,lwd=4)