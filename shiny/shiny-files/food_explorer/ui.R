#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(DT)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
  
  # Application title
  dashboardHeader(title = "Shiny Food DB"),
  
  # Sidebar with a slider input for number of bins 
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
