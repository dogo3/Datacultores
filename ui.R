## app.R ##
library(shinydashboard)
library(shiny)
library(plotly)
library(waiter)

gif <- paste0("https://i.pinimg.com/originals/17/04/1b/17041b6908ddd354c369b7bcb095823a.gif")
gif <- "agriT.gif"
loading_screen <- tagList(
  h2("Datacultores", style = "color:black;"),
  img(src = gif, height = "300px"), 
<<<<<<< HEAD
  h4('Labrando los datasets...', style="color:black;")
=======
  #h4('Labrando los datasets...', style="color:gray;")
>>>>>>> 4d3f93db492f17f5964522184a6cb71cd5cfba6d
)

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
  
  use_waiter(),
  waiter_show_on_load(html=loading_screen, color='white'),
  #waiter_preloader(html=loading_screen, color='white'),
  
  tags$script(HTML("$('body').addClass('fixed');")),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
  
  tabItems(
    tabItem(tabName = "consumo",
            fluidRow(
              box(
                h3('Análisis del consumo'),
                uiOutput("selProd_MAPA"),
                uiOutput("selVar_MAPA"),
                checkboxInput("checkbox_diffMAPA","Mostrar diferencias mensuales",value=FALSE),
                plotlyOutput("MAPA"),
                includeMarkdown('txt/Consumo_1.md'),
                width=12),
            ),
      
            fluidRow(
              box(
                h3('Casos excepcionales'),
                includeMarkdown('txt/Consumo_2_1.md'),
                plotlyOutput('vitaminas'),
                p('Siendo 100 la máxima popularidad que puede tener una búsqueda, vemos como se alcanzó en marzo de 2020.'),
                uiOutput("selVar_MAPAVitC"),
                checkboxInput("checkbox_diffMAPAVitC","Mostrar diferencias mensuales",value=FALSE),
                plotlyOutput("MAPAVitC"),
                includeMarkdown('txt/Consumo_2_2.md'),
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
              ),
              box(
                includeMarkdown('txt/andalucia.md'),
                width=12
              )
              
            ),
            
            fluidRow(
              box(
                h3("Precios MercaMadrid"),
                uiOutput('selectMadrid'),
                plotlyOutput('preciosMadrid'),
                width=12
              ),
              box(
                includeMarkdown('txt/madrid.md'),
                width=12
              )
            ),
            
            fluidRow(
              box(
                h3("Precios Mercabarna"),
                uiOutput('selectBarna'),
                plotlyOutput('preciosBarna'),
                width=12
              ),
              box(
                includeMarkdown('txt/barna.md'),
                width=12
              )
            ),
            
            fluidRow(
              box(
                h3('Índice de precios al consumo'),
                includeMarkdown('txt/ipc_1.md'),
                width=12
                ),
              box(plotlyOutput('preciosIPC_indice'), width=6),
              box(plotlyOutput('preciosIPC_varanual'), width=6),
              box(includeMarkdown('txt/ipc.md'), width=12)
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
              ),
              box(includeMarkdown('txt/ComercioExterior.md'), width=12)
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
            ),
            fluidRow(
              box(
                plotlyOutput("plotCovidPaises"),
                width=12
              )
            )
          )
    
  )
)


ui <- dashboardPage(header,sidebar,body, skin='purple')