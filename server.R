library(ggplot2)
library(treemapify)
library(lubridate)
library(waiter)

#install.packages("remotes")
#remotes::install_github("JohnCoene/waiter")

top5Productos<-c("PATATAS FRESCAS","NARANJAS","TOMATES","PLATANOS","MANZANAS")
totalesMAPA <- c('T.HORTALIZAS FRESCAS', 'T.FRUTAS FRESCAS')
productosVitC <- c("KIWI","NARANJAS","MANDARINAS","BROCOLI")
dfMAPAConsumo <- readRDS("data/app/MAPAConsumo.rds")
andalucia <- readRDS("data/app/preciosAndalucia.rds")
mercaMadrid <- readRDS("data/app/preciosMadrid.rds")
mercaBarna <- readRDS("data/app/preciosBarna.rds")
comercioExterior<-readRDS("data/app/ComercioExterior.rds")
comExtTreemap <- readRDS("data/app/ComExtTreemap.rds")
IPC <- readRDS("data/app/IPC.rds")
COVID <-readRDS("data/app/COVID.rds")
ComExtCovid <- readRDS("data/app/ComExtCovid.rds")
vitaminaC <- readRDS('data/app/vitaminaCGoogle.rds')

<<<<<<< HEAD
textoConsumo_1<-readLines('txt/Consumo_1.txt', encoding = 'UTF-8')
textoConsumo_2_1<-readLines('txt/Consumo_2_1.txt', encoding = 'UTF-8')
textoConsumo_2_2<-readLines('txt/Consumo_2_2.txt', encoding = 'UTF-8')
textoConsumo_2_2<-readLines('txt/Consumo_2_2.txt', encoding = 'UTF-8')
textoprecios_andalucia<-readLines('txt/andalucia.txt', encoding = 'UTF-8')
textoprecios_barna<-readLines('txt/barna.txt', encoding = 'UTF-8')
textoprecios_madrid<-readLines('txt/madrid.txt', encoding = 'UTF-8')
textoprecios_ipc_1<-readLines('txt/ipc_1.txt', encoding = 'UTF-8')
textoprecios_ipc<-readLines('txt/ipc.txt', encoding = 'UTF-8')
textocomercio_exterior<-readLines('txt/ComercioExterior.txt', encoding = 'UTF-8')

=======
>>>>>>> 2586ba7a00ba4a6393d5ee518993ac5307f76fcc
conversionPaises <- read.csv("./data/conversionPaises.csv",stringsAsFactors = FALSE)
translateCountry <- function(country,from,to){
  l<-list(c())
  for(i in seq_len(length(country))){
    l[[i]] <-   conversionPaises[conversionPaises[[from]]==country[i],to][1]
  }
  return(unlist(l))
}
UE <- c("AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", "FR", "GR", "HR", "HU", "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK")


shinyServer(function(input, output) {
  
  # w <- Waiter$new(html = loading_screen, color = "white")
  # w$show()
<<<<<<< HEAD
  Sys.sleep(2.5) 
=======
  # Sys.sleep(4) 
>>>>>>> 2586ba7a00ba4a6393d5ee518993ac5307f76fcc
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
    validate(need(variableMAPA(), ""))
    #df <- dfMAPAConsumo %>% filter(Producto %in% listaProductosMAPA()) 
    df <- dfMAPAConsumo %>% filter(Producto %in% input$selProd_MAPA)
    
    ggplot(df,aes(x=Fecha, y=df[[variableMAPA()]],col=Producto))+
      geom_line( size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=3, col='red')+
      scale_x_date(date_breaks = 'months',date_labels = "%b %Y")+
      ylab(variableMAPA())+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      ggtitle(variableMAPA())
  })
  
  output$MAPAVitC <- renderPlotly({
    validate(need(variableMAPAVitC(), ""))
    
    df <- dfMAPAConsumo %>% filter(Producto %in% productosVitC) 
    
    ggplot(df,aes(x=Fecha, y=df[[variableMAPAVitC()]],col=Producto))+
      geom_line( size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=3, col='red')+
      scale_x_date(date_breaks = 'months',date_labels = "%b %Y")+
      ylab(variableMAPAVitC())+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      ggtitle(variableMAPAVitC())
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
    if(is.null(input$selAnyo_ComExt) | is.null(input$selPais_ComExt)){
      " "
    }else{
    comExtTreemap %>% filter(YEAR %in% input$selAnyo_ComExt & REPORTER_COMUN %in% input$selPais_ComExt)%>%
      ggplot(aes(area = value, fill=REPORTER_COMUN, label = REPORTER_COMUN)) +
      geom_treemap(colour="black") +
      facet_grid(vars(rows=YEAR),vars(cols=Movimiento)) + 
      theme(legend.position = "none")+
      geom_treemap_text(colour = "white", place = "centre",grow = F)
    }
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
                'Imp(ton)' = sum(QUANTITY_IN_100KG_EXPORT, na.rm=T)/10)
  })
  
  output$lineComExtEur<- renderPlotly({
    validate(need(input$selPais_ComExt, ""))
      ggplot(comercioExteriorReact())+
      geom_line(aes(x=PERIOD, y=`Exp(€)`), col='red')+
      geom_line(aes(x=PERIOD, y=`Imp(€)`), col='blue')+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "2 months",date_labels = "%b %Y")+
      ylab("Euros")+
      ggtitle('Evolución exportaciones e importaciones (euros)')
  })
  
  output$lineComExtTon<- renderPlotly({
    validate(need(input$selPais_ComExt, ""))
    p<-comercioExteriorReact() %>%
      ggplot()+
      geom_line(aes(x=PERIOD, y=`Exp(ton)`), col='red')+
      geom_line(aes(x=PERIOD, y=`Imp(ton)`), col='blue')+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "2 months",date_labels = "%b %Y")+
      ylab("Toneladas")+
      ggtitle('Evolución exportaciones e importaciones (toneladas)')
    ggplotly(p)
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
    
    validate(need(input$selectAndalucia, ""))
    
    andalucia %>%
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
  })
  
  output$selectMadrid <- renderUI({
    selectizeInput('selectMadrid', 'Selecciona las familias', 
                choices = unique(mercaMadrid$familia), 
                selected = c('FRUTAS', 'HORTALIZAS'), 
                multiple = T, options = list(plugins= list('remove_button'),minItems=1))
  })
  
  output$preciosMadrid <- renderPlotly({
    
    validate(need(input$selectMadrid, ""))
    
    mercaMadrid %>% 
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
    
    validate(need(input$selectBarna, ""))
    
    mercaBarna %>% 
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
  })
  
  output$preciosIPC_indice <- renderPlotly({
    p <- IPC %>%
      filter(`Tipo de dato` == 'Índice') %>%
      ggplot()+
      geom_line(aes(x=Periodo, y=Total, col=Clases), size=1)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      labs(x='Fecha', y='Índice', title='Índice IPC')
    
    ggplotly(p) %>% layout(legend = list(orientation = "h", x = 0.4, y = -0.4))
  })
  
  output$preciosIPC_varanual <- renderPlotly({
    p <- IPC %>%
      filter(`Tipo de dato` == 'Variación anual') %>%
      ggplot()+
      geom_line(aes(x=Periodo, y=Total, col=Clases), size=1)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      geom_hline(yintercept=0)+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      labs(x='Fecha', y='Índice', title='Variación anual IPC')
    
    ggplotly(p) %>% layout(legend = list(orientation = "h", x = 0.4, y = -0.4))
  })
  
  
  
  # COVID
  
  output$selPais_Covid <- renderUI({
    selectizeInput('selPais_Covid', 'Selecciona países', 
                   #choices = translateCountry(country=unique(COVID$geoId),from="ISO2",to="Comun"), 
                   choices = unique(COVID$countriesAndTerritories),
                   selected = unique(filter(COVID,countriesAndTerritories %in% translateCountry(UE,from="ISO2",to="NombresCOVID"))$countriesAndTerritories), 
                   multiple = T, options = list(plugins= list('remove_button'),minItems=1))
  })
    
  output$plotAgregadoCovid <- renderPlotly({
    validate(need(input$selPais_Covid, "Cargando"))

    filter(COVID,countriesAndTerritories %in% input$selPais_Covid &
           dateRep > '2020-03-01') %>%
    group_by(dateRep) %>%
    summarise(media = weighted.mean(x=`IA14`,w=`pop`, na.rm=T)) %>%
    ggplot()+
    geom_line(aes(x=dateRep, y=media))+
    scale_x_date(date_breaks = "month",date_labels = "%b %Y")+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
    labs(x='Fecha', y='IA 14', title='Evolución IA Ponderada Países Seleccionados')
  })
  
  
  output$plotTC <- renderPlotly({
    validate(need(input$selPais_Covid, "Cargando"))
    g <- ggplot( filter(ComExtCovid,`countriesAndTerritories` %in% input$selPais_Covid)
                 ,aes(x=TasaCobertura, y=IAMeanMonth)) +
      geom_point(aes(frame = month, label = geoId)) +
      geom_smooth(aes(group = month,frame=month), 
                  method = "lm", 
                  show.legend = FALSE) +
      scale_x_log10()  # convert to log scale
    
    ggplotly(g) %>%
      animation_opts(frame = 200,
                     easing = "linear",
                     redraw = FALSE)
  })
  
  output$plotCovidPaises <- renderPlotly({
    validate(need(input$selPais_Covid, "Cargando"))
    
    filter(COVID,countriesAndTerritories %in% input$selPais_Covid &
             dateRep > '2020-03-01') %>%
    
      ggplot()+
      geom_line(aes(x=dateRep, y=IA14, col=countriesAndTerritories))+
      scale_x_date(date_breaks = "month",date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
      labs(x='Fecha', y='IA 14', title='Evolución IA Países Seleccionados')
  })
  
  
  #EXPLICACIONES
  # output$consumo_1 <- renderText({
  #   splitText <- stringi::stri_split(str = textoConsumo_1, regex = '\\n')
  #   replacedText <- lapply(splitText, p)
  #   return(textoConsumo_1)
  # })
  
  output$consumo_2_1 <- renderUI({
    splitText <- stringi::stri_split(str = textoConsumo_2_1, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })
  
  output$vitaminas <- renderPlotly({
    p <- ggplot(vitaminaC) +
      geom_line(aes(x=Semana, y=Valor), col='goldenrod', size=1)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      geom_hline(yintercept=0)+
      scale_x_date(date_breaks = '2 months',date_labels = "%b %Y")+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      labs(x='Fecha', y='Nº búsquedas', title='Número de búsquedas en Google: vitamina C')
    
    ggplotly(p) %>%   layout(margin = list(b=160),
                             annotations = 
                               list(x = 1, y = -0.5,
                                    text = "Fuente: trends.google.es", 
                                    showarrow = F, xref='paper', yref='paper', 
                                    xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                    font=list(size=12, color="blue"))
    )
      
  })
<<<<<<< HEAD
  
  output$consumo_2_2 <- renderUI({
    splitText <- stringi::stri_split(str = textoConsumo_2_2, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })
  
  output$precios_andalucia <- renderUI({
    splitText <- stringi::stri_split(str = textoprecios_andalucia, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })
  
  output$precios_barna <- renderUI({
    splitText <- stringi::stri_split(str = textoprecios_barna, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })
  
  output$precios_madrid <- renderUI({
    splitText <- stringi::stri_split(str = textoprecios_madrid, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })
  
  output$precios_ipc_1 <- renderUI({
    splitText <- stringi::stri_split(str = textoprecios_ipc_1, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })
  
  output$precios_ipc <- renderUI({
    splitText <- stringi::stri_split(str = textoprecios_ipc, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })
  
  output$comercio_exterior <- renderUI({
    splitText <- stringi::stri_split(str = textocomercio_exterior, regex = '\\n')
    replacedText <- lapply(splitText, p)
    return(replacedText)
  })

})
=======
  })
>>>>>>> 2586ba7a00ba4a6393d5ee518993ac5307f76fcc
