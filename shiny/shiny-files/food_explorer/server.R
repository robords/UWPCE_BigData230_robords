library(shiny)
library(neo4r)
library(magrittr)
library(DT)
library(plotly)

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
  
  query_names <- 'MATCH (n:Foods) RETURN DISTINCT n.name LIMIT 50' %>%
    call_neo4j(con)
  #output$query_test <- renderText({
  #  print(paste(unlist(query_names)))
  #})
  output$nameControls <- renderUI({
    selectizeInput("choose_names", label = "Choose Food(s)", choices = paste(unlist(query_names)), 
                multiple = TRUE, options = list(placeholder = 'Select Food(s)'))
  })

  output$query_test <- renderPrint({
    #add quotes around the vector and convert it to a string
    inputs <- toString(paste0('"', input$choose_names, '"'))
    query_output <- paste('WITH [',inputs,'] as names
    MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
    WHERE f.name in names AND h.standard_content > 0
    RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content), h.standard_content_unit, f.name
    ORDER BY avg(h.standard_content) DESC', sep="")
    print(query_output)
  })
  
  query_return_nodes <-reactive({
    #add quotes around the vector and convert it to a string
    inputs <- toString(paste0('"', input$choose_names, '"'))
    query_output <- paste('WITH [',inputs,'] as names
    MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
    WHERE f.name in names AND h.standard_content > 0
    RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content), h.standard_content_unit, f.name
    ORDER BY avg(h.standard_content) DESC', sep="")
    #query_output <- paste('MATCH (n:Foods) WHERE n.name IN [',inputs,'] RETURN n', sep="")
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
