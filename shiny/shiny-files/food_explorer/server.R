library(shiny)
library(neo4r)
library(magrittr)
library(DT)
library(plotly)
library(dplyr)

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
  
  query_names <- 'MATCH (n:Foods) RETURN DISTINCT n.name LIMIT 200' %>%
    call_neo4j(con)
  
  query_compounds <- 'MATCH (n:Compounds) RETURN DISTINCT n.name LIMIT 100' %>%
    call_neo4j(con)
  
  query_nutrients <- 'MATCH (n:Nutrients) RETURN DISTINCT n.name LIMIT 100' %>%
    call_neo4j(con)

  output$nameControls <- renderUI({
    selectizeInput("choose_names", label = "Choose Food(s)", choices = paste(unlist(query_names)), 
                multiple = TRUE, options = list(placeholder = 'Select Food(s)'))
  })
  
  output$compoundControls <- renderUI({
    selectizeInput("choose_compounds", label = "Choose Compounds(s)", choices = paste(unlist(query_compounds)), 
                   multiple = TRUE, options = list(placeholder = 'Select Compound(s)'))
  })
  
  output$nutrientControls <- renderUI({
    selectizeInput("choose_nutrients", label = "Choose Nutrients(s)", choices = paste(unlist(query_nutrients)), 
                   multiple = TRUE, options = list(placeholder = 'Select Nutrient(s)'))
  })

  output$NutrientYNControl <- renderUI({
    selectInput("filterNutrient", "Filter for Nutrient",
                c(Yes = "YesNutrient", No = "NoNutrient")
    )
  })
  output$query_test <- renderPrint({
    #add quotes around the vector and convert it to a string
    inputs <- toString(paste0('"', input$choose_names, '"'))
    inputsnutrients <- toString(paste0('"',input$choose_nutrients, '"'))
    query_output <- if (input$filterNutrient == "NoNutrient") {
        paste('WITH [',inputs,'] as names
      MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
      WHERE f.name in names AND h.standard_content > 0
      RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content), h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC LIMIT 2', sep="")
    }
    else {
        paste('WITH [',inputs,'] as names, [',inputsnutrients,'] as nutrients
      MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
      WHERE f.name in names AND h.standard_content > 0  AND n.name in nutrients
      RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content), h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC LIMIT 2', sep="")
    }
    a <-query_output %>%
      call_neo4j(con)
    return(as.data.frame(as_tibble(a)))
    print(query_output)
    #query_output <- paste('MATCH (n:Foods) WHERE n.name IN [',inputs,'] RETURN n', sep="")
  })
  
  query_return_nodes <-reactive({
    #add quotes around the vector and convert it to a string
    inputs <- toString(paste0('"', input$choose_names, '"'))
    query_output <- paste('WITH [',inputs,'] as names
    MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
    WHERE f.name in names AND h.standard_content > 0
    RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content), h.standard_content_unit, f.name
    ORDER BY avg(h.standard_content) DESC', sep="")
    a <-query_output %>%
      call_neo4j(con)
    return(as.data.frame(as_tibble(a)))
  })
  output$Foods_Selected <- DT::renderDataTable({
    query_return_nodes()
  })
  
  query_table = paste0('MATCH p=()-[r:Has_Nutrient]->() RETURN p LIMIT 25;')
  output$Foods <- DT::renderDataTable({
    a <-query_table %>%
      call_neo4j(con)
    #(function(x)data.frame(Type=names(x), Value=x))(a)
    return(as.data.frame(a))
    #return(a)
  })
  
})
