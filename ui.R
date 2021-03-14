## app.R ##
library(shinydashboard)
library(shiny)
library(plotly)

header <- dashboardHeader(title = "Basic dashboard",disable=FALSE)

sidebar <- dashboardSidebar(
  fixedPanel(
    sidebarMenu(
      id="sidebar",
      menuItem("Principal", tabName = "principal", icon = icon("home")),
      menuItem("Widgets", icon = icon("th"), tabName = "widgets")
      
    )
  )
)

body <- dashboardBody(
  # Boxes need to be put in a row (or column)
  tabItems(
    tabItem(
      tabName = "principal",
      fluidRow(
        box(uiOutput("selProd_MAPA"),
            uiOutput("selVar_MAPA"),
            checkboxInput("checkbox_diffMAPA","Mostrar diferencias mensuales",value=FALSE),
            plotlyOutput("MAPA"),
            width=12),
      ),
      fluidRow(
        box(uiOutput("selVar_MAPAVitC"),
            checkboxInput("checkbox_diffMAPAVitC","Mostrar diferencias mensuales",value=FALSE),
            plotlyOutput("MAPAVitC"),
            width=12),
      ),
    ),
    tabItem(tabName = "widgets",
            h2("Widgets tab content")
    )
  )
)
ui <- dashboardPage(header,sidebar,body)