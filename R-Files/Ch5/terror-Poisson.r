rm(list = ls())
load('terror.rda')
(n.breaks <- ceiling((max(terror$Julian) -
  min(terror$Julian)) / 10))
head(cuts <- cut(terror$Julian, n.breaks,
  include.lowest = TRUE), 4)
attacks <- table(cuts)
(a <- table(attacks))
(idx <- as.numeric(names(a)) + 1)
x <- 0 : (max(idx) - 1)
frequency <- rep(0, length(x))
(frequency[idx] <- a)

(lambda <- length(terror[,1]) / n.breaks)

z <- 0 : (length(frequency)-1)
expected <- round(sum(frequency) * dpois(z, lambda), 0)
lets.see <- rbind(attacks = z, frequency = frequency,
  expected = expected)
d <- list()
d[[1]] <- dimnames(lets.see)[[1]]
d[[2]] <- rep('', 15)
dimnames(lets.see) <- d
lets.see

plot(x, frequency, pch = 19, cex = 2, ylim = c(0, 30),
  ylab = 'frequency', xlab = 'attacks per 10 days',
  main = 'suicide attacks on Israelis')
lines(x, dpois(x, lambda) * n.breaks, type = 'h', lwd = 2)
abline(h = 0, lwd = 2)