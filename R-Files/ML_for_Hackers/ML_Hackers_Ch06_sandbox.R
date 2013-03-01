library(ggplot2)

set.seed(1)

# clearly non-linear data set...
x <- seq(-10, 10, by=0.01)
y <- 1 - x^2 + rnorm(length(x), 0, 5)
ggplot(data.frame(X = x, Y = y), aes(x = X, y = Y)) + geom_point() + geom_smooth(se = FALSE)

# try to make it linear, fit a line to it
ggplot(data.frame(Xsq = x^2, Y = y), aes(x = Xsq, y = Y)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

#Poly regression:
set.seed(1)

# Make a nice rando sine plot...
x <- seq(0, 1, by = 0.01)
y <- sin(2 * pi * x) + rnorm(length(x), 0, 0.1)

df <- data.frame(X = x, Y = y)

# see how well a linear fit does..
summary(lm(Y ~ X, data = df))
# could add poly's as powers of X, or... (note: too high poly overfits)
summary(lm(Y ~ poly(X, degree=5), data = df))
# to update dataframe w/ new powers:
df <- transform(df, X2 = X^2)
# getting fit points from model...
poly.fit <- lm(Y ~ poly(X, degree = 5), data = df)
df <- transform(df, PredictedY = predict(poly.fit))
ggplot(df, aes(x = X, y = PredictedY)) + geom_point() + geom_line()

# Cross validation to get "just right" fitting
set.seed(1)
x<-seq(0,1, by=0.01)
y <- sin(2*pi*x) + rnorm(length(x), 0, 0.1)
n <- length(x)
indices <- sort(sample(1:n, round(0.5*n)))
training.x <- x[indices]
training.y <- y[indices]
test.x <- x[-indices]
test.y <- y[-indices]
training.df <- data.frame(X = training.x, Y = training.y)
test.df <- data.frame(X = test.x, Y = test.y)

rmse <- function(y, h) {
	return(sqrt(mean((y - h)^2)))
}

performance <- data.frame()

for (d in 1:12) 
{
	poly.fit <- lm(Y ~ poly(X, degree = d), data = training.df)
	# on the fly data.frame update...
	performance <- rbind(performance,
						 data.frame(Degree = d,
						 Data = 'Training',
						 RMSE = rmse(training.y, predict(poly.fit))))

	performance <- rbind(performance,
						 data.frame(Degree = d,
						 Data = 'Test',
						 RMSE = rmse(test.y, predict(poly.fit,
						 			 newdata = test.df))))
}

ggplot(performance, aes(x = Degree, y = RMSE, linetype = Data)) + geom_point() + geom_line()

# Looking at complexity of models..
lm.fit <- lm(y~x)
l2.model.complexity <- sum(coef(lm.fit)^2)
l1.model.complexity <- sum(abs(coef(lm.fit)))

x <- matrix(x)
library('glmnet')
glmnet(x,y)	#Non-zero coeffs, kinda R^2, Lambda / hyperparameter / reg param
# use glmnet to get best fitting / least complex model for data...
glmnet.fit <- with(training.df, glmnet(poly(X, degree=10), Y))
lambdas <- glmnet.fit$lambda
performance <- data.frame()
for (lambda in lambdas) 
{
	performance <- rbind(performance,
		data.frame(Lambda = lambda,
				   RMSE = rmse(test.y, with(test.df, predict(glmnet.fit, poly(X, 							   degree=10), s = lambda)))))
}
best.lambda <- with(performance, Lambda[which(RMSE == min(RMSE))])
glmnet.fit <- with(df, glmnet(poly(X, degree=10), Y))
coef(glmnet.fit, s = best.lambda)		# shows coefs from the model at best.lambda
# plot of lambdas vs. rmse's
ggplot(performance, aes(x = Lambda, y = RMSE)) + geom_point() + geom_line()

# some text stuff...
library('tm')
library('glmnet')

ranks <- read.csv('/Users/sinn/ML_for_Hackers/06-Regularization/data/oreilly.csv', stringsAsFactors = FALSE)
documents <- data.frame(Text = ranks$Long.Desc.)
row.names(documents) <- 1:nrow(documents)

corpus <- Corpus(DataframeSource(documents))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, stripWhitespace)
curpus <- tm_map(cirpus, removeWords, stopwords('english'))

dtm <- DocumentTermMatrix(corpus)
x <- as.matrix(dtm)
y <- rev(1:100)		# use reverss to makes socres and such more intuitive

set.seed(1)

performance <- data.frame()

for (lambda in c(0.1, 0.25, 0.5, 1, 2, 5))
{
	for (i in 1:50) # run 50 times to get error bars, etc
	{
		indices <- sample(1:100, 80)
		training.x <- x[indicies, ]
		training.y <- y[indicies]
		
		test.x <- x[-indicies, ]
		text.y <- y[-indicies]
		
		glm.fit <- glmnet(training.x, training.y)
		predicted.y <- predict(glm.fit, test.x, s = lambda)
		rmse <- sqrt(mean((predicted.y - test.y)^2))
		
		performance <- rbind(performance,
							 data.frame(Lambda = lambda,
							 			Iteration = i,
							 			RMSE = rmse))
	}
}
# then, plot stuff to see what it looks like...
ggplot(performance, aes(x = Lambda, y = RMSE)) + 
	stat_summary(fun.data = 'mean_cl_boot', geom = 'errorbar') +
	stat_summary(fun.data = 'mean_cl_boot', geom = 'point')
	
# this model doesn't work, try logistic regression model...
# change glmnet:
regularized.fit <- glmnet(x, y, family = "binomial")
predicted.y <- predict(regularized.fit, newx = x, s = 0.001)
# also, logit stuff to show "membership probabiltiy" ([0,1]) of y's
# because of this, model judged on correct vs. wrong membership placements
predicted.y <- ifelse(predict(regularized.fit, newx = x, s = 0.001) > 0, 1, 0)
error.rate <- mean(predicted.y != test.y)	# cute
library('boot')
inv.logit(predict(regularized.fit, newx = x, s = 0.001))
# book also changed lambdas in the above, and num iterations to 250:
for (lambda in c(0.0001, 0.001, 0.0025, 0.005, 0.01, 0.025, 0.05, 0.1))
# scale plot differently:
ggplot(performance, aes(x = Lambda, y = ErrorRate)) + 
	stat_summary(fun.data = 'mean_cl_boot', geom = 'errorbar') +
	stat_summary(fun.data = 'mean_cl_boot', geom = 'point') +
	scale_x_log10()