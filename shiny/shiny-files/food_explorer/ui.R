
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
    tabItems(
      tabItem(tabName = "nutrients",
              uiOutput("NutrientYNControl"),
              conditionalPanel(
                condition = "input.filterNutrient == 'YesNutrient'",
              uiOutput("nutrientControls")),
              uiOutput("NutrientAVGMatchWithOrig"),
              DT::dataTableOutput("Foods_Selected")
              ,plotlyOutput("nutrientPlot")
       ),
      tabItem(tabName = "compounds",
              uiOutput("CompoundYNControl"),
              conditionalPanel(
                condition = "input.filterCompound == 'YesCompound'",
                uiOutput("compoundControls")),
              uiOutput("CompoundAVGMatchWithOrig"),
              DT::dataTableOutput("Compound_Foods_Selected")
              ,plotlyOutput("compoundPlot")
      )
    )
       #,DT::dataTableOutput("Foods")
    )
  
))
