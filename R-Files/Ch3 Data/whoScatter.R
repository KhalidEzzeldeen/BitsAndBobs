who.fert.mort <- read.table(
	'who.by.continents.and.regions.txt', sep='\t',
 	header=T)
names(who.fert.mort) <- c('country', 'continent', 'region',
						  'population', 'density', '% urban',
						  '% growth', 'birth rate','death rate',
						  'fertility', 'under 5 mortality')
						  
save(who.fert.mort, file = 'who.fert.mort.rda')
d <- who.fert.mort
plot(d[, 'birth rate'], d[, 'death rate'],
	 xlab = 'birth rate', ylab = 'death rate')
unusual <- identify(d[,8], d[,9], labels = d[,1])
points(d[unusual,8], d[unusual, 9], pch = 19)