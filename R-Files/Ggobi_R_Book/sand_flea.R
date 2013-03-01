library(ggplot2)

# load, get a view
flea <- read.csv('/Users/sinn/Documents/R_Files/Ggobi_R_Book/flea.csv')
flea <- data.frame(flea)
flea <- flea[order(flea$species),]
# see what we got:
head(flea)
names(flea)
ggpcp(flea, vars=names(flea[2:7])) + geom_line(aes(color=as.factor(species)))

# melt, etc
flea <- transform(flea, "Index" = unlist(1:dim(flea)[1]))
ggplot(flea, aes(x=Index, y=head, color = species)) + geom_point()
flea.unwrap <- melt(flea, id.vars = c('Index', 'species'))
head(flea.unwrap)
ggplot(flea.unwrap, aes(x=Index, y=value, color=as.factor(species))) + geom_point() + facet_grid(variable~., scales='free')
# tars1, aede1-3 look reasonable for sep;
# can prob use tars1 and aede2 to sep Hep from others
# can prob use aede3 and aede1 to sep Con from Hei
library(MASS)
lda.hep <- lda(species ~ tars1 + aede2, flea)
pspecies <- predict(lda.hep, flea)$class
table(flea[,1], pspecies)

flea.sub <- subset(flea, species != 'Heptapot.')
lda.con <- lda(species ~ aede3 + aede1, flea.sub)
pspecies2 <- predict(lda.con, flea.sub)$class
table(flea.sub$species, pspecies2)
#looks like I'm onto something... :)
# probably need to use something better than lda,
# unless the boundaries are nice and big...use SVM's

# tree stuff with fleas...
flea.rp <- rpart(species ~ ., flea, method='class')
plot(flea.rp)
text(flea.rp, use.n=TRUE)