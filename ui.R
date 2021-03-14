## app.R ##
library(shinydashboard)
library(shiny)
library(plotly)

header <- dashboardHeader(title = "UniversityHack 2021",disable=FALSE)

sidebar <- dashboardSidebar(
  fixedPanel(
    sidebarMenu(
      id="sidebar",
      menuItem("Consumo", tabName = "consumo", icon = icon("shopping-cart")),
      menuItem("Precios", tabName = "precios", icon = icon("money-bill-alt")),
      menuItem("Comercio Exterior", tabName = "comercioExterior", icon = icon("globe")),
      menuItem("Impacto COVID", tabName = "impacto_covid", icon = icon("virus"))
    )
  )
)

body <- dashboardBody(
  tags$script(HTML("$('body').addClass('fixed');")),
  
  tabItems(
    tabItem(tabName = "consumo",
            fluidRow(
              box(
                h3('Análisis del consumo'),
                uiOutput("selProd_MAPA"),
                uiOutput("selVar_MAPA"),
                checkboxInput("checkbox_diffMAPA","Mostrar diferencias mensuales",value=FALSE),
                plotlyOutput("MAPA"),
                uiOutput('consumo_1'),
                width=12),
            ),
      
            fluidRow(
              box(
                h3('Casos excepcionales'),
                uiOutput('consumo_2_1'),
                plotlyOutput('vitaminas'),
                p('Siendo 100 la máxima popularidad que puede tener una búsqueda, vemos como se alcanzó en marzo de 2020.'),
                uiOutput("selVar_MAPAVitC"),
                checkboxInput("checkbox_diffMAPAVitC","Mostrar diferencias mensuales",value=FALSE),
                plotlyOutput("MAPAVitC"),
                uiOutput('consumo_2_2'),
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
              box(plotlyOutput('preciosIPC_indice')),
              box(plotlyOutput('preciosIPC_varanual'))
            )
    ),
    
    tabItem(tabName = "comercioExterior",
            fluidRow(
              box(
                h3('Exportaciones e Importaciones'),
                uiOutput("selAnyo_ComExt"),
                uiOutput("selPais_ComExt"),
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
    ),
    
    tabItem(tabName = "impacto_covid",
            fluidRow(
              box(
                uiOutput("selPais_Covid"),
                width=12
              )
            ),
            
            fluidRow(
              box(
                plotlyOutput("plotAgregadoCovid"),
                width=5
              ),
              box(
                plotlyOutput("plotTC"),
                width=7
              )
            )
          )
    
  )
)


ui <- dashboardPage(header,sidebar,body, skin='purple')