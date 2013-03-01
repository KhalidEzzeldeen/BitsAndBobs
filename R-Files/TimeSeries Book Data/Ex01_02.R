wash<-ts(scan('washpower.dat'),start=1980,freq=4)

#Part 1
wash.ma<-filter(wash,c(1/3,1/3,1/3))
leg.names<-c('Data','Smoothed Data')
ts.plot(wash,wash.ma,lty=c(1,2), 
	main='Wash Water Power Co Op Rev.:  1980-1986',
	ylab='Thousands of Doll',xlab='Year')
legend(locator(1),leg.names,lty=c(1,2))
wash.mat<-matrix(wash,nrow=4)
boxplot(as.data.frame(wash.mat),names=as.character(seq(1980,1986)),
	boxcol=-1,medcol=1,main='Wash Water Power Co Op Rev.:  1980-1986',
	ylab='Thousands of Dollars')
	
#Part 2:  Assess seasonality
	#Step1:  estimate overall trend
	#Step2:  get averages in the deviations over all data to calc sea trend
	#Step3:  re-estimate trend in data 
	#Step4:  get / check residuals to detect further structures
	
washsea.ma<-filter(wash,c(1/8,rep(1/4,3),1/8))		#overall trend comp.
wash.sea<-c(0,0,0,0)								#seasonal trend comp.
for(i in 1:2){
	for(j in 1:6){
		wash.sea[i]<-wash.sea[i]+
			(wash[i+4*j][[1]]-washsea.ma[i+4*j][[1]])
	}
}
for(i in 3:4){
	for(j in 1:6){
		wash.sea[i]<-wash.sea[i]+
			(wash[i+4*(j-1)][[1]]-washsea.ma[i+4*(j-1)][[1]])
	}
}
wash.sea<-(wash.sea-mean(wash.sea))/6
wash.sea1<-rep(wash.sea,7)
wash.nosea<-wash-wash.sea
wash.ma2<-filter(wash.nosea,c(1/8,rep(1/4,3),1/8))	#re-est. trend
wash.res<-wash-wash.ma2-wash.sea					#residuals
write(wash.sea1,file='out.dat')
wash.seatime<-ts(scan('out.dat'),start=1980,freq=4)
#Convert from non-time series obj. to time series obj
ts.plot(wash,wash.nosea,wash.seatime)

#Shortcut
wash.stl<-stl(wash,'periodic')
dwash<-diff(wash,4)
ts.plot(wash,wash.stl$sea,wash.stl$rem,dwash)