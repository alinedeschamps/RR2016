library(shinydashboard)
library(rAmCharts)
library(dplyr)

shinyServer <- function(input, output) {  
  
  # pie chart of hashtags
  
  output$hash_pie <- renderAmCharts({

    amPie(hashtags, 
          export = TRUE, 
          creditsPosition = "bottom-right", 
          show_values = FALSE,
          lengend = TRUE) %>% 
      addTitle(text = "Tweets only (no RT)", size = 10, color = "#68838B")
    
  })
  
  
  # barplot of tweets and retweets by day
  
  output$tw_jour <- renderAmCharts({
    
    amBarplot(x = "dates", 
              y = "tweets", 
              data = byDay, 
              creditsPosition = "top-right",
              export = TRUE,
              main = "Nombre de tweets et retweets", mainColor = "#68838B")
    
  })

  
  # lines graph of tweets and retweets by day and by hour
  
  output$tw_heure <- renderAmCharts({
  
      amSerialChart(dataProvider = byHour, categoryField = "heures", creditsPosition = "top-right") %>%
        addGraph(valueField = "day1", title = "22 juin 2016", balloonText = "22 juin 2016 : [[value]]") %>%
        addGraph(valueField = "day2", title = "23 juin 2016", balloonText = "23 juin 2016 : [[value]]") %>%
        addGraph(valueField = "day3", title = "24 juin 2016", balloonText = "24 juin 2016 : [[value]]") %>%
        addTitle(text = "Nombre de tweets et retweets", color = "#68838B") %>%
        addValueAxis(title = "Tweets et retweets") %>%
        setChartCursor() %>%
        setExport(enabled = TRUE)
        
  })

  
  # wordclouds
  
  output$wordcloud <- renderPlot({
    
    if(input$Langue == "Français") {
      
      donnees_wordcloud <- FR_text_corpus
      mw <- 50
      mf <- 4
      set.seed(123654)
      
    } else {
      
      donnees_wordcloud <- EN_text_corpus
      mw <- 30
      mf <- 4
      set.seed(1)
    }
    
    wordcloud(donnees_wordcloud, max.words = mw, min.freq = mf, colors = brewer.pal(11, "Spectral")[-(5:7)])
    
  })
  

}
  
  
  
