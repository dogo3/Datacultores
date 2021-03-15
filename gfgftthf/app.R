#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

gif <- paste0("https://i.pinimg.com/originals/17/04/1b/17041b6908ddd354c369b7bcb095823a.gif")

loading_screen <- tagList(
    h3("Datacultores", style = "color:gray;"),
    img(src = gif, height = "300px")
)

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    use_waiter(),

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    w <- Waiter$new(html = loading_screen, color = "white")
    w$show()
    Sys.sleep(3) 
    w$hide()
    

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
