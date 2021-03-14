library(ggplot2)

top5Productos<-c("PATATAS FRESCAS","NARANJAS","TOMATES","PLATANOS","MANZANAS")
dfMAPAConsumo <- readRDS("data/app/MAPAConsumo.rds")


shinyServer(function(input, output) {
  
  
  output$selProd_MAPA<-renderUI({
    selectizeInput("selProd_MAPA","Productos",choices=unique(dfMAPAConsumo$Producto),multiple=TRUE,selected=top5Productos,options = list(plugins= list('remove_button')))
  })
  output$selVar_MAPA<-renderUI({
    selectInput("selVar_MAPA","Productos",choices=colnames(dfMAPAConsumo)[c(-seq_len(5),-12:-19)],selected=c("Gasto per capita"))
  })
  
  
  variableMAPA<-reactive({
    if(input$checkbox_diffMAPA){
      return(paste("Diff",input$selVar_MAPA))
    }else{
      return(input$selVar_MAPA)
    }
  })
  
  listaProductosMAPA<-reactive({
    if(is.null(input$selProd_MAPA)){
      return(top5Productos) 
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
})