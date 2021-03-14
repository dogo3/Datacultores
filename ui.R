## app.R ##
library(shinydashboard)
library(shiny)
library(plotly)

header <- dashboardHeader(title = "Basic dashboard",disable=FALSE)

sidebar <- dashboardSidebar(
  fixedPanel(
    sidebarMenu(
      id="sidebar",
      menuItem("Consumo", tabName = "consumo", icon = icon("shopping-cart")),
      menuItem("Precios", tabName = "precios", icon = icon("money-bill-alt")),
      menuItem("Comercio Exterior", tabName = "comercioExterior", icon = icon("globe"))
      
    )
  )
)

body <- dashboardBody(
  # Boxes need to be put in a row (or column)
  tabItems(
    tabItem(
      tabName = "consumo",
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
            fluidRow(
              box(
                h3("Precios de Andalucía"),
                uiOutput('selectAndalucia'),
                plotlyOutput('preciosAndalucia'),
                width=12
              )
            ),
            
            fluidRow(
              box(
                h3("Precios MercaMadrid"),
                uiOutput('selectMadrid'),
                plotlyOutput('preciosMadrid'),
                width=12
              )
            ),
            
            fluidRow(
              box(
                h3("Precios Mercabarna"),
                uiOutput('selectBarna'),
                plotlyOutput('preciosBarna'),
                width=12
              )
            ),
            
            fluidRow(
              h3("IPC"),
              box(plotlyOutput('preciosIPC_indice')),
              box(plotlyOutput('preciosIPC_varanual'))
            )
    ),
    
    tabItem(tabName = "comercioExterior",
            fluidRow(
              box(
                uiOutput("selAnyo_TreemapComExt"),
                uiOutput("selPais_TreemapComExt"),
                plotOutput("treemapComExt"),
                width=12
              )
            ),
            fluidRow(
              box(
                plotlyOutput("lineComExtEur"),
                width=6
              ),
              box(
                plotlyOutput("lineComExtTon"),
                width=6
              )
            )
    )
    
  )
)


ui <- dashboardPage(header,sidebar,body)