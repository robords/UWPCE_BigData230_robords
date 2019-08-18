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
  #output$query_test <- renderText({
  #  print(paste(unlist(query_names)))
  #})
  output$nameControls <- renderUI({
    selectizeInput("choose_names", label = "Choose Food(s)", choices = paste(unlist(query_names)), 
                multiple = TRUE, options = list(placeholder = 'Select Food(s)'))
  })

  output$query_test <- renderPrint({
    fPaste <- function(vec) sub(',\\s+([^,]+)$', ', \\1', toString(vec))
    a <- paste0('"', input$choose_names, '"')
    inputs <- fPaste(a)
#    inputs <- paste0('"', input$choose_names, '",', collapse = " ")
    query_output <- paste('MATCH (n:Food) WHERE n.name IN [',inputs,'] RETURN n',sep="")
    print(query_output)
  })
  
  query_return_nodes <-reactive({
    fPaste <- function(vec) sub(',\\s+([^,]+)$', ', \\1', toString(vec))
    a <- paste0('"', input$choose_names, '"')
    inputs <- fPaste(a)
    query_output <- paste('MATCH (n:Food) WHERE n.name IN [',inputs,'] RETURN n', sep="")
    query_output
  })
  output$Foods_Selected <- DT::renderDataTable({
    a <-query_return_nodes() %>%
      call_neo4j(con)
    as.data.frame(a)
  })
  
  query_table = paste0('MATCH p=()-[r:Has_Nutrient]->() RETURN p LIMIT 25;')
  output$Foods <- DT::renderDataTable({
    a <-query_table %>%
      call_neo4j(con)
    as.data.frame(a)
  })
  
})
