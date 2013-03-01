# hw data set...
heights.weights <- read.csv('/Users/sinn/ML_for_Hackers/05-Regression/data/01_heights_weights_genders.csv', header=TRUE, sep = ',')
coef(lm(Weight ~ Height, data = heights.weights))

height.to.weight <- function(height, a, b) 
{
	return(a + b*height)
}

# I'm going to go ahead and say that this is likely the most bene 
# thing in this entire chapter:
?optim

# skipped some least squares / optimization talk..
# ridge regression (uses regularization)
ridge.error <- function(heights.weights, a, b, lambda)
{
	predictions <- with(heights.weights, height.to.weight(Height, a, b))
	errors <- with(heights.weights, Weight - predictions)
	return(sum(errors^2) + lambda*(a^2 + b^2))
}

lambda <- 1

optim(c(0,0),		# starting x value
	  function (x) 	# making ridge.error an anon. function 
	  {
	  	ridge.error(heights.weights, x[1], x[2], lambda)
	  })
	  
# code breaking shit:
generate.random.cipher <- function()
{
	cipher <- list()
	
	inputs <- english.letters	# c() defined in text
	outputs <- english.letters[sample(1:length(english.letters),
	length(english.letters))]	# generates a p-rando ordering of alpha
	
	for (index in 1:length(english.letters))
	{
		cipher[[inputs[index]]] <- outputs[index]	# what's w/ the double bracks?
	}
	
	return(cipher)	#i'm assuming return (cipher) works too?
}

modify.cipher <- function(cipher, input, output)
{
	new.cipher <- cipher
	new.cipher[[input]] <- output
	old.output <- cipher[[input]]
	collateral.input <- names(which(sapply(names(cipher),
						function (key) {cipher[[key]]}) == output)) #wtf is key?
	new.cipher[[collateral.input]] <- old.input
	return(new.cipher)
}

propose.modified.cipher <- function(cipher)
{
	input <- sample(names(cipher), 1)
	output <- sample(englich.letters, 1)	# doesn't prevent getting same letter
	return(modify.cipher(cipher, input, output))
}

# lexical database from word freq on wikipedia:
load('path/data/lexical_database.Rdata')

one.gram.probability <- function(one.gram, lexical.database = list())
{
	lexical.probability <- lexical.database[[one.gram]]
	
	if (is.null(lexical.probability) || is.na(lexical.probability))
	{
		return(.Machine$double.eps)		# smallest floating pt
	}
	else
	{
		return(lexical.probability)
	}
}
# they end up using log probabilites, so design a function to incriment text
# proabbility by incrimenting over words, calling one.gram.prob, taking log,
# and adding to overall log probability...

metropolis.step <- function(text, cipher, lexical.database = list())
{
	proposed.cipher <- propose.modified.cipher(cipher)
	
	lp1 <- log.prob.of.text(text, cipher, lexical.database)
	lp2 <- log.prob.of.text(text, proposed.cipher, lexical.database)
	
	if (lp2 > lp1)
	{
		return(proposed.cipher)
	}
	else
	{
		a <- exp(lp2 - lp1)		# since are log scores..
		x <- runif(1)
		if (x < a)
		{
			return(proposed.cipher)
		}
		else
		{
			return(cipher)
		}
	}
}

# algorithm just calls metro step for set number of iterations, nothing fancy
# also stores results (text decription, scores, etc.) in data.frame for view.
# algorithm actually finds correct cipher for sample, but then moves past 
# it...issues w/ objective function, scores for words, etc.; annealing