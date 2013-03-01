set.seed(101)
n.S <- ifelse(runif(1,0,1) <0.25, 1, 0)
p <- vector()
p[1] <- n.S
for (n in 2 : 10000) {
	n.S <- n.S + ifelse(runif(1,0,1) < 0.25, 1, 0)
	p[n] <- n.S / n
}

#p <- cumsum(ifelse(runif(1,0,1) < 0.25, 1, 0)) / (1:10000)

plot(p,type = 'l', ylim = c(0,0.3),
	 xlab = expression(italic(n)), ylab = expression(italic(p)))
abline(h = 0.25)