# useful fucntion, multiplot:
multiplot <- function(..., plotlist=NULL, cols) {
    require(grid)

    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)

    numPlots = length(plots)

    # Make the panel
    plotCols = cols                          # Number of columns of plots
    plotRows = ceiling(numPlots/plotCols) # Number of rows needed, calculated from # of cols

    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(plotRows, plotCols)))
    vplayout <- function(x, y)
        viewport(layout.pos.row = x, layout.pos.col = y)

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
        curRow = ceiling(i/plotCols)
        curCol = (i-1) %% plotCols + 1
        print(plots[[i]], vp = vplayout(curRow, curCol ))
    }

}



# load the data file
setwd("/Users/sinn/ML_for_Hackers/02-Exploration/")
data.file <- file.path('data', '01_heights_weights_genders.csv')
heights.weights <- read.csv(data.file, header = TRUE, sep = ',')

#basic stats:
summary(heights.weights$Height)
sd(heights.weights$Height); var(height.weights$Height)
summary(heights.weights$Weight)
sd(heights.weights$Weight); var(height.weights$Weight)

# some simple plots
ggplot(heights.weights, aes(x = Height)) + geom_histogram(binwidth = 1)
ggplot(heights.weights, aes(x = Height)) + geom_histogram(binwidth = 5)
ggplot(heights.weights, aes(x = Height)) + geom_histogram(binwidth = 1)
ggplot(heights.weights, aes(x = Height)) + geom_density()
ggplot(heights.weights, aes(x = Height, fill = Gender)) + geom_density()
ggplot(heights.weights, aes(x = Weight, fill = Gender)) + geom_density()

# using multiplot:
p1 <- ggplot(heights.weights, aes(x = Weight, fill = Gender)) + geom_density()
p2 <- ggplot(heights.weights, aes(x = Height, fill = Gender)) + geom_density()
multiplot(p1, p2, cols=1)

# scatter w/ smooth pattern
ggplot(heights.weights, aes(x = Height, y = Weight)) + geom_point() + geom_smooth()		# notice curve in "pattern"
ggplot(heights.weights, aes(x = Height, y = Weight)) + geom_point() + geom_smooth() + facet_grid(Gender ~ .)
ggplot(heights.weights, aes(x = Height, y = Weight, color = Gender)) + geom_point() + geom_smooth()		# more useful

# basic classification:
# add new feature / "factor" column
heights.weights <- transform(heights.weights, Male = ifelse(Gender == 'Male', 1, 0))
#develop a logit model for exp. data (mistake: not setting aside test set...)
logit.model <- glm(Male ~ Height + Weight, data = heights.weights, 
	family = binomial(link = 'logit'))
# plot with semi-"separating hyperplane" (semi since both genders on both sides)
ggplot(heights.weights, aes(x = Height, y = Weight, color = Gender)) +
 	geom_point() +
 	stat_abline(intercept = - coef(logit.model)[2] / coef(logit.model)[1],
 		slope = - coef(logit.model)[2] / coef(logit.model)[3],
 		geom = 'abline',
 		color = 'black')