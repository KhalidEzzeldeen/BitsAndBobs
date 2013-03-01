library(ggplot2)
library(tm)

get.msg <- function(path)
+ {
+   con <- file(path, open = "rt", encoding = "latin1")
+   text <- readLines(con)
+   # The message always begins after the first full line break
+   msg <- text[seq(which(text == "")[1] + 1, length(text), 1)]
+   close(con)
+   return(paste(msg, collapse = "\n"))
+ }


spam.path <- file.path("data", "spam/")
spam.docs <- dir(spam.path)
spam.docs <- spam.docs[which(spam.docs!="cmds")]
all.spam <- sapply(spam.docs, function(p) get.msg(paste(spam.path,p,sep="")))	#use of anon function here to apply get.msg to all emails