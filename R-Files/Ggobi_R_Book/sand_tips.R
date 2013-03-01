library(ggplot2)

# basic load, data.frame
tips <- read.csv('/Users/sinn/Documents/R_Files/Ggobi_R_Book/tips.csv', row.names=1)
tips <- data.frame(tips)
tips <- transform(tips, 'billfrac' = tip / totbill)

table(tips$sex, tips$smoker)
#these two are useful...
ggplot(tips, aes(x=totbill, y=tip)) + geom_point() + facet_grid(sex~smoker) + stat_quantile()
ggplot(tips, aes(x=totbill, y=tip)) + geom_point() + facet_grid(sex~smoker) + geom_abline(intercept=0, slope=0.18)

#note, 'geom_jitter(aes(x=,y=))' actually plots new points, so the following two are the same:
ggplot(tips, aes(x=size, y=billfrac, color=sex)) + geom_point(position='jitter')
ggplot(tips, aes(x=size, y=billfrac, color=sex)) + geom_jitter(aes(x=size))

# again, dupes points
ggplot(tips, aes(x=factor(size), y=billfrac)) + geom_point(position='jitter') + geom_boxplot()

# rounding?
tips <- transform(tips, 'rounded' = as.array(tip%%0.5==0))
mosaicplot(as.array(table(tips$rounded, tips$smoker)), xlab = 'rounded', ylab='smoker', color=TRUE)

# interesting:
table(tips$sex, tips$time)
mosaicplot(as.array(table(tips$time, tips$sex)), xlab = 'Time', ylab='Sex', color=TRUE)
ggplot(tips, aes(y=billfrac, x=time, color=sex)) + geom_point(position='jitter')
# no difference really
ggplot(tips, aes(y=billfrac, x=time)) + geom_point(position='jitter')

# fit data w/ linear models, plot:
male.ns.sub <- as.array(tips$sex=='M' & tips$smoker=='No')
male.s.sub <- as.array(tips$sex=='M' & tips$smoker=='Yes')
lm.male.nonsmoker <- lm(tip ~ totbill, data=tips, subset = male.ns.sub)
lm.male.smoker <- lm(tip ~ totbill, data=tips, subset = male.s.sub)

oldpar <- par(mfrow = c(1,2))
plot(tips$totbill[male.ns.sub], tips$tip[male.ns.sub])
abline(a=as.numeric(lm.male.nonsmoker$coefficients[1]), b=as.numeric(lm.male.nonsmoker$coefficients[2])
plot(tips$totbill[male.s.sub], tips$tip[male.s.sub])
abline(a=as.numeric(lm.male.smoker$coefficients[1]), b=as.numeric(lm.male.smoker$coefficients[2]))


# then there's this monstrosity
male.sub <- as.array(tips$sex=='M')
ggplot(tips, aes(x=totbill[male.sub], y=tip[male.sub], color=smoker[male.sub])) + geom_point() + geom_abline(intercept=as.numeric(lm.male.nonsmoker$coefficients[1]), slope=as.numeric(lm.male.nonsmoker$coefficients[2]), color='red') + geom_abline(intercept=as.numeric(lm.male.smoker$coefficients[1]), slope=as.numeric(lm.male.smoker$coefficients[2]), color='blue')
