PI <- c(0.3, 0.7) ; x <- 0 : 10
xlab <- expression(italic(x))
par(mfrow = c(1, 2))
for(i in 1 : 2){
  density <- dgeom(x, PI[i])
  ylab <- bquote(italic(P(X==x)~~~~~pi) == .(PI[i]))
  plot(x, density, type = 'h', lwd = 2,
    xlab = xlab, ylab = ylab)
  abline(h = 0, lwd = 2)
}