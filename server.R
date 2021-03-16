library(ggplot2)
library(treemapify)
library(lubridate)
library(waiter)

#install.packages("remotes")
#remotes::install_github("JohnCoene/waiter")

top5Productos<-c("PATATAS FRESCAS","NARANJAS","TOMATES","PLATANOS","MANZANAS")
totalesMAPA <- c('T.HORTALIZAS FRESCAS', 'T.FRUTAS FRESCAS')
productosVitC <- c("KIWI","NARANJAS","MANDARINAS","BROCOLI")
meses <- c('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto',
           'Septiembre', 'Octubre', 'Noviembre', 'Diciembre')
dfMAPAConsumo <- readRDS("data_app/MAPAConsumo.rds")
andalucia <- readRDS("data_app/preciosAndalucia.rds")
mercaMadrid <- readRDS("data_app/preciosMadrid.rds")
mercaBarna <- readRDS("data_app/preciosBarna.rds")
comercioExterior<-readRDS("data_app/ComercioExterior.rds")
comExtTreemap <- readRDS("data_app/ComExtTreemap.rds")
IPC <- readRDS("data_app/IPC.rds")
COVID <-readRDS("data_app/COVID.rds")
ComExtCovid <- readRDS("data_app/ComExtCovid.rds")
ComExtCovidEsp<-readRDS("data_app/ComExtCovidEsp.rds")
vitaminaC <- readRDS('data_app/vitaminaCGoogle.rds')


conversionPaises <- read.csv("./data_app/conversionPaises.csv",stringsAsFactors = FALSE)
translateCountry <- function(country,from,to){
  l<-list(c())
  for(i in seq_len(length(country))){
    l[[i]] <-   conversionPaises[conversionPaises[[from]]==country[i],to][1]
  }
  return(unlist(l))
}
UE <- c("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", "FR", "GR", "HR", "HU", "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK","UK")


shinyServer(function(input, output) {
  
  # w <- Waiter$new(html = loading_screen, color = "white")
  # w$show()
  # Sys.sleep(1) 
  waiter_hide()
  
  
  output$selProd_MAPA<-renderUI({
    selectizeInput("selProd_MAPA","Selecciona los productos",
                   choices=unique(dfMAPAConsumo$Producto),multiple=TRUE,selected=totalesMAPA,
                   options = list(plugins= list('remove_button')))
  })
  output$selVar_MAPA<-renderUI({
    selectInput("selVar_MAPA","Selecciona la variable",
                choices=colnames(dfMAPAConsumo)[c(-seq_len(5),-12:-19)],selected=c("Gasto per capita"))
  })
  
  output$selVar_MAPAVitC<-renderUI({
    selectInput("selVar_MAPAVitC","Selecciona la variable",
                choices=colnames(dfMAPAConsumo)[c(-seq_len(5),-12:-19)],selected=c("Gasto per capita"))
  })
  
  variableMAPA<-reactive({
    if(input$checkbox_diffMAPA){
      return(paste("Diff",input$selVar_MAPA))
    }else{
      return(input$selVar_MAPA)
    }
  })
  
  variableMAPAVitC<-reactive({
    if(input$checkbox_diffMAPAVitC){
      return(paste("Diff",input$selVar_MAPAVitC))
    }else{
      return(input$selVar_MAPAVitC)
    }
  })
  
  # listaProductosMAPA<-reactive({
  #   if(is.null(input$selProd_MAPA)){
  #     return(totalesMAPA) 
  #   }else{
  #     return(input$selProd_MAPA)
  #   }
  # })
  
  
  output$MAPA <- renderPlotly({
    validate(need(variableMAPA(), "Cargando"))
    #df <- dfMAPAConsumo %>% filter(Producto %in% listaProductosMAPA()) 
    df <- dfMAPAConsumo %>% filter(Producto %in% input$selProd_MAPA)
    
    p<-ggplot(df,aes(x=Fecha, y=df[[variableMAPA()]],col=Producto))+
      geom_line( size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=3, col='red')+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      ylab(variableMAPA())+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      ggtitle(variableMAPA())
    ggplotly(p) %>%   layout(margin = list(b=120),
                             annotations = 
                               list(x = 1, y = -0.4,
                                    text = "Fuente: Dataset Consumo MAPA", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  output$MAPAVitC <- renderPlotly({
    validate(need(variableMAPAVitC(), "Cargando"))
    
    df <- dfMAPAConsumo %>% filter(Producto %in% productosVitC) 
    
    p<-ggplot(df,aes(x=Fecha, y=df[[variableMAPAVitC()]],col=Producto))+
      geom_line( size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=3, col='red')+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      ylab(variableMAPAVitC())+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      ggtitle(variableMAPAVitC())
    ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                             margin = list(b=100),
                             annotations = 
                               list(x = 1, y = -0.4,
                                    text = "Fuente: Dataset Consumo MAPA", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  #TREEMAP COMERCIO EXTERIOR
  
  output$selAnyo_ComExt<-renderUI({
    selectizeInput("selAnyo_ComExt","Selecciona los años",choices=unique(comExtTreemap$YEAR),
                   multiple=TRUE,selected=unique(comExtTreemap$YEAR),
                   options = list(plugins= list('remove_button')))
  })
  
  output$selPais_ComExt<-renderUI({
    selectizeInput("selPais_ComExt","Selecciona los países",choices=unique(comExtTreemap$REPORTER_COMUN),
                   #Por defecto ponemos los países con los que más operaciones hay
                   multiple=TRUE,selected=c("Alemania","Francia","Países Bajos","Italia","Portugal","Polonia","Bélgica","Grecia"),
                   options = list(plugins= list('remove_button'),minItems=1))
  })
  
  output$treemapComExt <- renderPlot({
    validate(need(input$selPais_ComExt, "Cargando"))
    validate(need(input$selAnyo_ComExt, "Cargando"))
    comExtTreemap %>% filter(YEAR %in% input$selAnyo_ComExt & REPORTER_COMUN %in% input$selPais_ComExt)%>%
      ggplot(aes(area = value, fill=REPORTER_COMUN, label = REPORTER_COMUN)) +
      geom_treemap(colour="black") +
      facet_grid(vars(rows=YEAR),vars(cols=Movimiento)) + 
      theme(legend.position = "none",plot.caption = element_text(color = "blue"))+
      geom_treemap_text(colour = "white", place = "centre",grow = F)+
      labs(caption="Fuente: Dataset Comercio Exterior")
  
  })
  
  # Lineplots comercio exterior
  
  comercioExteriorReact<- reactive({
    paises <- translateCountry(input$selPais_ComExt,from = "Comun",to="NombresComercioExterior")
    comercioExterior %>%
      filter(REPORTER %in% paises)%>%
      group_by(PERIOD) %>%
      summarise('Exp(€)' = sum(VALUE_IN_EUROS_IMPORT, na.rm = T),
                'Imp(€)' = sum(VALUE_IN_EUROS_EXPORT, na.rm = T),
                'Exp(ton)' = sum(QUANTITY_IN_100KG_IMPORT, na.rm=T)/10,
                'Imp(ton)' = sum(QUANTITY_IN_100KG_EXPORT, na.rm=T)/10)%>%
      filter(`Exp(€)`>0 & `Imp(€)`>0 & `Exp(ton)`>0 & `Imp(ton)`>0)
  })
  
  output$lineComExtEur<- renderPlotly({
    validate(need(input$selPais_ComExt, "Cargando"))
      p<-ggplot(comercioExteriorReact())+
      geom_line(aes(x=PERIOD, y=`Exp(€)`), col='red')+
      geom_line(aes(x=PERIOD, y=`Imp(€)`), col='blue')+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "2 months",date_labels = "%b %Y")+
      ylab("Euros")+xlab("Fecha")
      ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                               margin = list(b=120),
                               annotations = 
                                 list(x = 1, y = -0.4,
                                      text = "Fuente: Dataset Comercio Exterior", 
                                      showarrow = F, xref='paper', yref='paper', 
                                      xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                      font=list(size=12, color="blue")))
  })
  
  output$lineComExtTon<- renderPlotly({
    validate(need(input$selPais_ComExt, "Cargando"))
    p<-comercioExteriorReact() %>%
      ggplot()+
      geom_line(aes(x=PERIOD, y=`Exp(ton)`), col='red')+
      geom_line(aes(x=PERIOD, y=`Imp(ton)`), col='blue')+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "2 months",date_labels = "%b %Y")+
      ylab("Toneladas")+xlab("Fecha")
    ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                             margin = list(b=120),
                             annotations = 
                               list(x = 1, y = -0.4,
                                    text = "Fuente: Dataset Comercio Exterior", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  
  ## TABPANEL PRECIOS
  
  output$selectAndalucia <- renderUI({
    selectizeInput('selectAndalucia', 'Selecciona los subsectores', 
                choices = unique(andalucia$SUBSECTOR), 
                selected = c('Citricos', 'Frutales no cítricos', "Hortícolas al aire libre", 
                             'Hortícolas protegidos'), 
                multiple = T, options = list(plugins= list('remove_button'),minItems=1))
  })
  
  output$preciosAndalucia <- renderPlotly({
    
    validate(need(input$selectAndalucia, "Cargando"))
    
    p<-andalucia %>%
      filter(SUBSECTOR %in% input$selectAndalucia) %>%
      group_by(SUBSECTOR, INICIO) %>%
      summarise(PRECIO_MEDIO = mean(PRECIO), .groups = 'keep') %>%
      ggplot()+
      geom_line(aes(x=INICIO, y=PRECIO_MEDIO, col=SUBSECTOR))+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "2 months",date_labels = "%b %Y")+
      scale_y_log10()+
      labs(x='Fecha', y='Precio medio', title='Precio medio por subsectores')
    ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                             margin = list(b=120),
                             annotations = 
                               list(x = 1, y = -0.4,
                                    text = "Fuente: Dataset precios Andalucía", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  output$selectMadrid <- renderUI({
    selectizeInput('selectMadrid', 'Selecciona las familias', 
                choices = unique(mercaMadrid$familia), 
                selected = c('FRUTAS', 'HORTALIZAS'), 
                multiple = T, options = list(plugins= list('remove_button'),minItems=1))
  })
  
  output$preciosMadrid <- renderPlotly({
    
    validate(need(input$selectMadrid, "Cargando"))
    
    p<-mercaMadrid %>% 
      filter(familia %in% input$selectMadrid) %>%
      group_by(familia, Fecha) %>% 
      summarise(precio_medio = mean(price_mean), .groups='keep') %>%
      ggplot() + 
      geom_line(aes(x=Fecha, y=precio_medio, col=familia))+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "2 months",date_labels = "%b %Y")+
      labs(x='Fecha', y='Precio medio', title='Precio medio por familias')
    ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                             margin = list(b=120),
                             annotations = 
                               list(x = 1, y = -0.4,
                                    text = "Fuente: Dataset precios MercaMadrid", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  output$selectBarna <- renderUI({
    selectizeInput('selectBarna', 'Selecciona las familias', 
                choices = unique(mercaBarna$familia), 
                selected = c('FRUTAS CÍTRICOS', 'FRUTAS HUESO', 'FRUTAS SEMILLA',
                             'HORTALIZAS BULBOS', 'HORTALIZAS FRUTO', 'HORTALIZAS INFLORESC.',
                             'HORTALIZAS TALLOS'), 
                multiple = T, options = list(plugins= list('remove_button'),minItems=1))
  })
  
  output$preciosBarna <- renderPlotly({
    
    validate(need(input$selectBarna, "Cargando"))
    
    p<-mercaBarna %>% 
      filter(familia %in% input$selectBarna) %>%
      group_by(familia, Fecha) %>% 
      summarise(precio_medio = mean(price_mean), .groups='keep') %>%
      ggplot() + 
      geom_line(aes(x=Fecha, y=precio_medio, col=familia))+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "2 months",date_labels = "%b %Y")+
      labs(x='Fecha', y='Precio medio', title='Precio medio por familias')
    ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                             margin = list(b=120),
                             annotations = 
                               list(x = 1, y = -0.4,
                                    text = "Fuente: Dataset precios MercaBarna", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  output$preciosIPC_indice <- renderPlotly({
    p <- IPC %>%
      filter(`Tipo de dato` == 'Índice') %>%
      ggplot()+
      geom_line(aes(x=Periodo, y=Total, col=Clases), size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      labs(x='Fecha', y='Índice', title='Índice IPC')
    
    ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                             margin = list(b=80),
                             annotations = 
                               list(x = 1, y = -0.6,
                                    text = "Fuente: Instituto Nacional de Estadística", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  output$preciosIPC_varanual <- renderPlotly({
    p <- IPC %>%
      filter(`Tipo de dato` == 'Variación anual') %>%
      ggplot()+
      geom_line(aes(x=Periodo, y=Total, col=Clases), size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      geom_hline(yintercept=0)+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      labs(x='Fecha', y='Índice', title='Variación anual IPC')
    ggplotly(p) %>%   layout(legend = list(orientation = "h", x = 0.4, y = -0.4),
                             margin = list(b=80),
                             annotations = 
                               list(x = 1, y = -0.6,
                                    text = "Fuente: Instituto Nacional de Estadística", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  
  
  # COVID
  
  output$selPais_Covid <- renderUI({
    selectizeInput('selPais_Covid', 'Selecciona países', 
                   choices = unique(COVID$country_comun)[!is.na(unique(COVID$country_comun))],
                   selected = unique(filter(COVID,country_comun %in% translateCountry(UE,from="ISO2",to="Comun"))$country_comun), 
                   multiple = T, options = list(plugins= list('remove_button'),minItems=1))
  })
    
  output$plotAgregadoCovid <- renderPlotly({
    validate(need(input$selPais_Covid, "Cargando"))
    
    p<-filter(COVID,country_comun %in% input$selPais_Covid &
           dateRep > '2020-03-01') %>%
    group_by(dateRep) %>%
    summarise(media = weighted.mean(x=`IA14`,w=`pop`, na.rm=T)) %>%
    ggplot()+
    geom_line(aes(x=dateRep, y=media))+
    scale_x_date(date_breaks = "month",date_labels = "%b %Y")+
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))+
    labs(x='Fecha', y='IA 14')
    ggplotly(p) %>%   layout(margin = list(b=130),
                             annotations = 
                               list(x = 1, y = -0.5,
                                    text = "Fuente: Dataset COVID", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  
  output$plotTC <- renderPlotly({
    validate(need(input$selPais_Covid, "Cargando"))
    g <- ggplot( filter(ComExtCovid,country_comun %in% input$selPais_Covid)
                 ,aes(x=TasaCobertura, y=IAMeanMonth)) +
      geom_point(aes(frame = month, label = geoId)) +
      geom_smooth(aes(group = month,frame=month), 
                  method = "lm", 
                  show.legend = FALSE) +
      scale_x_log10()+  # convert to log scale
      labs(x="Tasa Cobertura",y="IA media mensual ponderada")
    
    ggplotly(g) %>%
      animation_opts(frame = 200,
                     easing = "linear",
                     redraw = FALSE) %>%   layout(margin = list(b=180),
                                                  annotations = list(x = 1, y = -0.9,
                                                                    text = "Fuente: Dataset COVID y comercio exterior", 
                                                                    showarrow = F, xref='paper', yref='paper', 
                                                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                                                    font=list(size=12, color="blue")))
  })
  
  #Evolución IA desagregada por países seleccionados
  
  output$plotCovidPaises <- renderPlotly({
    validate(need(input$selPais_Covid, "Cargando"))
    p <- filter(COVID,country_comun %in% input$selPais_Covid &
             dateRep > '2020-03-01') %>%
      ggplot()+
      geom_line(aes(x=dateRep, y=IA14, col=country_comun))+
      scale_x_date(date_breaks = "month",date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))+
      labs(x='Fecha', y='IA 14',col="País")
    ggplotly(p) %>%   layout(margin = list(b=160),
                             annotations = 
                               list(x = 1, y = -0.5,
                                    text = "Fuente: Dataset COVID", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue")))
  })
  
  output$selVar_Covid <- renderUI({
    selectInput('selVar_Covid', 'Selecciona variable', 
                   choices = colnames(ComExtCovidEsp)[grepl("^Diferencia",colnames(ComExtCovidEsp))],
                   selected = "Diferencia Exportaciones Toneladas", 
                   multiple = F)
  })
  
  output$plotComExtCovidEsp <- renderPlotly({
    p<-ggplot(ComExtCovidEsp,aes(x=IAMeanMonth,y=ComExtCovidEsp[[input$selVar_Covid]]))+
               geom_point(aes(text=`MONTH`))+
               geom_smooth(method="lm")+
               labs(x="IA media mensual en España",y=input$selVar_Covid)
    
    ggplotly(p)%>%
        layout(margin = list(b=100),
                            annotations = 
                              list(x = 1, y = -0.3,
                                   text = "Fuente: Dataset COVID y comercio exterior", 
                                   showarrow = F, xref='paper', yref='paper', 
                                   xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                   font=list(size=12, color="blue")))
  })
    
  # Vitamina C
  
  output$vitaminas <- renderPlotly({
    p <- ggplot(vitaminaC) +
      geom_line(aes(x=Semana, y=Valor), col='goldenrod', size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      geom_hline(yintercept=0)+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      labs(x='Fecha', y='Nº búsquedas', title='Número de búsquedas en Google: vitamina C')
    
    ggplotly(p) %>% layout(margin = list(b=160),
                             annotations = 
                               list(x = 1, y = -0.5,
                                    text = "Fuente: trends.google.es", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue"))
    )
      
  })
})
