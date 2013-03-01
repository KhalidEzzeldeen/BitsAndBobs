n <- 100 ; k <- sz <- 20 ; PI <- 0.2 ; set.seed(200)
X <- rnbinom(n, size = sz, prob = PI) ; m <- mean(X)
par(mfrow = c(1, 2))
h(X, xlab = 'count')
x <- 0 : 400
lines(x, dnbinom(x, size = sz, prob = PI), lwd = 2)
lines(x, dnbinom(x, size = sz, mu = m), lwd = 2,
  lty = 2, col = 'red')
plot(ecdf(X), main = '', ylab = expression(italic(P(X<=x))))
lines(x, pnbinom(x, size = sz, prob = PI), type = 's')