players.teams.new<-players.teams
TeamNames <- names(players.teams.new)
NumTeams <- length(TeamNames)
Stats <- matrix(nrow=NumTeams,ncol=5,
				dimnames=list(TeamNames,as.list(names(playerstats)[4:8])))
for(i in 1:NumTeams)  {
	tN <- TeamNames[i]
	temp <- players.teams[[tN]]
	minTemp<-sort(temp[,4], decreasing=T)
	Space <- mean(minTemp[minTemp>0],na.rm=T)-
			 sd(minTemp[minTemp>0],na.rm=T)
	players.teams.new[[tN]]<-temp[temp[,4]>Space,]
	Stats[i,1:5] = sapply(players.teams.new[[tN]][,4:8],mean,na.rm=T)
}
#Gets total number of mins played by all players, num of all players.
for(i in 1:length(players.teams)) {
	TotMins = TotMins+sum(players.teams[[names(players.teams[i])]][4])
	k = k + dim(players.teams[[names(players.teams[i])]][4])[1]
}


par(mfrow = c(2,2))
dotchart(Stats[,2],xlab=dimnames(Stats)[[2]][2], xlim = c(0,1200))
dotchart(Stats[,3],xlab=dimnames(Stats)[[2]][3], xlim = c(0,1200))
dotchart(Stats[,4],xlab=dimnames(Stats)[[2]][4], xlim = c(0,1200))
dotchart(Stats[,5],xlab=dimnames(Stats)[[2]][5], xlim = c(0,1200))