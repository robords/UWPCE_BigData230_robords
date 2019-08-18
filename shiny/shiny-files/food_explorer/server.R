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
library(DT)

con <- neo4j_api$new(
  url = "http://172.28.1.3:7474/",
  user = "neo4j",
  password = "test"
)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  output$con_text <- renderText({
    print(paste(con$ping()))
    })
  
  query_names <- 'MATCH (n:Food) RETURN DISTINCT n.name LIMIT 50' %>%
    call_neo4j(con)
  output$query_test <- renderText({
    print(paste(unlist(query_names)))
  })
  updateSelectizeInput(session, 'choose_names', choices = paste(unlist(query_names)), server = TRUE)
  query_return_nodes = paste('MATCH (n:Food) WHERE n.name IN ["Pineapple", "Dill"] RETURN n')
  output$Foods_Selected <- DT::renderDataTable({
    a <-query_return_nodes %>%
      call_neo4j(con)
    as.data.frame(a)
  })
  
  query_table = paste('MATCH p=()-[r:Has_Nutrient]->() RETURN p LIMIT 25;')
  output$Foods <- DT::renderDataTable({
    a <-query_table %>%
      call_neo4j(con)
    as.data.frame(a)
  })
  
})
