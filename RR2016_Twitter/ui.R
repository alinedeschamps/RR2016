library(shinydashboard)
library(rAmCharts)
library(dplyr)


shinyUI <- dashboardPage(skin = "purple",
                         
    dashboardHeader(title="#RR2016 Twitter"),
    
    dashboardSidebar(
      
      sidebarMenu(
        
        menuItem("Résultats", tabName = "tweets", icon = icon("twitter-square")), 
        menuItem("A propos", tabName = "infos", icon = icon("question-circle")),
        menuItem( tags$a(href = "rr2016_tweets.csv", icon("download"), "Télécharger les données", target="_blank"), tabName = "dl")

      )
      
    ),
      
    dashboardBody(tags$head(includeScript("./www/google-analytics.js")),
        
        tabItems(
          
          tabItem(tabName = "tweets",
                  
              column(width = 6,
                     
                  fluidRow(
                    
                    column(width = 6, 
                           
                           valueBox(ntot_tweets, 
                                    "Tweets et retweets", 
                                    color = "aqua", 
                                    icon = icon("twitter"), 
                                    width = NULL),
                           
                           valueBox(ntot_favorited, 
                                    "J'aime", 
                                    color = "maroon", 
                                    icon = icon("heart"), 
                                    width = NULL)
                           
                    ),
                    
                    column(width = 6,
                           
                           box(title = "Usage des Hashtags",
                               status = "success", solidHeader = TRUE,
                               amChartsOutput("hash_pie", height = 150), width = NULL)
                           
                    )
                    
                  ),
                  
                  fluidRow(
                    
                    tabBox(
                      side = "left",
                      selected = "Par Jour",
                      tabPanel("Par Jour", amChartsOutput("tw_jour", height = 250)),
                      tabPanel("Par Heure", amChartsOutput("tw_heure", height = 250)),
                      width = NULL
                    )
                    
                  )
                     
              ),
              
              column(width = 6,
               
                box(title = "Wordcloud",
                    status = "warning",
                    solidHeader = TRUE,
                    width = NULL,
                         
                    inputPanel(selectInput("Langue", label = "Langue :", selected="Français", c("Français", "Anglais"))),
                         
                    plotOutput("wordcloud")
                    )
                           
              )
              
          ),
              
          
          tabItem(tabName = "infos",
                  
              fluidRow( 
                  
                  HTML('<center><img src="header.png"></center>')
                  
              ),
              fluidRow(
                
                column(width = 12,
              
                  br(),     
                       
                  h4("Les résultats fournis concernent les tweets ayant été publiés sur Twitter entre le 22 et le 24 juin 2016 avec le hashtag", strong("#RR2016"), ". Il s'agit des tweets à propos des ",
                    a("5èmes rencontres R", href = "http://r2016-toulouse.sciencesconf.org/", target="_blank"), " qui ont eu lieu à Toulouse cette année."),
                  
                  br(),
                  
                  h4("Ce dashboard a été réalisé grâce au logiciel ", a("R", href = "https://www.r-project.org/", target="_blank"), " et aux packages suivants : ", strong("twitteR"), ", ", strong("shinydashboard"), ", ", strong("wordcloud"), " et ", strong("rAmCharts"), "."),
                  
                  br(),
                  
                  h4("Vous pouvez retrouver les sources de ce projet via ", a("mon github", href = "https://github.com/alinedeschamps/RR2016", target="_blank"), "."),
                  
                  h4("Vous pouvez également me retrouver sur twitter : ", a("@alinedeschamps", href = "https://twitter.com/alinedeschamps", target="_blank"), "ou sur :", a("LinkedIn", href = "https://fr.linkedin.com/in/alinedeschamps", target="_blank"), ".")
                  
                
                )
                
              )
                  
          )
          
        )
        
      )
      
)
                         