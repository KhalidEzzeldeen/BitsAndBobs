load('terror.by.Hamas.rda')
terror <- terror.by.Hammas
lambda <- 1 / mean(terror$Killed) ;
gamma <- 1/ mean(terror$Injured) ;
x1 <- 0 : 25
x2 <- 0 : max(terror$Injured)
par(mfrow = c(2,1))
hist(terror$Killed, xlab = 'killed by Hamas', 
	 freq = F, col="red", main = "Density Plot of Deaths by Hamas")
lines(x1, dexp(x1, lambda))
hist(terror$Injured, xlab = 'injured by Hamas', 
	 freq = F, col="blue", main = "Density Plot of Injured by Hamas")
lines(x2, dexp(x2, gamma))