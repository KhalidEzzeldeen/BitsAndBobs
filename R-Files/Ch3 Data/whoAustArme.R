load('who.pop.2000.rda')						#pop data
load('who.ccodes.rda')							#country codes
load('who.pop.var.names.rda')					#var names in who.pop.2000

cn <-'Australia'
#cn <- 'Armenia'
cc <- who.ccodes$code[who.ccodes$name == cn]	#country code

par(mfrow = c(2,1))								#sets the 2 frames
bl <- as.character(pop.var.names$descr[2:26])	#sets labels for bars
#males
gender<-1
rows<-who.pop.2000$code==cc &					#indexing rel data from who
	who.pop.2000$sex==gender
columns <-5:29
barplot(t(who.pop.2000[rows,columns])[,1]/1000,	
	names.arg=bl,main=paste(cn,',males'),
	las=2,col='blue')
#females
gender<-2
rows<-who.pop.2000$code==cc &					#indexing rel data from who
	who.pop.2000$sex==gender
barplot(t(who.pop.2000[rows,columns])[,1]/1000,
	names.arg=bl,main=paste(cn,',females'),
	las=2,col='red')
