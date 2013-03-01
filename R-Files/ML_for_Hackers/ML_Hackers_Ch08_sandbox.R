library('lubridate')
library('reshape')
library('ggplot2')

prices <- read.csv('/Users/sinn/ML_for_Hackers/08-PCA/data/stock_prices.csv')
prices <- transform(prices, Date=ymd(Date))
date.stock.matrix <- cast(prices, Date ~ Stock, value = 'Close')
summary(date.stock.matrix)		# shows there are NA's in data

# Remove dates with missing data: (they remove a date and a stock..)
prices <- subset(prices, Date != ymd('2002-02-01'))
prices <- subset(prices, Date != ymd('2005-06-22'))
date.stock.matrix <- cast(prices, Date~Stock, value='Close')

# grab the correlation matrix, plot values as dist plot
cor.matrix <- cor(date.stock.matrix[,2:ncol(date.stock.matrix)])
correlations <- as.numeric(cor.matrix)
# from the plot, we can see that there are a significant number of 
# positive, non-zero values (mode is around 0.5, though it is double
# peaked, with a smaller one at about 0 / 0.25 as expected (?))
ggplot(data.frame(Correlation = correlations), 
		aes(x = Correlation, fill = 1)) +
	geom_density() +
	opts(legend.position = 'none')
	
# do PCA, no dates, only data...
pca <- princomp(date.stock.matrix[,2:ncol(date.stock.matrix)])
# typing 'pca' give summary; mine is diff than book's bc I removed
# different things when cleaning data; mine has an extra variable,
# but 1 less obervation per variable; overall, more data points
# in mine

principal.component <- pca$loadings[,1]	#mostly negative; scaling issue?
loadings <- as.numeric(principal.component)
# there are only 25 values here...
ggplot(data.frame(Loading = loadings),
	   aes(x = Loading, fill = 1)) +
	geom_density() +
	opts(legend.position = 'none')
	
# prediction...some type of average for the data set?
# this is a 1 by 2365 vector
market.index <- predict(pca)[,1]

# Load DJI prices for comparison, get approp sample:
dji.prices <- read.csv('/Users/sinn/ML_for_Hackers/08-PCA/data/DJI.csv')
dji.prices <- transform(dji.prices, Date = ymd(Date))
dji.prices <- subset(dji.prices, Date > ymd('2001-12-31'))
dji.prices <- subset(dji.prices, Date != ymd('2002-02-01'))
dji.prices <- subset(dji.prices, Date != ymd('2005-06-22'))
# grab data we want:
dji <- with(dji.prices, rev(Close))
dates <- with(dji.prices, rev(Date))
# do comparison, plot
comparison <- data.frame(Date = dates, MarketIndex = market.index, DJI = dji)
ggplot(comparison, aes(x = MarketIndex, y = DJI)) +
	geom_point() +
	geom_smooth(method = 'lm', se = FALSE)
# to reverse '-' components..., replot
comparison <- transform(comparison, MarketIndex = -1 * MarketIndex, DJI = dji)

# rescale, separate data to make comparisons..
comparison <- transform(comparison, comparisonMarketIndex = scale(MarketIndex))
comparison <- transform(comparison, comparisonDJI = scale(DJI))
alt.comparison <- melt(comparison, id.vars = 'Date', measure.vars = c('comparisonMarketIndex', 'comparisonDJI'))
names(alt.comparison) <- c('Date', 'Index', 'Price')

p <- ggplot(alt.comparison, aes(x = Date, y = Price, group = Index, color = Index)) + 
	geom_point() +
	geom_line()
	
$ use 2 components (I think it works this way...)
market.index.2 <- predict(pca)[,1] + predict(pca)[,2]
comparison.2 <- data.frame(Date = dates, MI = market.index.2, DJI = dji)
comparison.2 <- transform(comparison.2, cMI = -scale(MI))
comparison.2 <- transform(comparison.2, cDJI = scale(DJI))
alt.comparison.2 <- melt(comparison.2, id.vars = 'Date', measure.vars = c('cMI', 'cDJI'))
names(alt.comparison.2) <- c('Date', 'Index', 'Price')
p.2 <- ggplot(alt.comparison.2, aes(x = Date, y = Price, group = Index, color = Index)) + 
 	geom_point() +
 	geom_line()
print(p.2)

# compare results (error > error.2)
error <- sum((comparison$comparisonMarketIndex - comparison$comparisonDJI)^2)
error.2 <- sum((comparison.2$cMI - comparison.2$cDJI)^2)