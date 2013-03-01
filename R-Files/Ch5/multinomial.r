n <- 1000 ; hab <- LETTERS[1 : 6] ; m <- 6
PI <- c(0.1, 0.2, 0.3, 0.2, 0.1, 0.1)
set.seed(100) ; nqd((d <- rmultinom(1, n,  PI)))
(df <- data.frame(habitat = hab, observed = d, PI,
  expected = round(n * PI, 3)))

plot(df$habitat, df$expected, ylim = c(0, 300),
  xlab = 'habitat', ylab = 'multinomial frequencies')
points(df$habitat, df$observed, pch = 20, cex = 3)