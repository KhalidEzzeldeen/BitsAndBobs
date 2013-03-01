library('ggplot2')

df <- read.csv('/Users/sinn/ML_for_Hackers/10-Recommendations/data/example_data.csv')
ggplot(df, aes(x=X, y=Y)) + geom_point(aes(shape=as.character(Label))) + theme_bw()

#
distance.matrix <- function(df)
{
	distance <- matrix(rep(NA, nrow(df)^2), nrow = nrow(df))
	
	for (i in 1:nrow(df))
	{
		for (j in 1:nrow(df))
		{
			distance[i,j] <- sqrt((df[i,'X'] - df[j,'X'])^2 + (df[i,'Y'] - df[j,'Y'])^2)
		}
	}
	return(distance)
}

k.nearest.neighbors <- function(i, distance, k=5)
{
	return(order(distance[i,])[2:(k+1)])
}

knn <- function(df, k=5)
{
	distance <- distance.matrix(df)
	predictions <- rep(NA, nrow(df))
	
	for (i in 1:nrow(df))
	{
		indices <- k.nearest.neighbors(i, distance, k=k)
		# if more neighbors labeled 1, make 1, else 0 (tie or less)
		predictions[i] <- ifelse(mean(df[indices, 'Label']) > 0.5, 1, 0)
	}
	return(predictions)
}

# add new col to data.frame df for kNN assignment
df <- transform(df, kNNp = knn(df))
# count non-matches for actual Label and assigned label
sum(with(df, Label != kNNp))


# "Real" kNN stuff...
rm('knn')
library('class')
df <- read.csv('/Users/sinn/ML_for_Hackers/10-Recommendations/data/example_data.csv')
n <- nrow(df)
set.seed(1)
indices <- sort(sample(1:n, n*(1/2)))

training.x <- df[indices, 1:2]
test.x <- df[-indices, 1:2]
training.y <- df[indices, 3]
test.y <- df[-indices, 3]

predicted.y <- knn(training.x, test.x, training.y, k=5)
sum(predicted.y != test.y)	# should get 7 out of 50...

# compare to logit model:
logit.model <- glm(Label ~ X + Y, data = df[indices, ])
predictions <- as.numeric(predict(logit.model, newdata = df[-indices, ]) > 0)
sum(predictions != test.y)	# should get 16 out of 50...

# real meat of chapter:
library('reshape')
# load data: #, Package, User, Installed; molten data form
installations <- read.csv('/Users/sinn/ML_for_Hackers/10-Recommendations/data/installations.csv')
# cast tp 'unmelt' into package by binary install / not install for all users
user.package.matrix <- cast(installations, User ~ Package, value = 'Installed')
# 1st col is just user IDs; set as row names, remove
row.names(user.package.matrix) <- user.package.matrix[,1]
user.package.matrix <- user.package.matrix[, -1]
# get cor matrix, distances
similarities <- cor(user.package.matrix)
distance <- -log((similarities / 2) + 0.5)

# new kNN stuff:
k.nearest.neighbors <- function(i, distances, k=25)
{
	return(order(distances[i, ])[2:(k+1)])
}

installation.probability <- function(user, package, user.package.matrix, distances, k=25)
{
	neighbors <- k.nearest.neighbors(package, distances, k=k)
	return(mean(sapply(neighbors, function(neighbor) {user.package.matrix[user, neighbor]})))
}

installation.probability(1,1,user.package.matrix, distance)

# function to generate a list of the most likely pacakages the user would
# install given they've already installed others; updated from book
# to only output those w/ values above co; potentially just doing extra work...
most.probable.packages <- function(user, user.package.matrix, distances, k=25, co=0.7)
{
	values <- sapply(1:ncol(user.package.matrix),
						function (package)
						{
							installation.probability(user,
													 package,
													 user.package.matrix,
													 distances,
													 k=k)
						})
	remaining <- subset(1:length(values), values >= co)
	values <- subset(values, values >= co)
	return(remaining[order(values,decreasing = TRUE)])
}

user <- 1
listing <- most.probable.packages(user, user.package.matrix, distance)
colnames(user.package.matrix)[listing[1:10]]

# what about just those that aren't already installed?
currently.installed <- subset(1:length(user.package.matrix[1,]), user.package.matrix[1,]==1)
new.to.install <- setdiff(listing, currently.installed)