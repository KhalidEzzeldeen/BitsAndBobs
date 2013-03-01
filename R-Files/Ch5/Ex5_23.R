n<-100
k<-s<-20
PI<-0.2
set.seed(200)
X<-rnbinom(n,size=s,prob=PI)
m<-mean(X)

h <- function(x,xlab='',ylab='density',main='',...) {
	hist(x,xlab=xlab,main='',freq=FALSE,
	col='grey90',ylab=ylab,...)
}

par(mfrow = c(1,2))
h(X,xlab='count')
x<-0:400
lines(x,dnbinom(x,size=s,prob=PI),lwd=3)
lines(x,dnbinom(x,size=s,mu=m),lwd=3,lty=2,col='red')

plot(ecdf(X),main='',ylab=expression(italic(P(X<=x))))
lines(x,pnbinom(x,size=s,prob=PI),type='s')