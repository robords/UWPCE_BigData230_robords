
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)

# Define UI for application
shinyUI(dashboardPage(
  
  # Application title
  dashboardHeader(title = "Shiny Food DB"),
  
  dashboardSidebar(
      #verbatimTextOutput("query_test"),
      sidebarMenu(
        menuItem("Explore Compounds", tabName = "compounds", icon = icon("dashboard")),
        menuItem("Explore Nutrients", tabName = "nutrients", icon = icon("th"))
      ),
      "Add a food to begin exploring",
      uiOutput("nameControls")
    ),
    
    # Show a plot of the generated distribution
  dashboardBody(
       textOutput("con_text"),
       DT::dataTableOutput("Foods_Selected")
       #,DT::dataTableOutput("Foods")
    )
  
))
