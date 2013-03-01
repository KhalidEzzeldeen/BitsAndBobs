western.africa <-1; northern.europe <-2
region.name <- c("West. Af", 'North. Eu')
file.name <- c('WestAf.tex', 'NorthEu.tex')

## 1. Import Data
#library(RODBC) ; c <- odbcConnect('who')
#sqlTables(c) ; who <- sqlFetch(c, 'MyFormat')
#odbcClose(c) ; save(who, file = 'who.fertility.mortality.rda')

load('who.fertility.mortality.rda')
who <- who.fertility.mortality

# comment / uncomment for desired table
# region = western.africa
region = northern.europe

# 2. make data frame
ifelse(region==western.africa,
	   rows <- c((1:dim(who)[1])[who$region=="Western Africa"]), 
	   rows <- c((1:dim(who)[1])[who$region=="Northern Europe"]))
rows <- na.omit(rows)
mort <- who$'under 5 mort'[rows]
stats <- c(mean(mort,na.rm=T),
		   var(mort, na.rm=T),
		   sd(mort,na.rm=T))
mort <-data.frame(c(mort,stats))
rnames <- c(as.character(who$country[rows],na.rm=T),
			'\\hline Mean', 'Var', 'Stand Dev')
dimnames(mort) <- list(rnames, c('Mortality'))

# 3. Table in LaTeX format
library(Hmisc)
cap1 <- paste(region.name[region],
			  ', children (under 5) mort')
cap2 <- 'per 1000 children under 5.'
latex(mort,file = file.name[region],
	  caption = paste(cap1,cap2),
	  label = paste('table: ', region.name[region], 'mortality'),
	  cdec = 2,
	  rowlabel = 'Country',
	  na.blank = T,
	  where = '!htbp',
	  ctable = T)