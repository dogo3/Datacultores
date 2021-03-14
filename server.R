library(ggplot2)

top5Productos<-c("PATATAS FRESCAS","NARANJAS","TOMATES","PLATANOS","MANZANAS")
totalesMAPA <- c('T.HORTALIZAS FRESCAS', 'T.FRUTAS FRESCAS')
productosVitC <- c("KIWI","NARANJAS","MANDARINAS","BROCOLI")
dfMAPAConsumo <- readRDS("data/app/MAPAConsumo.rds")
preciosAndalucia <- readRDS("data/app/preciosAndalucia.rds")
preciosMadrid <- readRDS("data/app/preciosMadrid.rds")
preciosBarna <- readRDS("data/app/preciosBarna.rds")
IPC <- readRDS("data/app/IPC.rds")


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
    p<-ggplot(df,aes(x=Fecha, y=df[[variableMAPAVitC()]],col=Producto))+
      geom_line( size=0.5)+
      geom_vline(xintercept = as.numeric(as.Date('2019-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-01-01')), linetype=4)+
      geom_vline(xintercept = as.numeric(as.Date('2020-03-01')), linetype=3, col='red')+
      scale_x_date(date_breaks = 'months',date_labels = "%b %Y")+
      ylab(variableMAPA())+
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
      ggtitle(variableMAPAVitC())+ theme(legend.position = "none")
    ggplotly(p)
  })
})