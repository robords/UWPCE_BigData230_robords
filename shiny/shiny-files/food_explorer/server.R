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

  output$CompoundYNControl <- renderUI({
    selectInput("filterCompound", "Filter for Compound",
                c(No = "NoCompound", Yes = "YesCompound")
    )
  })
  
  output$CompoundAVGMatchWithOrig <- renderUI({
    checkboxInput("CompoundAVGMatchWithOrig", "Avg by name of Orig Food"
    )
  })
    
  output$nutrientControls <- renderUI({
    selectizeInput("choose_nutrients", label = "Choose Nutrients(s)", choices = paste(unlist(query_nutrients)), 
                   multiple = TRUE, options = list(placeholder = 'Select Nutrient(s)'))
  })

  output$NutrientYNControl <- renderUI({
    selectInput("filterNutrient", "Filter for Nutrient",
                c(No = "NoNutrient", Yes = "YesNutrient")
    )
  })
  
  output$NutrientAVGMatchWithOrig <- renderUI({
    checkboxInput("NutrientAVGMatchWithOrig", "Avg by name of Orig Food"
    )
  })
  
  output$query_test <- renderPrint({
    a <- as.data.frame(query_return_nodes())
    x <- a$h.orig_food_common_name$value
    y <- a$avgContent
    data <- as.data.frame(x, y)
    return(x)
  })
  
  query_return_nodes <-reactive({
    #add quotes around the vector and convert it to a string
    inputs <- toString(paste0('"', input$choose_names, '"'))
    inputsnutrients <- toString(paste0('"',input$choose_nutrients, '"'))
    query_output <- if (input$filterNutrient == "NoNutrient") {
      paste('WITH [',inputs,'] as names
      MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
      WHERE f.name in names AND h.standard_content > 0
      RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content) as avgContent, h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC', sep="")
    }
    else {
      paste('WITH [',inputs,'] as names, [',inputsnutrients,'] as nutrients
      MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
      WHERE f.name in names AND h.standard_content > 0  AND n.name in nutrients
      RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content) as avgContent, h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC', sep="")
    }
    a <-query_output %>%
      call_neo4j(con)
    return(as.data.frame(as_tibble(a)))
  })
  output$Foods_Selected <- DT::renderDataTable({
    datatable(query_return_nodes(),
      extensions = 'Buttons', options = list(
      dom = 'Blfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
      pageLength = 10
      )
    )
  })
  
  query_return_compounds <-reactive({
    #add quotes around the vector and convert it to a string
    inputs <- toString(paste0('"', input$choose_names, '"'))
    inputscompounds <- toString(paste0('"',input$choose_compounds, '"'))
    query_output <- if (input$filterCompound == "NoCompound") {
      if (input$CompoundAVGMatchWithOrig == FALSE) {
      paste('WITH [',inputs,'] as names
      MATCH (f:Foods)-[h:IS_MADE_OF]->(n:Compounds)
      WHERE f.name in names AND h.standard_content > 0
      RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content) as avgContent, h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC', sep="")
        }
      else {
        paste('WITH [',inputs,'] as names
      MATCH (f:Foods)-[h:IS_MADE_OF]->(n:Compounds)
      WHERE f.name in names AND h.standard_content > 0
      RETURN DISTINCT n.name, avg(h.standard_content) as avgContent, h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC', sep="")
      }
    }
    else {
      if (input$CompoundAVGMatchWithOrig == FALSE) {
      paste('WITH [',inputs,'] as names, [',inputscompounds,'] as compounds
      MATCH (f:Foods)-[h:IS_MADE_OF]->(n:Compounds)
      WHERE f.name in names AND h.standard_content > 0  AND n.name in compounds
      RETURN DISTINCT h.orig_food_common_name,  n.name, avg(h.standard_content) as avgContent, h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC', sep="")
      } else {
        paste('WITH [',inputs,'] as names, [',inputscompounds,'] as compounds
      MATCH (f:Foods)-[h:IS_MADE_OF]->(n:Compounds)
      WHERE f.name in names AND h.standard_content > 0  AND n.name in compounds
      RETURN DISTINCT n.name, avg(h.standard_content) as avgContent, h.standard_content_unit, f.name
      ORDER BY avg(h.standard_content) DESC', sep="")
      }
    }
    a <-query_output %>%
      call_neo4j(con)
    return(as.data.frame(as_tibble(a)))
  })
  
  output$Compound_Foods_Selected <- DT::renderDataTable({
    datatable(query_return_compounds(),
              extensions = 'Buttons', options = list(
                dom = 'Blfrtip',
                buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                pageLength = 10
              )
    )
  })
  
  output$nutrientPlot <- renderPlotly({
    a <- head(as.data.frame(query_return_nodes()),10)
    x <- a$h.orig_food_common_name$value
    y <- a$avgContent$value
    #text <- a$h.standard_content_unit$value
    data <- as.data.frame(x, y)
    plot_ly(data, x = ~x, y = ~y, type = 'bar',
            marker = list(color = 'rgb(158,202,225)',
                          line = list(color = 'rgb(8,48,107)',
                                      width = 1.5))) %>%
      layout(title = "Food Nutrients",
             xaxis = list(title = ""),
             yaxis = list(title = ""))
  })
  
  output$compoundPlot <- renderPlotly({
    a <- head(as.data.frame(query_return_compounds()),10)
    x <- if (input$CompoundAVGMatchWithOrig == FALSE) {
      a$h.orig_food_common_name$value
    } else {
      a$f.name$value
    }
    y <- a$avgContent$value
    #text <- a$h.standard_content_unit$value
    data <- as.data.frame(x, y)
    plot_ly(data, x = ~x, y = ~y, type = 'bar',
            marker = list(color = 'rgb(158,202,225)',
                          line = list(color = 'rgb(8,48,107)',
                                      width = 1.5))) %>%
      layout(title = "Food Compounds",
             xaxis = list(title = ""),
             yaxis = list(title = ""))
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
