#Load airline data
airline <- ts(scan('airline.dat'),freq=12,start=1949)
d = 12;

##Filters##########################
#Book's
if((d/2-floor(d/2)) != 0){
	filter02 = rep(1/d,2*d+1)
} else {									#else must be on same line as }
	filter02 = c(.5,rep(1,2*d-1),.5) / (2*d) 	
}
#Spencer; need to mod for period 12 stuff, though.
filter03 = c(74,67,46,21,3,-5,-6,-3)/320
filter03 = c(rev(filter03),filter03[2:8])
##################################

##Get smoothed data by removing seasonal (monthly) trends
air.ma <- filter(airline,filter02,
				 method = 'conv',sides = 2)		#trend data; T_hat
#Plot boxplot of yearly data
leg.names<-c('Data','Smoothed Data','Else')
ts.plot(airline,air.ma,airline-air.ma,lty=c(1,3), 
	main='Airline Op Rev.:  1949-1960',
	ylab='XX of Doll',xlab='Year')
legend(locator(1),leg.names,lty=c(1,3))			#click on plot to activate

##Construct yearly running median box-plot
air.mat <- matrix(airline,nrow=12)
boxplot(as.data.frame(air.mat),names=as.character(seq(1949,1960)), boxcol=-1,medcol=1,main='Airline Op Rev.:  1949-1960')
#Notes:  clearly increasing average income over years, esp after '54


##This filtering done using the built-in 'stl' function
air.stl <- stl(airline,'preiodic')
air.sea = air.stl$time.series[,1]				#seasonal data from stl
air.nosea = airline-air.sea						#also equal to 3rd col in air.stl
air.ma2 <- filter(air.nosea,filter02)			#re-calc'ed trend data; m_hat
air.res <- airline-air.ma2-air.sea				#new residual data; REAL STUFF

#Plots of residual data, orig data 
ts.plot(airline,air.ma2,air.res,lty=c(1,3))
leg02.names = c('data','new trend','new resid')
legend(locator(1),leg02.names,lty = c(1,3))
#Notes: doesn't seem to be white noise

#Other plots, from end of Wash example.
dair <- diff(airline,12)
ts.plot(airline,,air.stl$time.series[,3],
		dair,lty=c(1,4))
leg03.names = c('Data','Seasonal','De-seasonal','Sea-Diff Data')
legend(locator(1),leg03.names,lty = c(1,4))