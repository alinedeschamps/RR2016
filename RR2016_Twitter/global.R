# Chargement des données et transformation des dates

donnees_twitter <- read.csv("./www/rr2016_tweets.csv", header = TRUE, sep = ";", encoding = "ISO-8859-1")

donnees_twitter$created <- as.POSIXct(donnees_twitter$created, format = "%Y-%m-%d %H:%M:%S")


# Calculs pour les deux valueBox

ntot_tweets <- dim(donnees_twitter)[1]

ntot_favorited <- sum(donnees_twitter$favoriteCount)


# Pie chart des hashtags

tweets_only <- donnees_twitter[which(donnees_twitter$isRetweet == FALSE),]
tweets_only_text <- enc2utf8(as.character(tweets_only$text))

tot_tweets <- dim(tweets_only)[1]
both_hastags <- length(grep("#rstats", tweets_only_text))
one_hastag <- tot_tweets - both_hastags

hashtags <- data.frame(label = c("#RR2016", "#RR2016 #rstats"), 
                       value = c(one_hastag, both_hastags))


# Données pour graphiques par dates et heures

dates <- as.Date(donnees_twitter$created)
heure_d1 <- format(donnees_twitter$created[which(dates == "2016-06-22")], "%H")
heure_d2 <- format(donnees_twitter$created[which(dates == "2016-06-23")], "%H")
heure_d3 <- format(donnees_twitter$created[which(dates == "2016-06-24")], "%H")

byDay <- data.frame(dates = c("2016-06-22", "2016-06-23", "2016-06-24"),
                    tweets = c(length(heure_d1), length(heure_d2), length(heure_d3)))

hour <- c(paste0("0", 0:9), as.character(10:23))

d1_h <- as.data.frame(table(heure_d1))
d2_h <- as.data.frame(table(heure_d2))
d3_h <- as.data.frame(table(heure_d3))

d1_h <- merge(data.frame(heure_d1 = hour), d1_h, by ="heure_d1", all = TRUE)
d1_h$Freq[is.na(d1_h$Freq)] <- 0

d2_h <- merge(data.frame(heure_d2 = hour), d2_h, by ="heure_d2", all = TRUE)
d2_h$Freq[is.na(d2_h$Freq)] <- 0

d3_h <- merge(data.frame(heure_d3 = hour), d3_h, by ="heure_d3", all = TRUE)
d3_h$Freq[is.na(d3_h$Freq)] <- 0

hours <- c("Minuit", paste0(1:23, " h"))

byHour <- data.frame(heures = hours,
                     day1 = d1_h$Freq,
                     day2 = d2_h$Freq,
                     day3 = d3_h$Freq)


# Wordclouds par langue

 library(wordcloud)
 library(tm)


# cleaning function :
myCleaningFunction <- function(x, name_list) {

  u <- enc2utf8(as.character(x))
  
  s <- gsub("#rstats", "", u, ignore.case = TRUE)
  s <- gsub("#RR2016", "", s, ignore.case = TRUE)
  s <- gsub("RT @", "", s)

  for(k in 1:length(name_list)) {

    s <- gsub(name_list[k], "", s, ignore.case = TRUE)

  }

  s <- gsub("@", "", s)
  s <- gsub("(https://[^\\s]+)", "", s, perl = TRUE)

  return(s)

}

names_tw <- unique(donnees_twitter$screenName)
names_tw <- enc2utf8(as.character(names_tw))


# FR :

FR_text <- donnees_twitter$text[which(donnees_twitter$Lang == "FR")]

FR_text_c <- sapply(FR_text, myCleaningFunction, name_list = names_tw)


FR_text_corpus <- Corpus(VectorSource(FR_text_c))

FR_text_corpus <- tm_map(FR_text_corpus, content_transformer(tolower))
FR_text_corpus <- Corpus(VectorSource(FR_text_corpus))
FR_text_corpus <- tm_map(FR_text_corpus, removePunctuation)
FR_text_corpus <- tm_map(FR_text_corpus, function(x) removeWords(x,stopwords("fr")))
FR_text_corpus <- tm_map(FR_text_corpus, function(x) removeWords(x,c("cest", "ceux", "celles")))
FR_text_corpus <- tm_map(FR_text_corpus, stripWhitespace)


# EN :

EN_text <- donnees_twitter$text[which(donnees_twitter$Lang == "EN")]

EN_text_c <- sapply(EN_text, myCleaningFunction, name_list = names_tw)


EN_text_corpus <- Corpus(VectorSource(EN_text_c))

EN_text_corpus <- tm_map(EN_text_corpus, content_transformer(tolower))
EN_text_corpus <- Corpus(VectorSource(EN_text_corpus))
EN_text_corpus <- tm_map(EN_text_corpus, removePunctuation)
EN_text_corpus <- tm_map(EN_text_corpus, function(x) removeWords(x,stopwords("en")))
EN_text_corpus <- tm_map(EN_text_corpus, stripWhitespace)

