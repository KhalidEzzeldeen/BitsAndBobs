load('terror.rda')
(n.breaks <- ceiling((max(terror$Julian) - 
	min(terror$Julian)) / 10))
cuts <- cut(terror$Julian,n.breaks,include.lowest=T)
attacks <- table(cuts)
a <- table(attacks)
idx <- as.numeric(names(a)) + 1
x <- 0:(max(idx)-1)
frequency[idx] <- a
frequency <- rep(0,length(x))

lambda <- length(terror[,1])/n.breaks			#get estimate of Lam from data, assuming Poisson 
z <- 0: (length(frequency)-1)
expected <- round(sum(frequency)*dpois(z,lambda),0)
lets.see <- rbind(attacks = z,frequency = frequency,expected = expected)
d<-list()
d[[1]] <- dimnames(lets.see)[[1]]
d[[2]] <- rep('',15)
dimnames(lets.see) <- d

plot(x,frequency,pch=19,cex=1.5,ylim=c(0,30),
	 ylab='frequency',xlab='attacks per 10 days',
	 main='suicide attacks on Israelis')
lines(x, dpois(x,lmabda)*n.breaks)