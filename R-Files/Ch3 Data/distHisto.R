load('distance.rda')
par(mfrow = c(2,2))
hist(distance, xlab = '', main = 'breaks = 11',
	 ylab = 'frequency', col = 'gray90')
hist(distance, xlab = '', main = 'breaks = 20',
	 ylab = '',breaks = 20, col = 'blue')
hist(distance, xlab = 'distance (m)', main = 'breaks = 8',
	 ylab = 'frequency',breaks = 8, col = 'red')
hist(distance, xlab = 'distance (m)', main = 'breaks = 4',
	 ylab = '',breaks = 4, col = 'green')