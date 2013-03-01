library(ggplot2)
library('e1071')

df <- read.csv('/Users/sinn/ML_for_Hackers/12-Model_Comparison/data/df.csv')
# what does it look like?
ggplot(df, aes(x=X, y=Y, color=Label)) + geom_point()

# how does logistic model do? (hint: shittly)
logit.fit <- glm(Label ~ X + Y,
				 family = binomial(link='logit'),
				 data = df)
logit.predictions <- ifelse(predict(logit.fit) > 0, 1, 0)
mean(with(df, logit.predictions==Label)) # about 50%, or same as assigning all '0'

# ok, SVMs...
svm.fit <- svm(Label ~ X + Y, data=df)
svm.predictions <- ifelse(predict(svm.fit) > 0, 1, 0)
mean(with(df, svm.predictions==Label))	# bit better, 72%-ish

# compare via plotting
# df is a 2500 by 5 data.frame, where each point has listed beside it
# its actual label, the Logit category, and the SVM category
df <- cbind(df,
			data.frame(Logit = ifelse(predict(logit.fit) > 0, 1, 0),
					   SVM = ifelse(predict(svm.fit) > 0, 1, 0)))
# melt by X, Y in this case creates a varaible category out of the 
# 'Label' | 'Logit' | 3 'SVM' options and unfolds along these to make
# a 7500 by 4 data.frame (X, Y, variable, and value)
predictions <- melt(df, id.vars = c('X', 'Y'))
ggplot(predictions, aes(x=X, y=Y, color=factor(value))) +
	geom_point() +
	facet_grid(variable ~ .)
	
# into the kernals...try various ones, compare
# TBH, for data sets like this, would just use rule-based classification
df <- df[, c('X', 'Y', 'Label')]

# shitty...all same group (non-lin data set, makes sense)
lin.svm.fit <- svm(Label ~ X + Y, data = df, kernel='linear')
with(df, mean(Label==ifelse(predict(lin.svm.fit) > 0, 1, 0)))

# equally shitty...all same (non-poly data set, makes sense)
poly.svm.fit <- svm(Label ~ X + Y, data = df, kernel='polynomial')
with(df, mean(Label==ifelse(predict(poly.svm.fit) > 0, 1, 0)))

# ok, but not so great (less than out-of-box); seems to find "pattern"
# it seems that removing 'Y' as a variable increases the reliability
# this one should do the best based on the kernel form..
rad.svm.fit <- svm(Label ~ X + Y, data = df, kernel='radial')
with(df, mean(Label==ifelse(predict(rad.svm.fit) > 0, 1, 0)))

# does ok by "accident"; doesn't find pattern
sig.svm.fit <- svm(Label ~ X + Y, data = df, kernel='sigmoid')
with(df, mean(Label==ifelse(predict(sig.svm.fit) > 0, 1, 0)))

df <- cbind(df,
			data.frame(LinSVM = ifelse(predict(lin.svm.fit) > 0, 1, 0),
					   PolySVM = ifelse(predict(poly.svm.fit) > 0, 1, 0),
					   RadSVM = ifelse(predict(rad.svm.fit) > 0, 1, 0),
					   SigSVM = ifelse(predict(sig.svm.fit) > 0, 1, 0)))
predictions <- melt(df, id.vars = c('X', 'Y'))
ggplot(predictions, aes(x=X, y=Y, color=factor(value))) +
	geom_point() +
	facet_grid(variable ~ .)
	
# assuming we like radial the best, let's try and find a "better" gamma:
# gamma is required to be > 0 to prevent exp from blowing up.
gamma_vals <- seq(0,2,0.1)
accuracy.sig <- sapply(1:length(gamma_vals), function(i) with(df, mean(Label==ifelse(predict(svm(Label ~ X, data = df, kernel='radial', gamma=gamma_vals[i])) > 0, 1, 0))))
gam.acc <- cbind(Gamma = gamma_vals, Acc = accuracy.sig)
# seems to indicate something around 0.3 offers the best bet, though
# the trend is non-linear; could be something around 0.9 as well...
# note this out-performs out-of-box marginally

# same for cost...spoiler, default of 1 seems to do best
cost_vals <- seq(0.25,3,0.25)
accuracy.sig <- sapply(1:length(cost_vals), function(i) with(df, mean(Label==ifelse(predict(svm(Label ~ X, data = df, kernel='radial', gamma=0.3, cost=cost_vals[i])) > 0, 1, 0))))
cbind(Cost = cost_vals, Acc = accuracy.sig)

# comparing models using spam data stuff..
load('/Users/sinn/ML_for_Hackers/12-Model_Comparison/data/dtm.RData')
set.seed(1)
training.indices <- sort(sample(1:nrow(dtm), round(0.5*nrow(dtm))))
test.indices <- which(! 1:nrow(dtm) %in% training.indices)
train.x <- dtm[training.indices, 3:ncol(dtm)]
train.y <- dtm[training.indices, 1]
test.x <- dtm[test.indices, 3:ncol(dtm)]
test.y <- dtm[test.indices, 1]
rm(dtm)
library('glmnet')
regularized.logit.fit <- glmnet(train.x, train.y, family=c('binomial'))
lambdas <- regularized.logit.fit$lambda
performance <- data.frame()

for (lambda in lambdas){
	predictions <- predict(regularized.logit.fit, test.x, s=lambda)
	predictions <- as.numeric(predictions > 0)
	mse <- mean(predictions != test.y)
 
	performance <- rbind(performance, data.frame(Lambda=  lambda, MSE = mse))
}

ggplot(performance, aes(x=Lambda, y=MSE)) +
	geom_point() +
	scale_x_log10()
	
best.lambda <- with(performance, max(Lambda[which(MSE==min(MSE))]))
mse <- with(subset(performance, Lambda==best.lambda), MSE)

# try the linear SVM method
linear.svm.fir <- svm(train.x, train.y, kernel = 'linear')
predictions <- predict(linear.svm.fir, test.x)
predictions <- as.numeric(predictions > 0)
mean(predictions != test.y)

# etc...
