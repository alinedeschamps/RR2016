library(twitteR)

setup_twitter_oauth("XXX", "XXX", 
                    access_token = "XXX", 
                    access_secret = "XXX")
					

					
rr2016_fr <- searchTwitter("#rr2016", n = 500, lang = "fr", since = "2016-06-22", until = "2016-06-25")
rr2016_fr <- twListToDF(rr2016_fr)
rr2016_fr <- cbind(rr2016_fr, Lang = rep("FR", dim(rr2016_fr)[1]))

rr2016_en <- searchTwitter("#rr2016", n = 500, lang = "en", since = "2016-06-22", until = "2016-06-25")
rr2016_en <- twListToDF(rr2016_en)
rr2016_en <- cbind(rr2016_en, Lang = rep("EN", dim(rr2016_en)[1]))

rr2016_tweets <- rbind(rr2016_fr, rr2016_en)

write.csv2(rr2016_tweets, file = "./RR2016_TWITTER/www/rr2016_tweets.csv", row.names = FALSE, fileEncoding = "UTF-8")








