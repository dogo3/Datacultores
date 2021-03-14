library(ggplot2)
library(treemapify)

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

conversionPaises <- read.csv("./data/conversionPaises.csv",stringsAsFactors = FALSE)
translateCountry <- function(country,from,to){
  l<-list(c())
  for(i in seq_len(length(country))){
    l[[i]] <-   conversionPaises[conversionPaises[[from]]==country[i],to][1]
  }
  return(unlist(l))
}


shinyServer(function(input, output) {
  
  
  output$selProd_MAPA<-renderUI({
    selectizeInput("selProd_MAPA","Productos",choices=unique(dfMAPAConsumo$Producto),multiple=TRUE,selected=totalesMAPA,options = list(plugins= list('remove_button')))
  })
  output$selVar_MAPA<-renderUI({
    selectInput("selVar_MAPA","Variable",choices=colnames(dfMAPAConsumo)[c(-seq_len(5),-12:-19)],selected=c("Gasto per capita"))
  })
  
  output$selVar_MAPAVitC<-renderUI({
    selectInput("selVar_MAPAVitC","Variable",choices=colnames(dfMAPAConsumo)[c(-seq_len(5),-12:-19)],selected=c("Gasto per capita"))
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
  
  listaProductosMAPA<-reactive({
    if(is.null(input$selProd_MAPA)){
      return(totalesMAPA) 
    }else{
      return(input$selProd_MAPA)
    }
  })
  
  
  output$MAPA <- renderPlotly({
    print(variableMAPA())
    df <- dfMAPAConsumo %>% filter(Producto %in% listaProductosMAPA()) 
    p<-ggplot(df,aes(x=Fecha, y=df[[variableMAPA()]],col=Producto))+
      geom_line( size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=3, col='red')+
      scale_x_date(date_breaks = 'months',date_labels = "%b %Y")+
      ylab(variableMAPA())+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      ggtitle(variableMAPA())+ theme(legend.position = "none")
    ggplotly(p)
  })
  
  output$MAPAVitC <- renderPlotly({
    print(variableMAPAVitC())
    df <- dfMAPAConsumo %>% filter(Producto %in% productosVitC) 
    g<-ggplot(df,aes(x=Fecha, y=df[[variableMAPAVitC()]],col=Producto))+
      geom_line( size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=3, col='red')+
      scale_x_date(date_breaks = 'months',date_labels = "%b %Y")+
      ylab(variableMAPA())+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      ggtitle(variableMAPAVitC())+ theme(legend.position = "none")
    ggplotly(g)
  })
  
  #TREEMAP COMERCIO EXTERIOR
  
  output$selAnyo_TreemapComExt<-renderUI({
    selectizeInput("selAnyo_TreemapComExt","Años",choices=unique(comExtTreemap$YEAR),
                   multiple=TRUE,selected=unique(comExtTreemap$YEAR),
                   options = list(plugins= list('remove_button')))
  })
  
  output$selPais_TreemapComExt<-renderUI({
    selectizeInput("selPais_TreemapComExt","Países",choices=unique(comExtTreemap$REPORTER_COMUN),
                   #Por defecto ponemos los países con los que más operaciones hay
                   multiple=TRUE,selected=c("Alemania","Francia","Países Bajos","Italia","Portugal","Polonia","Bélgica","Grecia"),
                   options = list(plugins= list('remove_button'),minItems=1))
  })
  
  anyoTreemapComExt<-reactive({
      return(input$selAnyo_TreemapComExt)
  })
  
  paisTreemapComExt <- reactive({
      return(input$selPais_TreemapComExt)
  })
  
  output$treemapComExt <- renderPlot({
    if(is.null(anyoTreemapComExt()) | is.null(paisTreemapComExt())){
      " "
    }else{
    comExtTreemap %>% filter(YEAR %in% anyoTreemapComExt() & REPORTER_COMUN %in% paisTreemapComExt())%>%
      ggplot(aes(area = value, fill=REPORTER_COMUN, label = REPORTER_COMUN)) +
      geom_treemap(colour="black") +
      facet_grid(vars(rows=YEAR),vars(cols=Movimiento)) + 
      theme(legend.position = "none")+
      geom_treemap_text(colour = "white", place = "centre",grow = F)
    }
  })
  
  # Lineplots comercio exterior
  
  output$lineComExtEur<- renderPlotly({
    print(head(comercioExterior))
    p<-comercioExterior %>%
      group_by(PERIOD) %>%
      summarise('Exp(€)' = sum(VALUE_IN_EUROS_IMPORT, na.rm = T),
                'Imp(€)' = sum(VALUE_IN_EUROS_EXPORT, na.rm = T)) %>%
      ggplot()+
      geom_line(aes(x=PERIOD, y=`Exp(€)`), col='red')+
      geom_line(aes(x=PERIOD, y=`Imp(€)`), col='blue')+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "month",date_labels = "%b %Y")+
      ylab("Euros")+
      ggtitle('Evolución exportaciones e importaciones (euros)')
    ggplotly(p)
  })
  
  output$lineComExtTon<- renderPlotly({
    p<-comercioExterior %>%
      group_by(PERIOD) %>%
      summarise('Exp(ton)' = sum(QUANTITY_IN_100KG_IMPORT, na.rm=T)/10,
                'Imp(ton)' = sum(QUANTITY_IN_100KG_EXPORT, na.rm=T)/10) %>%
      ggplot()+
      geom_line(aes(x=PERIOD, y=`Exp(ton)`), col='red')+
      geom_line(aes(x=PERIOD, y=`Imp(ton)`), col='blue')+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=4, col='red')+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      scale_x_date(date_breaks = "month",date_labels = "%b %Y")+
      ylab("Toneladas")+
      ggtitle('Evolución exportaciones e importaciones (toneladas)')
    ggplotly(p)
  })
  
  
  ## TABPANEL PRECIOS
  
  output$selectAndalucia <- renderUI({
    selectInput('selectAndalucia', 'Selecciona los subsectores', 
                choices = unique(andalucia$SUBSECTOR), 
                selected = c('Citricos', 'Frutales no cítricos', "Hortícolas al aire libre", 
                             'Hortícolas protegidos'), 
                multiple = T)
  })
  
  output$preciosAndalucia <- renderPlotly({
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
    selectInput('selectMadrid', 'Selecciona las familias', 
                choices = unique(mercaMadrid$familia), 
                selected = c('FRUTAS', 'HORTALIZAS'), 
                multiple = T)
  })
  
  output$preciosMadrid <- renderPlotly({
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
    selectInput('selectBarna', 'Selecciona las familias', 
                choices = unique(mercaBarna$familia), 
                selected = c('FRUTAS CÍTRICOS', 'FRUTAS HUESO', 'FRUTAS SEMILLA',
                             'HORTALIZAS BULBOS', 'HORTALIZAS FRUTO', 'HORTALIZAS INFLORESC.',
                             'HORTALIZAS TALLOS'), 
                multiple = T)
  })
  
  output$preciosBarna <- renderPlotly({
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
      labs(x='Fecha', y='Índice', title='Índice')
    
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
      labs(x='Fecha', y='Índice', title='Variación anual')
    
    ggplotly(p) %>% layout(legend = list(orientation = "h", x = 0.4, y = -0.4))
    
  })
  
})