# basic matrix stuff...
set.seed(851982)
ex.matrix <- matrix(sample(c(-1,0,1), 24, replace = TRUE), nrow=4, ncol=6)
row.names(ex.matrix) <- c('a', 'b', 'c', 'd')
col.names(ex.matrix) <- c('P1', 'P2', 'P3', 'P4', 'P5', 'P6')
t(ex.matrix)	# transpose
ex.matrix %*% t(ex.matrix)	# multiplication
ex.mult <- ex.matrix %*% t(ex.matrix)
ex.dist <- dist(ex.mult)	# dist is Euclidean in this case
# convert distances to (x,y) coords (essentially)
ex.mds <- cmdscale(ex.dist)	#multi-dim scaling
plot(ex.mds, type='n')
text(ex.mds, c('a', 'b', 'c', 'd'))
# 3D action...note the first 2 dims are the same
ex.mds.3 <- cmdscale(ex.dist, k=3)
plot3d(ex.mds.3)

library('foreign')
library('ggplot2')

# set dir, get list of files in that dir
data.dir <- "/Users/sinn/ML_for_Hackers/09-MDS/data/roll_call/"
data.files <- list.files(data.dir)
# load the files
rollcall.data <- lapply(data.files, 
		function(f) read.dta(paste(data.dir, f, sep=""), convert.factors=FALSE))

# function to simplify range of yay/nay votes
# see: voteview.com/senate101.htm
rollcall.simplified <- function(df) {
	no.pres <- subset(df, state < 99)
	for(i in 10:ncol(no.pres)) {
		no.pres[,i] <- ifelse(no.pres[,i] > 6, 0, no.pres[,i])
		no.pres[,i] <- ifelse(no.pres[,i] > 0 & no.pres[,i] < 4, 1, no.pres[,i])
		no.pres[,i] <- ifelse(no.pres[,i] > 1, -1, no.pres[,i])
	}
	return(as.matrix(no.pres[,10:ncol(no.pres)]))
}
# apply to all data files in rollcall.data
rollcall.simple <- lapply(rollcall.data, rollcall.simplified)
# find distances, convert to 2-D coords
rollcall.dist <- lapply(rollcall.simple, function(m) dist(m %*% t(m)))
rollcall.mds <- lapply(rollcall.dist, function(d) as.data.frame((cmdscale(d, k=2)) * -1))
# Grab names of Senators from each congress, format to desired appearenc,
# add names to rollcall.mds for particular congress, make parties factors
congresses <- 101:111
for(i in 1:length(rollcall.mds)) {
	names(rollcall.mds[[i]]) <- c('x', 'y')
	congress <- subset(rollcall.data[[i]], state < 99)
	congress.names <- sapply(as.character(congress$name), function(n) strsplit(n, "[, ]")[[1]][1])
	rollcall.mds[[i]] <- transform(rollcall.mds[[i]], name=congress.names, party=as.factor(congress$party), congress=congresses[i])
}

# plot the fuck out of it...using 110 congress
cong.110 <- rollcall.mds[[9]]
base.110 <- ggplot(cong.110, aes(x=x, y=y)) +
		scale_size(to=c(2,2), legend=FALSE) +
		scale_alpha(legend=FALSE) +
		theme_bw() +
		opts(axis.ticks=theme_blank(), axis.text.x=theme_blank(), axis.text.y = theme_blank(), title='Roll Call Vote MDS Clustering for 110th US Senate', panel.grid.major=theme_blank()) +
		xlab("") +
		ylab("") +
		scale_shape(name="Party", breaks=c("100", "200", "328"), labels=c('Dem', 'Rep', 'Ind'), solid=FALSE) +
		scale_color_manual(name="Party", values=c('100'="red", '200'='blue', '328'='yellow'), breaks=c("100", "200", "328"), labels=c('Dem', 'Rep', 'Ind'))
		
print(base.110+geom_point(aes(shape=party, alpha=0.75, size=2)))
print(base.110+geom_text(aes(color=party, alpha=0.75, label=cong.110$name, size=2)))
# what they actually wanted was the 111th congress...
cong.111 <- rollcall.mds[[10]]
base.111 <- ggplot(cong.111, aes(x=x, y=y)) +
 		scale_size(to=c(2,2), legend=FALSE) +
 		scale_alpha(legend=FALSE) +
 		theme_bw() +
 		opts(axis.ticks=theme_blank(), axis.text.x=theme_blank(), axis.text.y = theme_blank(), title='Roll Call Vote MDS Clustering for 111th US Senate', panel.grid.major=theme_blank()) +
 		xlab("") +
 		ylab("") +
 		scale_shape(name="Party", breaks=c("100", "200", "328"), labels=c('Dem', 'Rep', 'Ind'), solid=FALSE) +
 		scale_color_manual(name="Party", values=c('100'="red", '200'='blue', '328'='yellow'), breaks=c("100", "200", "328"), labels=c('Dem', 'Rep', 'Ind'))
print(base.111+geom_point(aes(shape=party, alpha=0.75, size=2)))
print(base.111+geom_text(aes(color=party, alpha=0.75, label=cong.111$name, size=2)))

# everything, to compare...
all.mds <- do.call(rbind, rollcall.mds)
all.plot <- ggplot(all.mds, aes(x=x, y=y)) +
			geom_point(aes(shape=party, alpha=0.75, size=2)) +
			scale_size(to=c(2,2), legend=FALSE) +
			scale_alpha(legend=FALSE) +
			theme_bw() +
			opts(axis.ticks=theme_blank(), axis.text.x=theme_blank(), axis.text.y = theme_blank(), title='Roll Call Vote MDS Clustering US Senate (101-111)', panel.grid.major=theme_blank()) +
 			xlab("") + ylab("") +
 			scale_shape(name="Party", breaks=c("100", "200", "328"), labels=c('Dem', 'Rep', 'Ind'), solid=FALSE) + 
 			scale_color_manual(name="Party", values=c('100'="red", '200'='blue', '328'='yellow'), breaks=c("100", "200", "328"), labels=c('Dem', 'Rep', 'Ind')) +
 			facet_wrap(~ congress)
 all.plot