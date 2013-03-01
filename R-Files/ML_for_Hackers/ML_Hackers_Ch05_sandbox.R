library(ggplot2)

ages <- read.csv('/Users/sinn/ML_for_Hackers/05-Regression/data/longevity.csv')
ggplot(ages, aes(x = AgeAtDeath, fill=factor(Smokes))) + geom_density() + facet_grid(Smokes ~ .)
# how well does mean do?
with(ages, sqrt(mean((AgeAtDeath - mean(AgeAtDeath))^2)))

# what about the mean for each group?
smokers.mean <- mean(subset(ages, Smokes==1)$AgeAtDeath)
nonsmks.mean <- mean(subset(ages, Smokes==0)$AgeAtDeath)
with(ages, sqrt(mean((AgeAtDeath - ifelse(Smokes==0,nonsmks.mean,smokers.mean))^2)))
#R^2 value...
1 - (with(ages, sqrt(mean((AgeAtDeath - ifelse(Smokes==0,nonsmks.mean,smokers.mean))^2))) / with(ages, sqrt(mean((AgeAtDeath - mean(AgeAtDeath))^2))))

# hw data set...
heights.weights <- read.csv('/Users/sinn/ML_for_Hackers/05-Regression/data/01_heights_weights_genders.csv', header=TRUE, sep = ',')
ggplot(heights.weights, aes(x=Height, y=Weight)) + geom_point() + geom_smooth(method = 'lm')
# get a lin regression fit..
fitted.regression.hw <- lm(Weight ~ Height, data=heights.weights)
coef(fitted.regression.hw)
# how well does this do?
true.values <- with(heights.weights,Weight)
errors <- true.values - predict(fitted.regression.hw)
sum(residuals(fitted.regression.hw)^2)
plot(fitted.regression.hw, which=1)		# can have which 1:6

# Chapter "meat":
top.1000.sites <- read.csv('/Users/sinn/ML_for_Hackers/05-Regression/data/top_1000_sites.tsv', sep = '\t', stringsAsFactors = FALSE)
# shitty plots, no clear trends
ggplot(top.1000.sites, aes(x=PageViews, y=UniqueVisitors)) + geom_point()
ggplot(top.1000.sites, aes(x=PageViews)) + geom_density()
# log-log better...
ggplot(top.1000.sites, aes(x=log(PageViews))) + geom_density()
ggplot(top.1000.sites, aes(x=log(PageViews), y=log(UniqueVisitors))) + geom_point()
# find linear fit to log-log data (bleah)
lm.fit.top.1000 <- lm(log(PageViews) ~ log(UniqueVisitors), data=top.1000.sites)
summary(lm.fit.top.1000)	# cute function...
# multi-factors:
lm.fit.top.1000 <- lm(log(PageViews) ~ log(UniqueVisitors) + InEnglish + HasAdvertising, data=top.1000.sites)

# side note on correlation:  same thing here
cor(x, y)
coef(lm(scale(y) ~ scale(x)))

