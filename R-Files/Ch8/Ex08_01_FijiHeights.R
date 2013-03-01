INF = 10000
x <- seq(120,240,length=INF)
y <- dnorm(x,180,10)
plot(x,y,type='l', xlab = 'x', ylab = 'density')
abline(v=180,lwd=2,col='blue')

N=501; n=30
set.seed(79) ; population <- rnorm(N,180,10)
abline(v = mean(population),lwd=4,col='red',lty=2) 

X <- sample(population,n)
abline(v=mean(X), lty=3)