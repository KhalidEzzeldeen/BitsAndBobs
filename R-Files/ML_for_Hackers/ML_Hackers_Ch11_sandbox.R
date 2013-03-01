# can't really do much from this section bc google social api is depreciated...
library('RCurl')
library('RJSONIO')
library('igraph')

api.url <-
	paste('https://socialgraph.googleapis.com/lookup?q=http://twitter.com/',
		  user, "&edo=1&edi=1", sep="")
api.get <- getURL(api.url)
# use this loop to guard against web-request issues; makes sure
# somthing actually returned from getURL; grepl is just a seach / match op
while(grepl("Service Unavailable. Please try again later.", api.get)) {
	api.get <- getURL(api.url)
}
# convert JSON over to some sort of data structure?
api.json <- fromJSON(api.get)

# duplicated is a useful function

# now, use data they've snowballed already play with...
library('igraph')		# note, igraph starts graph inds @ 0
# load data
main.dir <- '/Users/sinn/ML_for_Hackers/11-SNA/data/drewconway/'
user <- 'drewconway'
user.ego <- read.graph('/Users/sinn/ML_for_Hackers/11-SNA/data/drewconway/drewconway_ego.graphml', format = 'graphml')
# get shortest paths
user.sp <- shortest.paths(user.ego)
# do heirarchical clustering based on shortest paths
user.hc <- hclust(dist(user.sp))
# plot, shittly...
plot(user.hc)
# construct easier way to see heirarchy..
for(i in 2:10) {
	user.cluster <- as.character(cutree(user.hc, k=i))
	user.cluster[1] <- "0"
	user.ego <- set.vertex.attribute(user.ego, name=paste("HC",i,sep=""), value=user.cluster)
}
# write out newly created network / graph (they already did this)
write.graph(user.net, paste(main.dir, user, '_new.graphml', sep=''))
write.graph(user.clean, paste(main.dir, user, '_clean.graphml', sep=''))
write.graph(user.ego, paste(main.dir, user, '_ego.graphml', sep=''))

# triangle closing, friend of friend stuff...
user <- "drewconway"
user.graph <- read.graph("/Users/sinn/ML_for_Hackers/11-SNA/data/drewconway/drewconway_net.graphml", format="graphml")
friends <- V(user.graph)$name[neighbors(user.graph, user, mode="out")+1]
# this looks at each edge and determines if the edge involves a friend 
# following a non-friend / self; these are the edges of interest
non.friends <- sapply(1:nrow(user.el), function(i) ifelse(any(user.el[i,]==user | !user.el[i,1] %in% friends) | user.el[i,2] %in% friends, FALSE, TRUE))
# grabs desired edges from network
non.friends.el <- user.el[which(non.friends==TRUE),]
# determines number of times each non-friended user shows up as friend 
# of a friend, then places in a data frame
friends.count <- table(non.friends.el[,2])
friends.followers <- data.frame(list(Twitter.Users=names(friends.count),
	Friends.Following=as.numeric(friends.count)), stringsAsFactors = FALSE)
# normalizes counts to fract of friend's following
friends.followers$Friends.Norm <- friends.followers$Friends.Following/length(friends)
# reorder list from largest num / frac to smallest
friends.followers <- friends.followers[with(friends.followers, order(-Friends.Norm)),]

# now doing stuff with partitioned graph, etc
user.ego <- read.graph('/Users/sinn/ML_for_Hackers/11-SNA/data/drewconway/drewconway_ego.graphml', format="graphml")
# grab only specific partitions (down to HC8; e.g., HC0-HC8)
friends.partitions <- cbind(V(user.ego)$HC8, V(user.ego)$name)

# function for finding most obvi triangles:
partition.follows <- function(i) {
	# grab list of ppl from a specific partition
	friends.in <- friends.partitions[which(friends.partitions[,1]==i),2]
	# grab subset of non-friends that friends follow in this partition
	partition.non.follow <- non.friends.el[which(!is.na(match(non.friends.el[,1],
		friends.in))),]
	# members in this new list?
	if(nrow(partition.non.follow) < 2) {
		return(c(i,NA))
	}
	else {
		# table num friend-followers for partition subset
		partition.favorite <- table(partition.non.follow[,2])
		partition.favorite <- partition.favorite[order(-partition.favorite)]
		# only return top recommendation from each partition....
		return(c(i,names(partition.favorite)[1]))
	}
}

# use the above function, network, to grab best recommendation from each group
partition.recs <- t(sapply(unique(friends.partitions[,1]), partition.follows))
partition.recs <- partition.recs[!is.na(partition.recs[,2]) & !duplicated(partition.recs[,2]),]