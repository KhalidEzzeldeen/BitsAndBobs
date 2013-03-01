library(rggobi)
library(MASS)
library(ggplot2)

# load data
d.olive <- read.csv('/Users/sinn/Documents/R_Files/Ggobi_R_Book/olive.csv', row.names=1)
# basic stuff...
d.olive.sub <- subset(d.olive, select = c(region, palmitic:eicosenoic))
olive.lda <- lda(region ~ ., d.olive.sub)
pregion <- predict(olive.lda, d.olive.sub)$class
table(d.olive.sub[,1], pregion)
plot(predict(olive.lda, d.olive.sub)$x)

# want some color by region
p.data <- data.frame(predict(olive.lda, d.olive.sub)$x)
p.data <- transform(p.data, 
					"Region" = unlist(strsplit(row.names(p.data), '\\.'))[seq(2,2*length(regions),2)])
macro_regions <- lapply(p.data$Region, 
						function(x) switch(sub('-','',x),
						Umbria = "North",
						EastLiguria = "North",
						WestLiguria = "North",
						NorthApulia = "South",
						Calabria = "South",
						SouthApulia = "South",
						Sicily = "South",
						CoastSardinia = "Sardinia",
						InlandSardinia = "Sardinia"))
p.data <- transform(p.data,
					"MacroRegion" = unlist(macro_regions))					
					
# some other stuff:
d.olive <- transform(d.olive, "Index" = 1:dim(d.olive)[1])
d.olive.unwrap <- melt(d.olive, idvars = c('region', 'area', 'Index'))
p <- ggplot(d.olive.unwrap, aes(x = Index, y=value, color=as.factor(region))) + geom_point()
p + facet_grid(.~variable)

# this gives some pretty good perspectives:
p <- ggplot(d.olive.unwrap, aes(x = region, y=value, color=as.factor(area))) + geom_point() + geom_jitter(aes(x=region))
p + facet_grid(variable ~., scales="free")

# this is cool to look at, but I think it "masks" region overlap a bit
# it does seem a bit "cleaner" though
p <- ggplot(d.olive.unwrap, aes(x = Index, y=value, color=as.factor(region))) + geom_point()
p + facet_grid(variable ~., scales="free")

# also this, but it's massive:
p + facet_grid(variable ~ area, scales="free")

# REGION 1:
# so, let's assume we can pull off the 1st region w/ eicosenoic
# how do we break it apart?
region.1 <- subset(d.olive.unwrap, region==1)
p <- ggplot(region.1, aes(x = area, y=value, color=as.factor(area))) + geom_point() + geom_jitter(aes(x=area))
p + facet_grid(variable ~., scales="free")
# not very helpful; let's try something else:
# unmelt data and do pcp (automatically scales data)
region.1.unmelt <- cast(region.1, area+Index~variable, value = "value")
ggpcp(region.1.unmelt, vars=names(region.1.unmelt)[3:10]) + geom_line(aes(color=as.factor(area)))


# Tree stuff...
library(rpart)
olive.rp <- rpart(region ~ ., d.olive.sub, method="class")
olive.rp	# gives solution
plot(olive.rp)		# simple tree structure
text(olive.rp, use.n=TRUE)
# also interesting:
olive.rp <- rpart(region + area ~ ., d.olive, method="class")
plot(olive.rp)
text(olive.rp, use.n=TRUE)