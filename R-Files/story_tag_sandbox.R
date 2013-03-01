library('tm')
library('ggplot2')

# Basic loading stuff
tag.story.source.file <- file.path('/Users/sinn/Desktop/', 'tag_story_source_list_01.txt')
tag.story.source <- read.csv(tag.story.source.file, header = FALSE, sep = '\t', encoding='utf8')
names(tag.story.source) <- c('Tag', 'Story', 'Source')
tss.df <- as.data.frame(tag.story.source)

# getting tag counts:
tag.counts <- as.data.frame(table(tag.story.source$Tag))
names(tag.counts) <- c('Tag', 'Count')
sub.tag.counts <- subset(tag.counts, Count>2)		# bc don't want too many
plot(sort(sub.tag.counts$Count))

#Build the tag-tag co-occurance matrix, using only the >2 tags
tag.cooccur <- matrix(data=0, 
					  nrow=length(sub.tag.counts$Tag),
					  ncol=length(sub.tag.counts$Tag),
					  dimnames = list(sub.tag.counts$Tag,
					  sub.tag.counts$Tag))
dim(tag.cooccur) == length(sub.tag.counts$Tag)
tag.cooccur[tag.counts$Tag[10], tag.counts$Tag[555]]	# access cells w/ names

stories <- unique(tag.story.source$Story)
sources <- unique(tag.story.source$Source)

# There has got to be a better way to do this...
create.tag.tag <- function(tag.tag.mat, tag.story.source) {
	
	for(s in unique(tag.story.source$Story)) {
		temp <- subset(tag.story.source, tag.story.source$Story==s)$Tag
		for(t in temp[1:length(temp)-1]) {
			temp_sub <- temp[2:length(temp)]
			for(s in temp_sub) {
				try(tag.tag.mat[t,s] <- tag.tag.mat[t,s] + 1, silent=TRUE)
				}
			}
		}
	return(tag.tag.mat)
	}
	
tag.cooccur <- create.tag.tag(tag.cooccur, tag.story.source)

library(rggobi)
tag.cooccur.dist <- dist(tag.cooccur)
tag.cooccur.dend <- hclust(tag.cooccur.dist, method="average")
plot(tag.cooccur.dend)


# and again...new file where spaces in tags are stripped and set of tags
# for each doc is treated as a text...
tag.as.text <- read.csv(tag.as.text.file,
						header=FALSE, 
						sep = '\n', 
						stringsAsFactors=FALSE, 
						encoding='utf8')
tag.corp <- Corpus(DataframeSource(tag.as.text), 
				   readerControl = list(language = 'eng'))

inspect(dtm.story.tags[1:5,155:160])
findAssocs(dtm.story.tags, "ancientworld", 0.1)
findAssocs(dtm.story.tags, "animals", 0.3)
findAssocs(dtm.story.tags, "dogs", 0.4)
findAssocs(dtm.story.tags, "humour", 0.4)  #...etc.