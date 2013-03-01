temp.speed<-ReedyCreekData$X10m.Wind.Speed..mph.
temp.direc<-ReedyCreekData$X10m.Wind.Direction..degrees.

wind.speed <- hist(temp.speed,plot=F)
wind.direc <- hist(temp.direc,plot=F)
speed.space <- (wind.speed$breaks[2]-wind.speed$breaks[1])/2
direc.space <- (wind.direc$breaks[2]-wind.direc$breaks[1])/2


NN <- cbind(as.character(wind.speed$breaks[1:14]),'-',
			as.character(wind.speed$breaks[2:15]))
temp.names <- vector(mode="character",length=dim(NN)[1])
for (k in 1:dim(NN)[1]) {
	temp.names[k]<-paste(NN[k,1],NN[k,2],NN[k,3],sep="")
}

wind.frame <- data.frame(row.names=as.list(temp.names))
for (i in 1:length(wind.direc$mids)) {
	for (j in 1:length(wind.speed$mids)-1) {
		wind.frame[j,i] <-
		sum(as.integer(temp.speed>=wind.speed$mids[j]-speed.space &
					   temp.speed< wind.speed$mids[j]+speed.space &
					   temp.direc>=wind.direc$mids[i]-direc.space &
					   temp.direc< wind.direc$mids[i]+direc.space ))
	}
}
for (i in 1:length(wind.direc$mids)) {
	for (j in length(wind.speed$mids)) {
		wind.frame[j,i] <-
		sum(as.integer(temp.speed>=wind.speed$mids[j]-speed.space &
					   temp.speed<=wind.speed$mids[j]+speed.space &
					   temp.direc>=wind.direc$mids[i]-direc.space &
					   temp.direc< wind.direc$mids[i]+direc.space ))
	}
}

rosavent(wind.frame,fint=3,main="Reedy Wind Direc and Speed")