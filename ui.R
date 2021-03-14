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
      menuItem("Precios", tabName = "precios", icon = icon("th")),
      menuItem("Comercio Exterior", tabName = "comercioExterior", icon = icon("th"))
      
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
    
    tabItem(tabName = "precios",
            h3("Precios de Andalucía"),
            plotlyOutput('preciosAndalucia'),
            h3("Precios MercaMadrid"),
            plotlyOutput('preciosMadrid'),
            h3("Precios Mercabarna"),
            plotlyOutput('preciosBarna'),
            h3("IPC"),
            plotlyOutput('preciosIPC_indice'),
            plotlyOutput('preciosIPC_varanual')
    ),
    
    tabItem(tabName = "comercioExterior",
            fluidRow(
              box(
                uiOutput("selAnyo_TreemapComExt"),
                uiOutput("selPais_TreemapComExt"),
                plotOutput("treemapComExt"),
                width=12
              )
            )
    )
    
  )
)


ui <- dashboardPage(header,sidebar,body)