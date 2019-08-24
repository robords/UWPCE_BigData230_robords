
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)

# Define UI for application
shinyUI(dashboardPage(
  
  # Application title
  dashboardHeader(title = "Shiny Food DB"),
  
  dashboardSidebar(
      verbatimTextOutput("query_test"),
      sidebarMenu(
        menuItem("Explore Compounds", tabName = "compounds", icon = icon("dashboard")),
        menuItem("Explore Nutrients", tabName = "nutrients", icon = icon("th"))
      ),
      "Add a food to begin exploring",
      uiOutput("nameControls")
    ),
    
    # Show a plot of the generated distribution
  dashboardBody(
    tabItems(
      tabItem(tabName = "nutrients",
              uiOutput("NutrientYNControl"),
              conditionalPanel(
                condition = "input.filterNutrient == 'YesNutrient'",
              uiOutput("nutrientControls")),
              DT::dataTableOutput("Foods_Selected")
       ),
      tabItem(tabName = "compounds",
              uiOutput("compoundControls")
      )
    )
       #,DT::dataTableOutput("Foods")
    )
  
))
