PI <- c(0.3, 0.7) ; x <- 0:100
xlab <- expression(italic(x))
par(mfrow = c(1,length(PI)))

#for(i in 1:length(PI)){
#	density <- dgeom(x,PI[i])
#	ylab <- bquote(italic(P(X==x)~~~~~pi) == .(PI[i]))
#	plot(x, density, type = 'h', lwd=2,
#		 xlab = xlab, ylab = ylab)
#	abline(h=0, lwd=2)
#}

for (i in 1:length(PI)){
	d <- pbinom(x,200,PI[i])
	plot(x,d,type = 's',lwd=2,
		 xlab = xlab)
	abline(h=1,lwd=2)
}