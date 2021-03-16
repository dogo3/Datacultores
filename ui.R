## app.R ##
library(shinydashboard)
library(shiny)
library(plotly)
library(waiter)
library(markdown)

gif <- paste0("https://i.pinimg.com/originals/17/04/1b/17041b6908ddd354c369b7bcb095823a.gif")
gif <- "agriT.gif"
loading_screen <- tagList(
  h2("Datacultores", style = "color:purple; font-weight: bold;"),
  img(src = gif, height = "300px")
  #h4('Labrando los datasets...', style="color:black;")
)

header <- dashboardHeader(title = "UniversityHack 2021",disable=FALSE)

sidebar <- dashboardSidebar(
  fixedPanel(
    sidebarMenu(
      id="sidebar",
      menuItem('Inicio', tabName='inicio', icon= icon("home")),
      menuItem("Consumo", tabName = "consumo", icon = icon("shopping-cart")),
      menuItem("Precios", tabName = "precios", icon = icon("money-bill-alt")),
      menuItem("Comercio Exterior", tabName = "comercioExterior", icon = icon("globe")),
      menuItem("Impacto COVID", tabName = "impacto_covid", icon = icon("virus")),
      menuItem("Conclusiones", tabName = "conclusiones", icon = icon("list-ul"))
    )
  )
)

body <- dashboardBody(
  # https://www.shinyapps.io/admin/#/signup
  
  #use_waiter(),
  #waiter_show_on_load(html=loading_screen, color='white'),
  #waiter_preloader(html=loading_screen, color='white'),
  
  tags$script(HTML("$('body').addClass('fixed');")),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$link(rel = "shortcut icon", href="trigo.ico"),
    tags$script(" $(document).ready(function () {
         $('.sidebar-menu').bind('click', function (e) {
               $(document).scrollTop(0);
               });
             });")
    ),
  
  tabItems(
    tabItem(tabName = "inicio",
            fluidRow(
              box(
                h1('University Hack 2021', style = "font-weight: bold; text-align:center;"),
                h2('Reto Cajamar Agro Analysis', style = "color: blue;font-weight: bold; text-align:center;"),
                h3('Datacultores', style = "color:purple; font-weight: bold; text-align:center;"),
                includeMarkdown('txt/inicio.md'),
                img(src = "agri.gif", height = "200px", style= "display: block; margin-left: auto; margin-right: auto;"),
                p('Este trabajo ha sido realizado por: '),
                p('Eva D. Barrero Sánchez, graduada en Economía. Estudiante Máster en Ciencia de Datos'),
                p('Jose Francisco Domenech Gomis, graduado en Ing. Informática. Estudiante Máster en Ciencia de Datos'),
                width=12
              )
            ),
    ),
    
    
    tabItem(tabName = "consumo",
            fluidRow(
              box(
                h3('Análisis del consumo'),
                uiOutput("selProd_MAPA"),
                uiOutput("selVar_MAPA"),
                checkboxInput("checkbox_diffMAPA","Mostrar diferencias mensuales",value=FALSE),
                plotlyOutput("MAPA"),
                includeMarkdown('txt/Consumo_1.md'),
                width=12)
            ),
      
            fluidRow(
              box(
                h3('Casos excepcionales'),
                includeMarkdown('txt/Consumo_2_1.md'),
                plotlyOutput('vitaminas'),
                p('Siendo 100 la máxima popularidad que puede tener una búsqueda, vemos como se alcanzó en marzo de 2020, el momento más crítico de la primera ola.'),
                uiOutput("selVar_MAPAVitC"),
                checkboxInput("checkbox_diffMAPAVitC","Mostrar diferencias mensuales",value=FALSE),
                plotlyOutput("MAPAVitC"),
                includeMarkdown('txt/Consumo_2_2.md'),
                width=12)
            )
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
                h4("Evolución exportaciones e importaciones (euros)"),
                plotlyOutput("lineComExtEur"),
                width=6
              ),
              box(
                h4("Evolución exportaciones e importaciones (toneladas)"),
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
                h4("Evolución IA agregada  países seleccionados"),
                h6("(ponderada por población)"),
                plotlyOutput("plotAgregadoCovid"),
                width=5
              ),
              box(
                h4("Relación entre tasa de cobertura e IA países seleccionados"),
                plotlyOutput("plotTC"),
                width=7
              )
            ),
            fluidRow(
              box(
                includeMarkdown("txt/Covid.md"),
                width=12
              )
            ),
            fluidRow(
              box(
                h4("Evolución IA desagregada por países seleccionados"),
                plotlyOutput("plotCovidPaises"),
                width=12
              )
            ),
            fluidRow(
              box(
                includeMarkdown("txt/Covid_2.md"),
                width=12
              )
            ),
            fluidRow(
              box(
                h4("Diferencias en importaciones/exportaciones en función de la IA en España"),
                uiOutput("selVar_Covid"),
                plotlyOutput("plotComExtCovidEsp"),
                width=12
              )
            )
          ),
    
    tabItem(tabName="conclusiones",
            fluidRow(
              box(
                includeMarkdown("txt/conclusiones.md"),
                width=12
              )
            )
          )
    
  )
)


ui <- dashboardPage(header,sidebar,body, skin='purple')