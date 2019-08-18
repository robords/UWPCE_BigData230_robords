#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(neo4r)
library(magrittr)
con <- neo4j_api$new(
  url = "http://172.28.1.3:7474/",
  user = "neo4j",
  password = "test"
)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$con_text <- renderText({
    print(paste(con$ping()))
    })
  output$query_test <- renderPrint({
    a <- 'MATCH p=()-[r:Has_Nutrient]->() RETURN p LIMIT 25;' %>%
      call_neo4j(con)
    
    print(a)
  })
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
