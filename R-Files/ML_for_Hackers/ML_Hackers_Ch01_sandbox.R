library(ggplot2)

setwd("/Users/sinn/ML_for_Hackers/01-Introduction/data") # set directory
ufo<-read.delim("ufo/ufo_awesome.tsv", sep="\t", stringsAsFactors=FALSE,
				header=FALSE, na.strings="")
names(ufo)<-c("DateOcc", "DateReported", "Loc", "ShortDescrip", 
			  "Duration", "LongDescrip")
ufo$DateOcc<-as.Date(ufo$DateOcc, format="%Y%m%d")	# this returns an error
# why?  look for entries w/ bad formatting:
head(ufo[which(nchar(ufo$DateOcc)!=8 | nchar(ufo$DateReported)!=8),1])
good.rows<-ifelse(nchar(ufo$DateOcc)!=8 | nchar(ufo$DateReported)!=8,FALSE,TRUE)
ufo<-ufo[good.rows,]
# now repeat previous:
ufo$DateOcc<-as.Date(ufo$DateOcc, format="%Y%m%d")
ufo$DateReported<-as.Date(ufo$DateReported, format="%Y%m%d")

# this function obtains location data; if present in the expected format,
# returns what is found, else returns "NA"
get.location<-function(l) {
	split.location<-tryCatch(strsplit(l,",")[[1]], 
	error=function(e) return(c(NA,NA)))
	clean.location<-gsub("^ ", "",split.location)
	if (length(clean.location)>2) {
		return(c(NA,NA))
	}
	else {
		return(clean.location)
	}
}
# create location list with get.location():
city.state<-lapply(ufo$Loc, get.location)
loc.matrix<-do.call(rbind, city.state) 		# change list to matrix
# add new columns to the data matrix
ufo<-transform(ufo, USCity=loc.matrix[,1], USState=tolower(loc.matrix[2]),
				stringsAsFactors=FALSE) 	# insert new locs into ufo matrix

# for some reason, they don't have this in a file...fuckers
us.states<-c('al', 'ak', 'az', 'ar', 'ca', 'co', 'ct', 'de', 'dc', 'fl', 'ga', 'hi', 'id', 'il', 'in', 'ia', 'ks', 'ky', 'la', 'me', 'md', 'ma', 'mi', 'mn', 'ms', 'mo', 'mt', 'ne', 'nv', 'nh', 'nj', 'nm', 'ny', 'nc', 'nd', 'oh', 'ok', 'or', 'pa', 'ri', 'sc', 'sd', 'tn', 'tx', 'ut', 'vt', 'va', 'wa', 'wv', 'wi', 'wy ')
# finds the non-us state entries and sets location to NA, NA
ufo$USState<-us.states[match(ufo$USState,us.states)]
ufo$USCity[is.na(ufo$USState)]<-NA
# grab subset of data that is in US
ufo.us<-subset(ufo, !is.na(ufo$USState))
# create a plot of the data, and save (w/o displaying)
quick.hist<-ggplot(ufo.us, aes(x=DateOcc))+geom_histogram()+scale_x_date(major="50 years")		# "years" is a key word here, can't abrv
ggsave(plot=quick.hist, filename="./images/quick_hist.png", height=6, width=8)
print(quick.hist)		# shows histogram
# take modern subset:
ufo.us<-subset(ufo.us, DateOcc>=as.Date("1990-01-01"))
quick.hist<-ggplot(ufo.us, aes(x=DateOcc))+geom_histogram()+scale_x_date(major="1 years")
print(quick.hist)
# want to do some time-series analy by year-month, so need new column:
ufo.us$YrMo<-strftime(ufo.us$DateOcc, format="%Y-%m")

# want to get some metrics on new data
sightings.counts<-ddply(ufo.us,.(USState,YrMo), nrow)
# need to fill in missing Y-m with 0's
date.range<-seq.Date(from=as.Date(min(ufo.us$DateOcc)),
			to=as.Date(max(ufo.us$DateOcc)), by="month")
date.strings<-strftime(date.range, "%Y-%m")
states.dates<-lapply(us.states,function(s) cbind(s,date.strings))
states.dates<-data.frame(do.call(rbind, states.dates), stringsAsFactors=FALSE)
# merge the complete yr-mo list with sightings.counts:
all.sightings<-merge(states.dates,sightings.counts, by.x=c("s", "date.strings"), by.y=c("USState", "YrMo"),all=TRUE)
# prep matrix for plotting and such:
names(all.sightings)<-c("USState", "YearMonth", "SightingsCount")	#change names
all.sightings$SightingsCount[is.na(all.sightings$SightingsCount)]<-0
all.sightings$YearMonth<-as.Date(rep(date.range,length(us.states))) #rep vector of dates, length us.states
all.sightings$USState<-as.factor(toupper(all.sightings$USState))

# create a plot, save as .pdf:
state.plot<-ggplot(all.sightings, aes(x=YrMo,y=SightingsCount))+
	geom_line(aes(color="darkblue"))+
	facet_wrap(~State,nrow=10,ncol=5)+
	theme_bw()+
	scale_color_manual(values=c("darkblue"="darkblue"),legend=FALSE)+
	scale_x_date(major="5 years", format="%Y")+
	xlab("Time")+ylab("Number of Sightings")+
	opts(title="Num of UFO Sightings by Yr-Mo and US State (1990-2010)")
ggsave(plot=state.plot, filename="./images/ufo_sightings.pdf", width=14, height=8.5)