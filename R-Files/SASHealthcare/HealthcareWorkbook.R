# File names, load data, apply header, make data.frame
d.name <- "/Users/sinn/Desktop/Data/ShootoutHealthcare/2010 SAS Shootout Dataset.csv"
h.name <- "/Users/sinn/Desktop/Data/ShootoutHealthcare/DataHead2.txt"
healthcare <- read.csv(f.name, header=FALSE, sep=',')
h.df <- data.frame(healthcare)
header <- readLines(h.name, header=FALSE, sep=',')
names(h.df) <- header

# grab a sample to work with:
inds <- sample(1:dim(h.df)[1],2000)
h.sample <- h.df[inds,]

# Basic income v. years edu, category by Sex plot; also sep plots
ggplot(h.sample, aes(y=Income, x=YearsEdu, color=factor(Sex))) + geom_point()
ggplot(h.sample, aes(y=Income, x=YearsEdu, color=factor(Sex))) + geom_point() + facet_grid(.~Sex)
ggplot(h.sample, aes(y=Income, x=YearsEdu, color=factor(Smoke))) + geom_point() + facet_grid(.~Sex)

# get non-empty smoker indicies:
Smk.data <- h.df$Smoke[seq(1:dim(h.df)[1])[Smk.data]]
summary(h.df$Smoke[Smk.data])

# income stuff:
Inc.data <- h.df[seq(1:dim(h.df)[1])[h.df$Income>0]]$Income
max <- c()
for(i in 1:100) {
	max <- c(max,max(rexp(length(Inc.data))))
}
plot(sort(Inc.data), sort(rexp(length(Inc.data))))
# this is probably "better"; still has that strange hump, too,
# around $150,000
plot(sort(sample(Inc.data,5000)), sort(rexp(5000)))
hist(Inc.data)	# see?

# want to grab a random sample of people, but have equal
# nums of diabetes and non-diabetes:
y.diab <- seq(1:dim(h.df)[1])[h.df$Diabetes==1]		# only 2500ish
n.diab <- seq(1:dim(h.df)[1])[h.df$Diabetes==0]
r.sample <- c(sample(y.diab,1500), sample(n.diab,1500))
r.s.df <- h.df[r.sample,]

# As a sidenote, plotting the r.s.df params (sorted) against
# a random sample of the same parameter from the h.df data
# (sorted) can expose params associeted w/ diabetes (e.g., age)

# merge BMIs (for some reason??)
BMI <- apply(cbind(h.df$AdultBMI, h.df$ChildBMI),1,max)
h.df <- transform(h.df, "BMI" = BMI)

# grab adults only, then BMI within certain range..
# resample first:
r.s.df <- h.df[r.sample,]
adult_inds <- r.s.df$Age>=16
noout_inds <- adult.r.s.df$BMI<=65 & adult.r.s.df$BMI>0
restriction_inds <- adult_inds & noout_inds
noout.adult.r.s.df <- adult.r.s.df[noout_inds,]
# plot to see the difference between the two cases (i.e., diabs and ~diabs)
ggplot(noout.adult.r.s.df, aes(y=BMI, x=Age, color=factor(Sex))) + geom_point() + facet_grid(.~Diabetes)