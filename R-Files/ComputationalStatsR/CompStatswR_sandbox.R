
# Basic plot stuff, comparing distributions
par(mfrow = c(3,3))
x <- runif(10)
plot(sort(x), 1:length(x)/length(x))
abline(0,length(x)/(length(x)+1))
x <- runif(100)
plot(sort(x), 1:length(x)/length(x))
abline(0,length(x)/(length(x)+1))
x <- runif(1000)
plot(sort(x), 1:length(x)/length(x))
abline(0,length(x)/(length(x)+1))
plot(sort(rnorm(10)))
plot(sort(rnorm(100)))
plot(sort(rnorm(1000)))
plot(sort(sin(1:10)))
plot(sort(sin(1:100)))
plot(sort(sin(1:1000)))

# Basic histogram stuff
x <- runif(100)
whist <- hist(x, probability=TRUE)
rug(x)
lines(density(x))

# Monte Carlo Confidence Bands
x <- (sin(1:100)+1)/2						# demo purposes
x <- rnorm(100)
x <- (x - min(x))/(max(x)-min(x))
y <- (1:length(x))/length(x)				# want y on 0-1 scale
nrsamps <- 19								# num of simulations
plot(sort(x), y,							# basic scatter
	main = paste("Monte Carlo Band: ",
		bquote(.(nrsamps)), " Monte Carlo Samples"),
		xlab='x', ylab=expression(F[n]))	# labels and such
samples <- matrix(data=runif(length(x)*nrsamps), 
	nrow=length(x), ncol=nrsamps)			# create a matrix of nrsamp, len(x)
samples <- apply(samples, 2, sort)			# rand uniform samples; sort each of 
envelope <- t(apply(samples, 1, range))		# the samples individually; get the
lines(envelope[,1], y, col="red")			# min and max value at each sample
lines(envelope[,2], y, col="blue")			# position, and then plot as an env

# using Kolmogorov-Smirnov testing:
ks.test(runif(100), punif)
ks.test(runif(100, pnorm))

# chi-squared test
chisq.test(table(data))
chisq.test(hist(data))

# p33, Power Problem
n <- 200
m <- 19
alpha = 0.05
a = 1:10
b = 1:10
test.chi.squ <- function(a,b) {
	samples <- matrix(data=rbeta(N*m, a, b), nrow=N, ncol=m)
	s.hist <- apply(samples, 2, hist, plot=FALSE, breaks=10)
	counts <- lapply(1:length(s.hist), function(x) s.hist[[x]]$counts)
	results <- lapply(1:length(counts), function(x) chisq.test(counts[[x]]))
	results <- lapply(1:length(results), function(x) results[[x]]$p.value)
	return(sum(results < alpha))
	}
	
test.ks <- function(a,b) {
	samples <- matrix(data=rbeta(N*m, a, b), nrow=N, ncol=m)
	results <- apply(samples, 2, ks.test, punif)
	results <- lapply(1:length(results), function(x) results[[x]]$p.value)
	return(sum(results < alpha))
	}
	
chi.results <- matrix(data=0, nrow=4, ncol=4)
ks.results <- matrix(data=0, nrow=4, ncol=4)
for(i in 1:4) { 
	for(j in 1:4) { 
		chi.results[i,j] <- test.chi.squ(i,j)
		ks.results[i,j] <- test.ks(i,j)
	}
}

coutour(chi.results)
contour(ks.results)

# ok, this is a pain in the ass, but necessary for rescaling:
ks.test((shifted.norm-mean(shifted.norm) / max(abs(shift.norm)) * max(abs(rnorm(100)), pnorm)

# I think this works correctly...
new.dist <- runif(1000)
new.dist <- sample(new.dist, 1000) + sample(new.dist, 1000)

# making a tri dist:
tri.dist <- 1
count <- 0
step.size <- .05
for(k in 1:(round(2/step.size)-1)) {
+ new.level <- seq(0+step.size*count/2, 2-step.size*count/2, step.size)
+ tri.dist <- c(tri.dist, new.level)
+ count <- count + 1
+ }

ks.test(new.dist, tri.dist)	#looks like tri dist...fuck

# Quantiles, box and whisker:
oldpar <- par(mfrow = c(1,4))
boxplot(runif(100), main="Uniform")
boxplot(rnorm(100), main="Normal")
boxplot(exp(rnorm(100)), main="LNormal")
boxplot((rcauchy(100)), main="Cauchy")

# make them compariable: (helps to read the damn thing)
r.u <- runif(100)
r.n <- rnorm(100)
r.ln <- exp(rnorm(100))
r.c <- rcauchy(100)
# used to rescale distributions:
q.rescale <- function(sample) {
	sample <- sample - median(sample)
	return(sample / max(abs(sample)))
}
# used to rescale plots
q.range <- function(sample) {
	return(as.numeric(quantile(sample, .75) - quantile(sample, .25)))
}
# shift, norm samples:
r.u.n <- q.rescale(r.u)
r.n.n <- q.rescale(r.n)
r.ln.n <- q.rescale(r.ln)
r.c.n <- q.rescale(r.c)
# compare distrobutions:
y.bounds <- c(-1.3, 1.3)
par(mfrow=c(1,4))
boxplot(r.u.n/q.range(r.u.n), main='U', ylim = y.bounds)
boxplot(r.n.n/q.range(r.n.n), main='N', ylim = y.bounds)
boxplot(r.ln.n/q.range(r.ln.n), main='LN', ylim = y.bounds)
boxplot(r.c.n/q.range(r.c.n), main='C', ylim = y.bounds)

# Test for Theorem 1.1, p22:
n <- 50
n.sample <- rnorm(50)
n.sample <- sort(n.sample)
n.incest <- pnorm(n.sample)
plot(x = n.incest, y = seq(1,n)/(n+1))
abline(a = 0, b = 1 / (n/2*(n+1)))

xx <- rnorm(1)
i <- sum(n.sample<xx)
n.sample[i] < xx
n.sample[i+1] < xx

# ex 1.24 p 38:
n <- 64
p <- 0.5
alpha <- 0.1
X.vec <- sapply(seq(1,n), function(x) pbeta(p, x, n-x+1))
k <- min(which(X.vec < alpha))
j <- max(which(X.vec >= 1-alpha))
bounds.norm <- qnorm(c(j/(n+1), k/(n+1)))
r.n <- rnorm(n)
boxplot(r.n, main='N')
abline(a = bounds.norm[2], b=0)
abline(a = bounds.norm[1], b=0)

# ex 1.25 PP QQ t distribution
xspan <- seq(-3,3,0.1)
pspan <- seq(0.01,0.99,0.02)
oldpar <- par(mfrow = c(1,3))
plot(pt(xspan,1), pnorm(xspan))
plot(pt(xspan,2), pnorm(xspan))
plot(pt(xspan,3), pnorm(xspan))

oldpar <- par(mfrow = c(1,3))
plot(qt(pspan,1), qnorm(pspan))
plot(qt(pspan,2), qnorm(pspan))
plot(qt(pspan,3), qnorm(pspan))

qqplot(qt(pspan,1), qnorm(pspan), ylab='t', xlab='norm')

# cute "test function"
qqnormx <- function(x, nrow=5, ncol=5, main = deparse(substitute(x))) {
	oldpar <- par(mfrow <- c(nrow, ncol))
	qqnorm(x, main = main)
	for (i in (1:nrow*ncol-1)) {
		qqnorm(rnorm(length(x)), main = "N(0,1)", xlab="", ylab="")
	}
	par(oldpar)
}

# prob not how he intended it be done, but...
apply(data.frame(seq(1,length(x),1)),1,function(x) runif(nrow*ncol-1))

# also cute; PP plot with MC bounds
# if no return specified, last computed value object returned
# can use return to select particular obj to return every time
# can use invisible to only return obj of choice when output decleration made
ppdemo <- function(x, samps=19) {
	y <- (1:length(x))/length(x)
	plot(sort(x), y, xlab = substitution(x), ylab = expression(F[n]),
		main = "Dist Func with Monte Carlo Bands (unif.)",
		type = "s")
	mtext(paste(samps, "MC Samples"), side=3)
	samples <- matrix(runif(length(x)*samps),
		nrow = lenght(x), ncol = samps)
	samples <- apply(samples, 2, sort)
	envelope <- t(apply(samples, 1, range))
	lines(envelope[,1], y, type="s", col="red");
	lines(envelope[,2], y, type="s", col="red")
}
# gets distribution info
getdist <- function(dist, type, arg) {
	switch(type,
		   r = getrdist(dist,arg),
		   d = getddist(dist,arg),
		   p = getpdist(dist,arg),
		   q = getpdist(dist,arg))
}

# function for returning a random sample size n from a chosen dist 
getrdist <- function(dist, n) {
	switch(dist,
		   norm = rnorm(n),
		   uniform = runif(n),
		   exp = rexp(n),
		   bi = rbinom(n),
		   poisson = rpois(n),
		   cauchy = rcauchy(n))
}
# as above, only for quantile distribution functions
getqdist <- function(dist, p) {
	switch(dist,
		   norm = pnorm(p),
		   uniform = qunif(p),
		   exp = qexp(p),
		   bi = qbinom(p),
		   poisson = qpois(p),
		   cauchy = qcauchy(p))
}
# shows empherical distribution of chosen distribution, chosen n
eecdf <- function(dist,n) {
	x <- getdist(dist,r,n)
	plot(sort(x), 1:n/n)
	abline(0,1)
}

# plots QQ plot for dist vs. norm
eqqnorm <- function(dist) {
	y <- getdist(dist, q, seq(0.01,0.99,0.01))
	qqnorm(y, main = paste("QQ plot for", dist, "vs. norm"))
}

## Sidenote for plots, p 52-53:  using transparent colors for plotting points
## can allow for features to be exposed through noise when there are many
## data points that may clutter a plot...use rgb(red=, blue=, green=, alpha=)

?parse
?eval
?source
?Sweave