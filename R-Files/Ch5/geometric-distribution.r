PI <- c(0.3, 0.7) ; x <- 0 : 10
xl <- expression(italic(x))
par(mfrow = c(1, 2))
for(i in 1:2){
  distr <- pgeom(x, PI[i])
  yl <- bquote(italic(P(X<=x)~~~~~pi) == .(PI[i]))
  plot(x, distr, type = 's', lwd = 2,
    xlab = xl, ylab = yl)
}